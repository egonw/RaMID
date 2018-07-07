![Logo](figs/logo.png)

# RaMID
Version: 1.0

## Short description
R-program to read CDF files, created by mass spectrometry machine, and evaluate the mass spectra of 13C-labeled metabolites 

## Description

RaMID is a computer program designed to read the machine-generated files saved in netCDF format containing registered time course of m/z chromatograms. It evaluates the peaks of mass isotopomer distribution (MID) making them ready for further correction for natural isotope occurrence.
RaMID is written in “R”, uses library “ncdf4” (it should be installed before the first use of RaMID),  and contains several functions, located in the files “ramid.R” and "libcdf.R," designed to read CDF files, analyze and visualize the spectra that they contain.

## Key features

- primary processing of 13C mass isotopomer data obtained with GCMS

## Functionality

- Preprocessing of raw data
- initiation of workflows of the data analysis

## Approaches

- Isotopic Labeling Analysis / 13C
    
## Instrument Data Types

- MS

## Data Analysis

RaMID reads the CDF files presented in the working directory, and then
- separates the time courses for selected m/z peaks corresponding to specific mass isotopomers;
- corrects baseline for each selected mz;
- chooses the time points corresponding to the peak intensities where the measured values are less contaminated by other compounds and thus is the most representative of the real analyzed distribution of mass isotopomers;
- evaluates this distribution, and saves it in files readable by MIDcor, a program, which performs the next step of the analysis, i.e. correction of the RaMID spectra for natural isotope occurrence, which is necessary to carry out a fluxomic analysis.

## Screenshots

- screenshot of input data (format Metabolights), output is the same format with one more column added: corrected mass spectrum

![screenshot]()

## Tool Authors

- Vitaly Selivanov (Universitat de Barcelona)

## Container Contributors

- [Pablo Moreno](EBI)

## Website

- N/A

## Git Repository

- https://github.com/seliv55/wf/tree/master/RaMID

## Installation

- As independent program, RaMID itself does not require installation. There are two ways of using it: either creating a library "ramid", or reading source files containing the implemented functions. Standing in the RaMID directory: 
  
  
- 1) To create a library "ramid":

```
sudo R

library(devtools)

build()

install()

library(ramid)

library(ncdf4)
```

- 2) to read directly the necessary functions:
  
```
R

source("R/ramid.R")

source("R/libcdf.R")

library(ncdf4)
```

- the directory data/ should contain a .zip file containing the .cdf files that are to be analyzed.

## Usage Instructions

- The analysis performed when executing the  command:

```
ruramid(inFile, ouFile, cdfzip )
```

here the parameters are the names of a file containing input information (metabolites of interest, retention time, beginning of m/z interval), output file with the result (extracted intensities for m/z constituting the mass spectra), and a .zip archive containing CDF files with a registration of ions after each single injections into the mass spectrometer.
    
## Three examples are provided

- in the first example Ramid extracts the m/z peaks distribution from monopeak CDF files, i.e. files that contain time course of m/z for only one metabolite of interest. Archive containing such data is "data/exam1.zip" and correspinding additional input information and output results are in "exam1in.csv" and "exam1ou.csv". The following command starts this analysis:

```
ruramid(inFile="exam1in.csv",ouFile="exam1ou.csv",cdfzip="data/exam1.zip")
```
 
- in the second example Ramid extracts the m/z peaks distribution from CDF files that contain time course of m/z for several metabolites of interest, but separate m/z regions are measured for each metabolite. The corresponding data are contained in "data/exam2.zip","exam2in.csv" and output is in "exam2ou.csv". Respectively, to run the third example the parameters are "data/exam3.zip","exam3in.csv" and "exam3ou.csv". It contains recordings for all metabolites of interest in each CDF file. The m/z intervals for them could be not separated.

