![Logo](figs/logo.png)

# RaMID
Version: 1.0

## Short description
R-program to read CDF files, created by mass spectrometry machine, and evaluate the mass spectra of 13C-labeled metabolites 

## Description

RaMID is a computer program designed to read the machine-generated files saved in netCDF format containing registered time course of m/z chromatograms. It evaluates the peaks of mass isotopomer distribution (MID) making them ready for further correction for natural isotope occurrence.
RaMID is written in “R”, uses library “ncdf4” (it should be installed before the first use of RaMID)  and contains several functions, located in the files “ramid.R” and "libcdf.R," designed to read CDF files, and analyze and visualize the spectra that they contain.

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
- chooses the time points where the distribution of peaks is less contaminated by other compounds and thus is the most representative of the real analyzed distribution of mass isotopomers;
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

- As independent program. RaMID itself does not require installation. There are two ways of using it: either creating a library "ramid", or reading source files containing the implemented functions. Standing in the RaMID directory: enter in R environment with the command:
  
  
- 1) To create a library "ramid":

 ''' sudo R '''

 '''   library(devtools) '''

 '''   build() '''
       
 '''   install() '''
       
 '''   library(ramid) '''

 '''   library(ncdf4) '''

- 2) to read directly the necessary functions:
  
 ''' R '''

''' source("R/ramid.R") '''

''' source("R/libcdf.R") '''

''' library(ncdf4) '''

- the directory data/ should contain a .zip file containing the .cdf files that are to be analyzed.

## Usage Instructions

- The analysis performed when executing the  command:

 ''' ruramid(inFile, ouFile, cdfzip ) '''
 


    here the parameters are the names of a file containing input information, output file with the result (extracted relative intensities for all m/z constituting the peak), and a .zip archive containing CDF files with a registration of the injections into the mass spectrometer performed in the course of the given analyzed experiment.
    
## Two examples are provided

- extracting the m/z peaks distribution from monopeak CDF files, i.e. files that contain time course of only one peak that includes all isotopomers of a metabolite of interest. Archive containing such data is "data/wd.zip" and correspinding input and output are in "ramidin.csv" and "ramidout.csv". The following command starts this analysis:

 ''' ruramid(inFile="ramidin.csv",ouFile="ramidout.csv",cdfzip="data/wd.zip") '''
 
- extracting the m/z peaks distribution from multipeak CDF files, i.e. files that contain time course of several peaks that include all isotopomers of metabolites of interest. Archive containing such data is "data/roldan.zip" and correspinding input and output are in "../cdf2mid/cdf2midout.csv" (It is supposed that the user has downloaded the repository "cdf2mid". If not, the necessary file should be copied and this parameter shows the path to it.) and "ramidout.csv". The following command starts this analysis:

 ''' ruramid(inFile="../cdf2mid/cdf2midout.csv",ouFile="ramidout.csv",cdfzip="data/roldan.zip") '''
 
 The output file contains the distribution of mass isotopomers in the analyzed peak, extracted by RaMID from the provided CDF files, using the information given in the inFile.



