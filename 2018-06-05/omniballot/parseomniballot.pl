#!/usr/bin/perl

# parseomniballot.pl - Extract and reformat omniballot json

use utf8;

use JSON::XS;

use Getopt::Std; getopts('hdcT');

$infile = @ARGV[0];
$opt_h ||= $#ARGV!=0 || !-s $infile;

if ($opt_h) { print <<"END"; exit(0); }
Usage: parseomniballot.pl infile
    Options:
      -d copy default translation from English
      -c expand measure choices in json

END

@lang = qw(es tl zh);

open(IN,$infile);
read(IN,$jsoninp,10000000);
open(JSON,">contests.json");

$b = decode_json $jsoninp;

$bt = $$b{'code'};

$phrasetrans = {};
$partytrans = {};

$title = $$b{'election'}->{'title'};
$election = {'election_area'=>'City and County of San Francisco',
'election_area_es'=>'Ciudad y Condado de San Francisco',
'election_area_tl'=>'Lungsod at County ng San Francisco',
'election_area_zh'=>"舊金山市"
};

$hdrid = "HDR00";

map {
    /(.*)=(.*):(.*)/;
    $headerlevel{$1}=$2;
    $headerclass{$1}=$3;
} split(/\n/,<<'END');
Voter-Nominated and Nonpartisan Offices=0:Instructions
VOTER-NOMINATED OFFICES=0:Office Group
STATE=1:Office Category
FEDERAL=1:Office Category
NONPARTISAN OFFICES=0:Office Group
CITY AND COUNTY=1:District Name
JUDICIAL=2:Office Category
SCHOOL=1:Office Category
MEASURES SUBMITTED TO THE VOTERS=0:Measure Group
STATE PROPOSITIONS=1:Measure Category
REGIONAL MEASURE=1:Measure Category
CITY AND COUNTY PROPOSITIONS=1:Measure Category
END

conv_attr($election,'ballot_title',$title);
$$election{'ballot_title'}=~s/^(20\d\d-\d\d-\d\d) //;
$$election{'election_date'} = $1;

$subtotalTypes = [
{'id'=>'TO','heading'=>'Total'},
{'id'=>'ED','heading'=>'Election Day'},
{'id'=>'MV','heading'=>'Vote by Mail'}
];

$subtotalTypes = [
{'id'=>'TO','heading'=>'Total'},
{'id'=>'ED','heading'=>'Election Day'},
{'id'=>'MV','heading'=>'Vote by Mail'}
];

@resultAttrs = @resultattrsRCV = map {
    /('.*'), ('.*')/;
    {'id'=>$1,'ballot_title'=>$2}
} split(/\n/,<<'END');
    ('SVTot', 'Ballots Counted'),   # Sum of valid votes reported
    ('SVCst', 'Ballots Cast'),      # Ballot sheets submitted by voters
    ('SVReg', 'Registered Voters'), # Voters registered for computing turnout
    ('SVTrn', 'Voter Turnout'),     # (SVCst/SVReg)*100
    ('SVRej', 'Ballots Rejected'),  # Not countable
    ('SVUnc', 'Ballots Uncounted'), # Not yet counted or needing adjudication
    ('SVWri', 'Writein Votes'),     # Write-in candidates not explicitly listed
    ('SVUnd', 'Undervotes'),        # Blank votes or additional votes not made
    ('SVOvr', 'Overvotes'),         # Possible votes rejected by overvoting
    ('SVExh', 'Exhausted Ballots')  # All RCV choices were eliminated (RCV only)
END

pop(@resultAttrs);

@measureAttrs = map {
    /('.*'), ('.*')/;
    {'id'=>$1,'ballot_title'=>$2}
} split(/\n/,<<'END');
    ('SVTot', 'Ballots Counted'),   # Sum of valid votes reported
    ('SVCst', 'Ballots Cast'),      # Ballot sheets submitted by voters
    ('SVReg', 'Registered Voters'), # Voters registered for computing turnout
    ('SVTrn', 'Voter Turnout'),     # (SVCst/SVReg)*100
    ('SVRej', 'Ballots Rejected'),  # Not countable
    ('SVUnc', 'Ballots Uncounted'), # Not yet counted or needing adjudication
    ('SVUnd', 'Undervotes'),        # Blank votes or additional votes not made
    ('SVOvr', 'Overvotes'),         # Possible votes rejected by overvoting
END


foreach $_ (keys(%$election)) {
    next unless /ballot_title_\w+/;
    $$election{$_}=~s/^(20\d\d-\d\d-\d\d) //;
}

