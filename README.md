# WordStats Script

## Overview
This script (`wordStats.sh`) is used to analyze word frequencies in text files. It can filter stop words, generate word count statistics, and create visualizations of the most common words found in a given input file.

## Usage
```bash
./wordStats.sh <MODE> <INPUT> [LANGUAGE]
```
- `<MODE>`: The operation mode (Cc | Pp | Tt)
- `<INPUT>`: The input file (must be `.txt` or `.pdf`)
- `[LANGUAGE]` (optional): The language for stop word filtering (default: English)

### Example
```bash
./wordStats.sh c sample.txt en
```

## Modes
| Mode | Description |
|------|-------------|
| `c` or `C` | Counts words in the file, filters stop words based on language |
| `p` or `P` | Displays the top N words, with or without stop words |
| `t` or `T` | Filters stop words and displays the top N words |

## Requirements
- `pdftotext` (for PDF support)
- `gnuplot` (for visualization)
- `firefox` (to display the HTML output)

## Features
- Automatically detects `.pdf` and converts it to `.txt`
- Uses stop word lists (`StopWords/en.stop_words.txt` and `StopWords/pt.stop_words.txt`)
- Generates bar charts of word frequencies using `gnuplot`
- Outputs an HTML report with results

## Output
- Processed word frequency list (`result---<FILENAME>`)
- PNG bar chart (`result---<FILENAME>.png`)
- HTML report (`result---<FILENAME>.html`)

## Authors
- Tomás Pereira - 2201785
- João Ferreira - 2201795
