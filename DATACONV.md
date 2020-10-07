# Notes on Data Conversions

This file contains some notes and procedures for setting up a new election
and converting data from the election administration.

Sample data provided currently was converted from the County of San Francisco
department of elections.

# Setting up a new election

No scripts currently exist to setup a new election. To manually setup a
new election (using SF scripts as an example) use:

```
mkdir -p 2020-11-03/ca/sf
cd 2020-11-03/ca/sf
mkdir ems omniballot out-orr resultdata
```
Shell scripts and config files can be copied from a prior election.
Copy `config* *.sh` from each of the subdirectories `ems omniballot resultdata`.

# Converting DFM EMS Data

## Download election data

Edit the `getsfems.sh` to change the election date prefix for the data downloads,
then run the script.

## Update the `config-ems.yaml`

The data conversion scripts read `config-ems.yaml` to customize conversions
and apply data corrections.

For a new election, the `randomized_alphabets` need to be changed to configure
the candidate rotation order. Order can also be extracted or verified from
the omniballot data or the `ems-raw.zip/EWMJ014.tsv` (extracted into the
`btcont.tsv`).

## Edit the `convsfems.sh`

There is no current script to configure the conversion process based on
available data downloads. This can be manually configured by editing
`convsfems.sh`.

## Copy the `distname.tsv` and `distcounty.tsv` files

The script to update the `distname-orig.tsv` with name corrections is not yet
implemented. Copy `distname.tsv distcounty.tsv` from prior data. (The current
data was obtained from `forms.smartvoter.org`.

## Run `convsfems.sh`

The `convsfems.sh` contains commands to process the full set of DFM data.
In order to run `dfm-distclass.py`


# Converting Omniballot data

## Download Omniballot data

The download script requires the county ID and election ID as parameters.
To find these, use a county lookup to to access the "Accessible Sample Ballot" with
link to omniballot. Use the browser developer tools to find the URL of
the json file loaded, e.g.
https://published.omniballot.us/06075/628/styles/lookups.json
with the 2 parameters 06075 and 628.

Edit the `getomniballot.sh` to update the election ID, then run
`getomniballot.sh`. This will create a `bt` subdirectory with
ballot json.

## Edit config-omni.yaml

- Set `approval_required` for each measure/proposition if not >50%.
- Set/Clear `runoff`
- Set `short_description` for titles to measures/propositions
- Set `url_state_results_map`
- Set `turnout_party_ids` for turnout breakdown by party

## Run `convomniballot.sh`

The `convomniballot.sh` will extract the downloaded omniballot data.

## Run `matchcand.sh`

Run `matchcand.sh` if both ems data and results data is available. Otherwise
run only this line if an ems candidate list is available:
  matchcand.py -S .ems -v  $* 2>&1 |tee matchcand.ems.log
or this line if results is available:
  matchcand.py -v  $* 2>&1 |tee matchcand.log

This will create `candmap.tsv candmap.ems.tsv contmap.tsv contmap.ems.tsv distmap.ems.tsv`

## Rerun `convomniballot.sh`

After matching IDs and districts, another `convomniballot.sh` will create
the `../out-orr/election.json` with correct districts and external IDs.

## Notes on data format changes found

- Contest sequence numbers need to be 4 digits.

- President/Vice President have 3 titles, last is party. EMS has JOSEPH R. BIDEN AND KAMALA D. HARRIS

- RCV title no longer has number to rank. Needs to be computed by scanning
  contest titles for "nth Choice".

- Chinese puts heading in <strong> while other languages do not (just all caps).

