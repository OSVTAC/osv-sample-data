# osv-sample-data Data Format Documentation

This file describes the format for election files in this sample data repository.

## `out-orr` Converted Election Deinition and Results

This subdirectory contains the information on the election definition and
updated computer-readable results used by the `osv-results-reporter` to create
html, pdf, etc. reports. This data may also be useful for other results data
analysis applications.

### Results data organization

The computer-readable result data files were created with the following
design goals:

  * Compact and easy to parse TSV files with detailed results data
  * Predictable (well defined) fixed order for rows and columns
  * Uses fixed IDs for headings and candidate/choices, with full international text contained in the election definition.
  * Result summary information and election definitions provided in JSON

IDs are used rather than English phrases to allow set constant values to
be used in software to reliably compare. The IDs map to multi-lingual text
contained in the election definition file,
where the specific words used might change for a locality.

#### Result Stats

Besides candidate/choice votes, results reported include a number of statics
including undervotes (blank votes), overvotes (2 or more selections made
for 1 candidate elected), total votes, etc. Each of these result stats
is assigned an abbreviated ID beginning with `RS`, e.g. `RSUnd, RSOvr, RSTot`.
The English and other translations for these stats is included in the
`election.json` file. These IDs are intended to be stable, while the English
or other translations might change.

The combination of result stats and candidate vote counts form the columns
of the result data tables. The candidate counts always follow the result
status.

Some contests allow write-in candidates (and others do not). The result
stat `RSWri` will be included to report the total unidentified write-in
selections made.  Additional columns might be added as write-in candidate names
are found and added to the list of known candidated. Write-in candidates
will always be at the end of a row. When votes for an identified write-in
candidate are known and reported in a candidate column, the values will
not be included in the `RSWri` stat.

The result stats reported depend on the contest (or turnout).
For an RCV contest, the `RSExh` "Exhausted Ballots" stat will be
included, and the `RSWri` is included only for certain contests.
To identify the characteristics of the contest,
Aa`result_style` ID is include in the contest definition
and references a set of characteristics including `result_stat_type_ids` a space separated list
of result stat IDs that will be provided for that contest. The order of IDs
in the list of `result_stat_type_ids` will match the column order in the
result data.

#### Voting Groups

Besides a total, separate subtotals may be defined for a specified list
of voting groups that might include, precinct (election day poll  place) voting,
vote by mail, early voting, provisional voting, etc. The result style
also incudes `voting_group_ids` a space separated list of voting group
IDs that will be used (e.g. `TO` for Total, `ED` for Election Day,
`MV` for Vote By Mail). The first voting group
ID is always `TO` representing the total (the total is reported first,
then subtotals). As with Result Stat IDs, the English and translations
for the Voting Group IDs are included in the `election.json` file.

#### Area Subtotals

In addition to total votes and result stats for a contest, the detailed
reporting includes subtotals by areas. Areas include
precinct subtotals each with a breakdown of voting group subtotal.
Also, the overall election area for a contest may be subdivided by
a set of summary districts, e.g. neigboorhood, legislative districts,
supervisorial (county legislative) district, etc. So vote totals by
neighboorhood, etc. are reported, typically only with a single total
rather than breakdown by voting group.

The `ALLPCTS` area ID is reserved to represent the total over all precincts
in the contest, and is given first in result files. Precinct IDs begin
with the prefix `PCT`, and district IDs depend on the local EMS definitions.
The `election.json` file contains a full name, short name, and classification
in English with translations, for each area ID.

The `contest.voting_district` in the `election.json` file identifies
the area ID for voting on that contest. The area definition with matching
ID has the `reporting_group_ids` space separate list of (area,voting-group)
IDs combined with a `~` separator, e.g. `PCT1109~ED`. The reporting_group_ids
list will list the rows expected in the detailed results (excluding RCV
rounds).

### `election.json` - Election Definition

