# Ballot Scans Directory

This directory contains scans of a small selection of actual ballots that
were cast and counted in San Francisco's June 5, 2018 election.

The scans are PDFs and all of vote-by-mail ballots. There are 180 pages in
all. The scans were provided to the OSVTAC by the San Francisco Department of
Elections.

Each set is from a different precinct, with 2-4 ballots with side A & B of
sheets 1-4.

Page size is 11" x 17" 3300 x 5100 (300dpi), about 17Mp. Some are 8 bit
rgb saved as jpg, some are 1 bit dithered grayscale saved as ccitt.

Most are English/Chinese with a few English/Spanish.

The files are--

* `VBM_1126_Image.pdf` (26 pages) Precinct 1126, Ballot Type 1
* `VBM_7503_Image.pdf` (26 pages) Precinct 7503, Ballot Type 7
* `VBM_7834_Image.pdf` (28 pages) Precinct 7835, Ballot Type 10
* `VBM_7857_Image.pdf` (30 pages) Precinct 7857, Ballot Type 10
* `VBM_7902_Image.pdf` (35 pages) Precinct 7902, Ballot Type 11
* `VBM_9237_Image.pdf` (35 pages) Precinct 9237, Ballot Type 14

The file `imageinfo.txt` contains the `pdfimages -list` output with
a summary of size (pixel and total MB), and format (either RGB jpeg compressed,
or 1 bit dithered grayscale with ccitt (fax) compression.

The `pdfimages` command can be used to extract individual image files
from the PDF.
