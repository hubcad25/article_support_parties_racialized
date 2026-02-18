# article_support_parties_racialized

## Data Setup

### Prerequisites

- R with required packages:
  - `ces` (for downloading Canadian Election Study data)
  - `dplyr`, `haven`, `tidyr` (for data cleaning)

- Python 3 with `pdftotext` (for codebook conversion):
  - Ubuntu/Debian: `sudo apt-get install poppler-utils`
  - macOS: `brew install poppler`

### Getting Raw Data

Run download script from project root:

```bash
R --no-restore --no-save < scripts/01_download_ces_2021.R
```

This will download:
- `data/raw/ces_2021/ces_2021.dta` (raw survey data, ~300MB)
- `data/raw/ces_2021/ces_2021_codebook.pdf` (questionnaire documentation)

### Converting Codebook

Convert PDF codebook to markdown for easier exploration:

```bash
python3 scripts/03_convert_codebook.py
```

Output: `data/raw/ces_2021/ces_2021_codebook.md`

### Cleaning Data

Clean data (SES variables):

```bash
R --no-restore --no-save < scripts/02_clean_ces_2021.R
```

Output: `data/clean/ces_2021.rds`

### Project Structure

```
data/
  raw/           # Raw downloaded data
    ces_2021/
  clean/         # Cleaned, analysis-ready data

scripts/         # Data processing scripts
  01_download_ces_2021.R
  02_clean_ces_2021.R
  03_convert_codebook.py

R/              # R functions
  compute_rci.R
```
