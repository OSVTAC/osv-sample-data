# osv-sample-data
Data repository to store various real-world election data. This is
unofficial data intended to be used to test open-source voting software.

Data is divided by election date. Some data (e.g. street-precinct
and precinct-district definitions) may carry across elections. A symbolic
link might be used to avoid duplication.

Currently, only San Francisco data is included. Later multiple counties and/or
state data may be added with a subdirectory within a state.

A description of the subdirectory structure and file content is:

* **`resultdata`** - Source for converted results data loaded by ORR
    * **`resultdata-raw.zip`** - Downloaded source data
    * **`getsfresults.sh`** - Script to download source data
    * **`convsfresults.sh`** - Script to access data converter
    * **`pctturnout.tsv`** - Turnout by precinct (not currently used by ORR)
    * Other intermediate file extracts are documented with the Open Data Converter

* **`out-orr`** - Converted computer readable results data used by ORR
  [See `DATAFORMAT.md` for data format documentation.](DATAFORMAT.md)
  This data can be used by other applications for results processing
  including AJAX APIs.
  * **`election.json`** - Election definition (valid for the election cycle)
  * **`resultdata`** - Latest converted results (updated during the reporting cycle)
        * **`results-`###`.tsv`** - Result detail data for each contest loaded by ORR
        * **`contest-status.json`** - JSON results summary data loaded by ORR

* **`omniballot`** - Downloaded Accessible Sample Ballot json
    * **`bt`** - Json source data for each ballot type

* **`ems`** - Source and converted Election Management System (EMS) data
    * **`ems-raw.zip`** - Downloaded DFM EIMS export files
    * **`getsfems.sh`** - Script to invoke the data downloader
    * **`distname-orig.tsv`** - Original abbreviated district name and ID code
    * **`distclass.tsv`** - District code, classification, full name, short name
    * **`distextra.tsv`** - Additional district codes and names defined by
        combinations of other district codes (for countywide and at-large)
    * **`pctdist.tsv.gz`** - District ID list for each precinct
    * **`distpct.tsv.gz`** - Precinct ID list for each district ID
    * **`zippct.tsv.gz`** - Precinct ID list for each zip code
    * **`zip.sort.gz`** - Sorted CSV file of street address range to precinct
    * **`pctshapefiles.zip`** - Downloaded shapefiles for precincts and supervisorial districts.

* **`btpdf`** - Sample ballot PDFs for each ballot type
* **`ballot-blanks`** - PDFs of selected official ballots
* **`ballot-scans`** - Sample scans of marked ballots

Also a survey of California results data with many reporting formats is
provided in `2018-11-06/samplesurvey.md`. Comments include a measurement of
download size and time.

