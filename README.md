![Logo](figs/logo.png)

# RaMID
Version: 1.0

## Short description
R-program to read CDF files, created by mass spectrometry machine, and evaluate the mass spectra of 13C-labeled metabolites 

## Description

RaMID is a computer program designed to read the machine-generated files saved in netCDF format containing registered time course of m/z chromatograms. It evaluates the peaks of mass isotopomer distribution (MID) making them ready for further correction for natural isotope occurrence.
RaMID is written in “R”, uses library “ncdf4” (it should be installed before the first use of RaMID)  and contains several functions, located in the files “ramid.R” and "libcdf.R", designed to read cdf-files, and analyze and visualize  the spectra that they contain.

## Key features

- primary processing of 13C mass isotopomer data obtained with GCMS

## Functionality

- Preprocessing of raw data
- initiation of workflows

## Approaches

- Isotopic Labeling Analysis / 13C
    
## Instrument Data Types

- MS

## Data Analysis

RaMID reads the CDF files presented in the working directory, and then
- separates the time courses for selected m/z peaks corresponding to specific mass isotopomers;
- corrects baseline for each selected mz;
- choses the time points where the distribution of peaks is less contaminated by other compounds and thus is the most representative of the real analyzed distribution of mass isotopomers;
- evaluates this distribution, and saves it in files readable by MIDcor, a program, which performs the next step of analysis, i.e. correction of the RaMID spectra for natural isotope occurrence, which is necessary to perform a fluxomic analysis.

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

- https://github.com/seliv55/RaMID

## Installation

- As independent program. RaMID itself does not require installation. Standing in the RaMID directory enter in R environment with the command:
  
''' sudo R '''
  
- 1) Create a library of functions:

 '''   library(devtools)

       build()
       
       install()
       
       library(ramid) '''

       library(ncdf4) '''

- 2) read directly the necessary functions:
  
''' source("R/ramid.R")'''

''' source("R/libcdf.R")'''

''' library(ncdf4) '''

- the directory data/ should contain a .zip file containing the .cdf files that are to be analyzed.

## Usage Instructions

- The analysis performed when executing the  command:

 ''' ruramid(inFile="Anusha-hypoxia.csv",ouFile="ramidout.csv") '''
