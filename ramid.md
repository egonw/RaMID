By *Vitaly Selivanov*
<a name="contents"></a>
## Contents

1. [Description](#1)
2. [Functions](#2)
3. [Ways of using the code](#3)
4. [Execution the program](#4)

<a name="1"></a>
## 1. Description
<p> <a href=https://github.com/seliv55/RaMID>RaMID</a> is a computer program designed to read the machine-generated files saved in netCDF format containing registered time course of m/z chromatograms. It evaluates the peaks of mass isotopomer distribution (MID) making them ready for further correction for natural isotope occurrence.
RaMID is written in 'R', uses library 'ncdf4' (it should be installed before the first use of RaMID)  and contains several functions, located in the files 'ramid.R' and 'libcdf.R', designed to read CDF files, and analyze and visualize the spectra that they contain.</p>

<a name="2"></a>
## 2. Functions

RaMID reads the CDF files presented in the working directory, and then
- separates the time courses for selected m/z peaks corresponding to specific mass isotopomers;
- corrects baseline for each selected mz;
- chooses the time points corresponding to the peak intensities where the measured values are less contaminated by other compounds and thus is the most representative of the real analyzed distribution of mass isotopomers;
- evaluates this distribution, and saves it in files readable by MIDcor, a program, which performs the next step of the analysis, i.e. correction of the RaMID spectra for natural isotope occurrence, which is necessary to carry out a fluxomic analysis.

<a name="3"></a>
## 3. Ways of accessing the program
- Way 1. Accessing RaMID code directly, downloading it from [the GitHub repository](https://github.com/seliv55/RaMID).
```sh
git clone https://github.com/seliv55/RaMID
```
 Optionally a library of R-functions "ramid" can be created
```sh
 cd <.../>RaMID
 sudo R
 library(devtools)
 build()
 install()
```
- Way 2. Using docker image of RaMID.<br>
 The image can be pulled from repo:
```sh
 docker pull container-registry.phenomenal-h2020.eu/phnmnl/ramid
```
or installed locally using a local copy of [this repo](https://github.com/phnmnl/container-ramid):
```sh
 git clone https://github.com/phnmnl/container-ramid
 cd <...>/container-ramid
 docker build -t ramid .
```
Here to create the docker image, the same github repository "https://github.com/seliv55/RaMID" is used.
<a name="4"></a>
## 4. Execution the program

- Direct execution of the downloaded code.
 Load the necessary libraries:
```sh
 R
 library(ramid) # optionally, if this library was created
 library(ncdf4)
```
Optionally, in R environment read the code directly (if the library "ramid" was not created):
```sh
 source("R/ramid.R")
 source("R/libcdf.R")
```
Then run the main program:
```sh
 ruramid(inFile, ouFile, cdfzip )
```
here the parameters are: 'infile' is the name of a file containing input information (metabolites of interest, retention time, beginning of m/z interval), 'ouFile' is the output file with the result (extracted intensities for m/z constituting the mass spectra), and 'cdfzip' is a .zip archive containing CDF files with a registration of ions after each single injections into the mass spectrometer.

- Run RaMID as a docker image created locally, go to a folder, containing the input data, and run the image:
```sh
 docker run -it -v $PWD:/data ramid -i /data/inFile -o /data/ouFile -z /data/data/cdfzip
```
To run RaMID as a docker image created in the PhenoMeNal repository, execute
```sh
docker run -it -v $PWD:/data container-registry.phenomenal-h2020.eu/phnmnl/ramid -i /data/inFile -o /data/ouFile -z /data/data/cdfzip
```


RaMID can be used also without all the previous steps of downloading the code or docher image installation, but directly as a part of <a href=https://public.phenomenal-h2020.eu/>PhenoMeNal Cloud Research Environment</a>. Go to Fluxomics tool category, and then click on ramid, and fill the expected input files, then press Run. Additionally, the tool can be used as part of a workflow with Midcor, Iso2flux and the Escher-Fluxomics tools. On a PhenoMeNal deployed CRE you should find as well a Fluxomics Stationary workflow, which includes RaMID. This way of using it is described <a href=https://github.com/phnmnl/phenomenal-h2020/wiki/fluxomics-workflow>here</a>.

The repository https://github.com/seliv55/RaMID provides three examples of using RaMID for extraction of MID for metabolites from CDF files of different complexity. 

In the first example (command: ruramid(inFile='exam1in.csv', ouFile='exam1ou.csv', cdfzip='data/exam1.zip' )) Ramid extracts the m/z peaks distribution from monopeak CDF files, i.e. files that contain time course of m/z for only one metabolite of interest.
In the second example Ramid extracts the m/z peaks distribution from CDF files that contain time course of m/z for several metabolites of interest, but separate m/z regions are measured for each metabolite. The corresponding data are contained in "data/exam2.zip","exam2in.csv" and output is in "exam2ou.csv". Respectively, to run the third example the parameters are "data/exam3.zip","exam3in.csv" and "exam3ou.csv". It contains recordings for all metabolites of interest in each CDF file. The m/z intervals for many of them are not separated.

