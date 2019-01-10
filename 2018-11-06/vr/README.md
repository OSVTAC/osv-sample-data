# Voter Registration Statistics

## California Secretary of State

Collected/Generated reports y election are indexed at:
https://www.sos.ca.gov/elections/report-registration/

The latest report prior to the november election:
https://www.sos.ca.gov/elections/report-registration/15-day-gen-2018/

### county.tsv - Registration by County

https://elections.cdn.sos.ca.gov/ror/15day-gen-2018/county.xlsx

Has registation by party for each county and "State Total". The
Eligible field is computed based on Census population estimates.

    Field Name                     Sample
    -------------------------------------------------------------
    1  County                         Alameda
    2  Eligible                       1089154
    3  Total Registered               881491
    4  Democratic                     490683
    5  Republican                     97377
    6  American Independent           16413
    7  Green                          6701
    8  Libertarian                    4660
    9  Peace and Freedom              2688
    10  Unknown                        30
    11  Other                          5858
    12  No Party Preference            257081

### politicalsub.tsv - Registration by Political Subdivision by County

https://elections.cdn.sos.ca.gov/ror/15day-gen-2018/politicalsub.xlsx

Has registration by party for each county and major subdivision (e.g. city)
within a county.

    Field Name                     Sample
    -------------------------------------------------------------
    1                                 Alameda
    2                                 County Supervisorial 1
    3  Total Registered               163408
    4  Democratic                     68613
    5  Republican                     32464
    6  American Independent           3893
    7  Green                          482
    8  Libertarian                    1101
    9  Peace and Freedom              321
    10  Unknown                        2
    11  Other                          1090
    12  No Party Preference            55442

### age.tsv - Registration by Age Range by County

https://elections.cdn.sos.ca.gov/ror/15day-gen-2018/age.xlsx

Has registration by age group for each county. Groups of 3 lines,
blank, registration, computed percentage.

    Field Name                     Sample
    -------------------------------------------------------------
    1  County                         Alameda
    2  Total Registered               881491
    3  17.5* - 25                     100909
    4  26 - 35                        169667
    5  36 - 45                        150689
    6  46 - 55                        151820
    7  56 - 65                        143927
    8  66+                            164479