foreach $box (@{$$b{'ballot'}->{'boxes'}}) {
    $type = $$box{'type'};
    $id = $$box{'external_id'};
    $r = {"id"=>$id};
    $opt_T && print "box=$box id=$id type=$type\n";
    if ($type eq 'header' || $type eq 'text') {
        $i = 0;
        foreach $t (@{$$box{'titles'}}) {
            if ($i==0) {
                conv_attr($r,'ballot_title',$t);
                set_trans($phrasetrans,$t,'header');
           } elsif ($i==1 && $$t{'style'}=="subtitle") {
                if ($$t{'value'}=~/^Vote your .* choices$/) {
                    # heading is really a contest
                    $rcv = $r;
                    conv_attr($r,'vote_for_msg',$t);
                    set_trans($phrasetrans,$t,'vote_for');

                } else {
                    conv_attr($r,'ballot_subtitle',$t);
                    set_trans($phrasetrans,$t,'header');
                }
            } else {
            print "strange header $$box{'external_id'} subtitle $$t{'value'}\n";
            }
            $i++;
        }
        conv_text($r,'instructions_text',$$box{'text'});
        next if $rcv;
        $hdrid++;
        $$r{'id'}=$hdrid;
        $$r{'type'} = 'header';
        $ballot_title = $$r{'ballot_title'};
        $level = $headerlevel{$ballot_title};
        $$r{'classification'}=$headerclass{$ballot_title};
        $$r{'header_id'}=$level>0 && $lastheader[$level-1];
        $lastheader[$level] = $hdrid;
        push(@ballot_items,$r);
        push(@headers,$r);
        $lastheader = $r;
    } elsif ($type eq 'contest' || $type eq 'question') {
        $i = 0;
        $ismeasure = $type eq 'question';
        $$r{'type'} = $ismeasure ? 'measure' : 'office';
        $$r{'header_id'} = $hdrid;
        if (!$ismeasure) {
            $$r{'number_elected'} = $$box{'num_selections'};
        }
        foreach $t (@{$$box{'titles'}}) {
            if ($i==0) {
                $v = $$t{'value'};
                if ($v eq "1. FIRST CHOICE") {
                    if (!$rcv) {
                         print "strange rcv $$box{'external_id'}  $$t{'value'}\n";
                    }
                } elsif ($v=~/^\d\. .* CHOICE$/) {
                    # skip this contest
                    goto nextbox;
                } else {
                conv_attr($r,'ballot_title',$t);
                set_trans($phrasetrans,$t,'contest');
                }
            } elsif ($$t{'value'}=~/^Vote (your|for) /) {
                conv_attr($r,'vote_for_msg',$t);
                set_trans($phrasetrans,$t,'vote_for');
            } elsif ($i==1 && $$t{'style'}=="subtitle") {
                if ($$t{'value'}=~/^Vote your .* choices$/) {
                    # heading is really a contest
                    $rcv = $r;
                    conv_attr($r,'vote_for_msg',$t);
                    set_trans($phrasetrans,$t,'vote_for');

                } else {
                    conv_attr($r,'ballot_subtitle',$t);
                    set_trans($phrasetrans,$t,'header');
                }
            } else {
                print "strange header $$box{'external_id'} subtitle $$t{'value'}\n";
            }
            $i++;
        }
        $isrcv = $rcv;
        if ($rcv) {
            $r = $rcv;
            $$r{'id'} = $id;
            $$r{'vote_type_id'} = 'rcv';
            $$r{'number_elected'} = 1; # Hack! True not known
            $rcv = '';

        }
        @{$$r{result_attributes}} = $ismeasure ? @measureAttrs :
            $isrcv ? @resultattrsRCV : @resultAttrs;
        $$r{subtotal_types} = $subtotalTypes;
        $ch=process_choices($$box{'options'},$r);
        ($opt_c || !$ismeasure) && ($$r{'choices'}=$ch);
        if ($ismeasure) {
            combine_choice_names($ch,$r);
            conv_text($r,'question_text',$$box{'text'});
        }

        push(@ballot_items,$r);
        push(@contests,$r);
        push(@{$contestsbyhdr{$hdrid}},$r);
    } else {
             print "strange $type box $$box{'external_id'}\n";
             print $box," (",join(",",sort(keys(%{$box}))),")\n";

    }
    nextbox:;
}

sub process_choices {
    my($a,$contest)=@_;
    my($choices,$c);
    local($inMeasureChoice)=$ismeasure;
    foreach $c (@{$a}) {
        my $r = {"id"=>$$c{'external_id'}};
        my $i=0;
        if ($$c{'type'} eq 'writein') {
            $$contest{'writeins_allowed'}++;
            next;
        }
        foreach $t (@{$$c{titles}}) {
            if ($i==0) {
                conv_attr($r,'ballot_title',$t);
                $ismeasure && set_trans($phrasetrans,$t,'measure_choice');
            } elsif ($$t{'value'}=~/^Party Preference/) {
                $v = conv_attr($r,'candidate_party',$t);
                set_trans($partytrans,$t,'party_pref');
                foreach $l (@lang) {

                }
                $$contest{'is_partisan'} = 'Y';
            } elsif ($$t{'style'} eq "subtitle") {
                conv_attr($r,'ballot_designation',$t);
            }
            $i++;
        }
        push(@{$choices},$r);
    }
    return($choices);
}

sub combine_choice_names {
    my($choices,$r)=@_;
    my $sep = '';
    my($l);
    foreach $c (@{$choices}) {
        while (($k,$v)=each(%{$c})) {
            next unless ($l)=$k=~/^ballot_title(_\w+)?$/;
            $$r{"choice_names$l"}.=$sep.$v;
        }
        $sep = ';'
    }
}