The `election.json` file contains a full definition of the election including
what results will be reported. It is valid across the election reporting cycle
and is independent of the results. A detailed description is elsewhere (TODO).
Some highlights relevant to the results data files are given here.

  * `contests[]._id` - contains the ID used in a results tsv filename.
  * `contests[].choices[]._id` - contains the ID for candidates contained in results data file header lines.
  * `contests[].result_style` - Contains a result_style ID describing the set of data to be reported
  * `contests[].voting_district` - Contains the area ID for the elected-by district for the contest, leading to the reporting_group_ids.
  * `turnout.result_style` - Contains a result_style ID describing the set of data to be reported for turnout
  * `result_styles[]._id` - Matches the contests[].result_style ID
  * `result_styles[].result_stat_type_ids` - Space separated result_stat IDs contained in the results tsv file header.
  * `result_styles[].voting_group_ids` - Space separated list of voting_group subtotals, the second column in a results tsv file.
  * `result_stat_types[]._id` - The ID for a statistic used in results tsv file header lines.
  * `result_stat_types[].heading` - The English description for the result stat.
  * `voting_groups[]._id` - subtotal ID used in the second column in a results tsv file.
  * `voting_groups[].heading` - Text describing the voting group.
  * `areas[]._id` - Area ID used in column 1 of a results tsv file, representing a precinct, district, or all precincts.
  * `areas[].classification` - Name for the category of the area
  * `areas[].name` - Full name for the precinct/district
  * `areas[].short_name` - Shortened name for the precinct/district
  * `areas[].reporting_group_ids` - Contains the space separate list of _area~voting_group_ ID pairs contained in the rows of results tsv files.

### `resultdata` - Subdirectory with updated results

#### `resultdata/results-`_contest_id_`.tsv`

Contains a tab-separated-values file with results for a particular contest. Each
row represents subtotals for a particular area (precinct or district) and
voting group. Columns 1 and 2 of each row have the area ID and voting group ID,
followed by integer vote values.

The first line is a header line containing a description of the columns specific
to the contest. Header columns up are result_stat_type IDs followed by a column
for each candidate. A candidate column header is the `choices[]._id` (candidate ID)
followed by the candidate/choice name with a '`:`' separator.

For a contest with RCV rounds, the RCV elimination results (with totals for
all precincts) are given in rows following the header line. Each row has a
pseudo-area `RCV` followed by the round number, ordered from the final
elimination round to RCV1. Only the `TO` Total voting group is included.

The first row or row following RCV rounds will be the totals for the ALLPCTS ID
representing all precincts in the contest. Then the ALLPCTS is repeated for each voting_group ID.

Following the ALLPCTS rows, there will be a row for each voting group for each
precinct, followed by subtotals for each district (just the TO total voting group).

#### `resultdata/contest-status.json`

The `contest-status.json` contains a (redundant) set of result summary information
(the `ALLPCTS` totals by voting group) for candidate/choices and result
stats for each contest. The `contest._id` will match the contest ID and
full definition in the `election.json` file.
The `contest.result_stats[]` and `contest.choices[]` have the same format,
an ID (result stat ID or candidate/choice ID) to identify the stat or choice,
and a `results` list, one value for each voting group ID defined for the contest.
A heading or English-only candidate name is included as a convienience,
but the full definitions should be obtained from the `election.json`.

For a contest, the `precincts_reporting` and `total_precincts` are given,
giving the election-day precinct reporting status. The `reporting_time`
is the last update for results reporting for a contest.

For ballot measures, recall, or approval voting (e.g. yes/no to retain
an elected official) the `success` true/false indicates if the measure
passed with percentage depending on the approval required.

On each individual choice, there is a true/false `success` as well as
`winning_status` a more detailed code explaining the status, including
advancing to a runoff. Note that the `success` and `winning_status` apply
to the votes counted thus far, so may change until the final results are
certified.

Each contest also includes a list of precincts that are in the voting
area for the contest but have no voters, so are excluded from detailed
reporting.

