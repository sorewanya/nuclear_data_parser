# Nuclear Data Parser to CSV and dart classes

A Dart script for parsing and combining nuclear data from AME (Atomic Mass Evaluation), NUBASE, and reaction data files into a unified CSV format.

## Files
files mass_1.mas20.txt rct1.mas20.txt rct2_1.mas20.txt nubase_4.mas20.txt:
[https://www-nds.iaea.org/amdc/]

## Features

- Parses three main data sources:
  - `mass.mas20` - Atomic mass data from AME2020
  - `nubase.mas20` - Nuclear properties from NUBASE2020
  - `rct1.mas20` and `rct2.mas20` - Nuclear reaction data

- Combines all data into a comprehensive CSV file with:
  - Basic nuclide information (A, Z, element)
  - Mass excess values and uncertainties
  - Binding energies
  - Half-life information
  - Spin/parity data
  - Reaction energies (S(n), S(p), Q-values)

## File Formats Supported

- AME2020 mass table format (`mass.mas20`)
- NUBASE2020 format (`nubase.mas20`)
- AME reaction data format (`rct1.mas20`, `rct2.mas20`)

## Usage

1. Place input files(from [https://www-nds.iaea.org/amdc/]) in the specified directory:
   - `mass_1.mas20.txt`
   - `rct1.mas20.txt` 
   - `rct2_1.mas20.txt`
   - `nubase_4.mas20.txt`

2. Run the script:
```
dart mass_adjustment_convert.dart
```
3. Output will be saved to 
  - csv files: nubase_ame_rct_combined.csv and nubase_ame_rct_combined_without_Unc.csv
  - dart files: nubase.dart, ame.dart, rct.dart 

4. If you want to use dart files don't forget get classes from `entities` directory

## Output Columns
The CSV contains all data from input files:

Identification (A, Z, element, isomer state)

NUBASE data (mass excess, half-life, spin/parity)

AME data (mass excess, binding energy, atomic mass)

Reaction data (separation energies, Q-values)

## Requirements
Dart SDK (version 2.12 or higher)

## Note
The script determines the nuclide state type("StateType") based on file conventions and context.
Uses information from the 's' and 'ZZZi' columns, as well as context about whether the nuclide has many isomers.