sub conv_text {
    my($r,$attrname,$text) = @_;
    my $i=0;
    for $t (@{$text}) {
        if ($i==0) {
            conv_attr($r,$attrname,$t);
        } else {
            print "Strange text $$t{'value'}\n";
        }
        $i++;
    }
}


sub conv_attr {
    my($r,$attrname,$a) = @_;
    my ($v,$l,$retval,$t);
    $retval = $$r{$attrname} = reform_html($$a{'value'},$attrname,'',$r);
    for $l (keys(%{$t=$$a{'translations'}})) {
        $v = $$t{$l};
        next unless $v ne '';
        $l=~s/-.*//; # trim to 2 letter extension
        $$r{$attrname."_$l"} = reform_html($v,$attrname,$l,$r);

    }
    # default is same as English
    if ($opt_d||$inMeasureChoice) {
        map {$$r{$attrname."_$_"}||=$$r{$attrname}} @lang;
    }
    return $retval;
}

sub set_trans {
    my($r,$a,$context) = @_;
    my ($en,$v,$l);
    $en=$$a{'value'};
    return unless $en ne '';
    for $l (keys(%{$t=$$a{'translations'}})) {
        $v = $$t{$l};
        next unless $v ne '';
        $l=~s/-.*//; # trim to 2 letter extension
        if (($v2=$$r{$l}->{"$en|$context"}) ne '') {
            if ($v ne $v2) {
                print "Duplicate mapping: $context|$en=>$l '$v'!=$v2\n";
            }
        } else {
            $$r{$l}->{"$context|$en"}=$v;
        }
    }
}

sub reform_html {
    my($v,$attrname,$l,$r)=@_;
    $v=~s`^<p>``i;
    $v=~s`</p>$``i;
    if ($attrname eq 'instructions_text') {
        if ($v=~s`^<strong>(.*?)\.?</strong><br />``) {
            $$r{$l ? "ballot_title_$l":'ballot_title'} = $1;
        }
    }
    return($v);
}

sub filterHeaders {
    my $t = shift(@_);
    my $l = shift(@_);
    return map {
             $i18n_copy{$_} ? $_ :
             !$i18n_headers{$_} ? () :
             ($t=~/^C/ && $_ eq "ballot_title" && !$candnameLang{$l}) ? $_ :
             ($_,"${_}_$l")

    } @_;

}

sub psvline {
    my $t = shift(@_);
    my $r = shift(@_);
    print PSV "$t|",join("|",map{$$r{$_}}@_),"\n";
    foreach $l (@lang) {
         print {$file{$l}} "$t|O||",join("|",map{$$r{$_}}filterHeaders($t,$l,@_)),"\n";
    }

}

sub psvhead {
    my $t = shift(@_);
    print PSV "$t|",join("|",@_),"\n";
    foreach $l (@lang) {
         print {$file{$l}} "$t|status|updated|",join("|",filterHeaders($t,$l,@_)),"\n";
    }
}

@i18n_headers = qw(ballot_title ballot_subtitle instructions_text
    ballot_designation question_text);

map {$i18n_headers{$_}=1;} @i18n_headers;
map {$candnameLang{$_}=1;} qw(zh);
map {$i18n_copy{$_}=1;} qw(id);

@H_headers = qw(id ballot_title ballot_subtitle instructions_text);
@O_headers = qw(id ballot_title ballot_subtitle vote_for_msg number_elected );
@C_headers = qw(id ballot_title candidate_party ballot_designation);
@M_headers = qw(id ballot_title ballot_subtitle question_text choice_names);

open(PSV,">contests.psv");
binmode(PSV, ":utf8");
foreach $l (@lang) {
    open($file{$l},">contests.$l.psv");
    binmode($file{$l}, ":utf8");
}

psvhead("H=headers:Header",@H_headers);
psvhead("O=contests:OfficeContest",@O_headers);
psvhead("C=choices:Candidate",@C_headers);
psvhead("M=contests:MeasureContest",@M_headers);

foreach $h (@headers) {
    psvline("H0",$h,@H_headers);
    next unless $contests=$$h{'contests'};
    $hdrid = $$h{'id'};
    foreach $c (@{$contestsbyhdr{$hdrid}}) {
        if ($$c{'type'} eq 'office') {
            psvline("O1",$c,@O_headers);
            foreach $ch (@{$$c{'choices'}}) {
                psvline("C2",$ch,@C_headers);
            }
        } else {
            psvline("M1",$c,@M_headers);
       }
    }
}

$$election{'ballot_items'} = [@ballot_items];
print JSON JSON::XS->new->utf8->pretty(1)->encode($election);

put_trans($phrasetrans,"trans-phrase");
put_trans($partytrans,"trans-party");

sub put_trans {
    local($trans,$name)=@_;
    foreach $l (@lang) {
        $h = $$trans{$l};
        open(TRANS,">$name.$l.psv\n");
        binmode(TRANS, ":utf8");
        foreach $k (sort(keys(%{$h}))) {
            print TRANS "$k|$$h{$k}\n";
        }
        close(TRANS);
    }
}


