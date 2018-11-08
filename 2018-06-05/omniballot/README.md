Omniballot is used by SF for multilingual sample ballots and uses
javascript to render a ballot from json data. The parseomniballot.pl
converts the json to an internal format. (I wrote it in perl because I
thought it would be easier, but probably should have used python.)

(The omniballot site might be used for RAVBM http://sfelections.org/tools/ravbm/ )

13645_0_465.pp.json is ballot type 9.

https://sites.omniballot.us/06075/app/sb?bs=9&lang=en

This gets json from:
https://s3-us-west-2.amazonaws.com/liveballot4published/06075/463/styles/13645_0_465.json

Data is reformatted into a set of delimited text files (pipe-separated-values).
Contest data is output to psv with multiple record types-- the first column
identifying the record type and nesting level.

Ballots become a list of headers, with ordered contests within a header,
then for an OfficeContest, candidate choices. The json file can include
measure choices, but the psv file condenses the choice list to a ; separated
list, usually "YES;NO".

Common language mapping is written to a trans-<type>.lang.psv file,
which has a context, English, and translated text value. Translators can
edit this file to add new headings, contest names, etc.

The translated columns in the contest definition are written to a
contests.es.psv which has the English and Spanish, etc. titles. Commonly
used phrases like vote_for_msg is placed in the trans-phrase.es.psv, etc.
Translators can update the contests.es.psv for new wording added.

The contests.json has merged translations with alternate attributes
using a _XX suffix, where XX is the 2 letter language code.

Note measures are now identified by letter/number independent of language.
Instead of using ballot_title, it might be better to use a separate attribute.

TODO:
* Download all ballot types and merge to make a combined ballot
* Extract candidate rotations