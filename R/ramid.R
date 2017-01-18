ruramid<-function(inFile="ramidin.csv",ouFile="ramidout.csv"){
 temp <- "data/ttt/"
 lf<-unzip("data/wd.zip",exdir=temp)
# lcdf<-dir(path="./data/temp",pattern=".CDF") # list of names of ".CDF" files
 print(lf)

  fn<-inFile  #file.path(paste("./",inFile,sep=""));
  rada<-read.table(fn, sep=",");   # read experimental data
   tit<-rada[1,] # copy first line of titles
  for(i in 1:ncol(rada)) {
        if(grepl("m/z",rada[1,i])) {imz=i; } # get a column of mz
  }
  lfi<-as.character(rada[2,1]); j<-1  # get lfi: list of CDF files
  for(i in 2:nrow(rada)){ if(grepl(as.character(rada[i,1]),lfi[j])) next
   j<-j+1; lfi<-c(lfi,as.character(rada[i,1]))
           }
           ln<-1;
         rada[,imz]<-as.numeric(as.character(rada[,imz]))
         rada[,imz+1]<-as.numeric(as.character(rada[,imz+1])) # column of signal intensity
   for(k in 1:length(lfi)){
  a<-readcdf(paste(temp,lfi[k],sep="")) # read the following time courses from CDFs
           mz=a[[1]]; iv=a[[2]]; #mz: mz rang; iv: signal intensities
            niso=getfrg(mz); nfr=length(niso) # number of different mz corresponding to each fragment
         j<-1; i<-1
      if(rada[ln+i,imz]==mz[1]) ifr<-1 else ifr<-2 # assign fragment
        mdist<-distr(niso,iv,ifr,lfi[k]); # peaks distribution: 1-normalized, 2-corrected ei, 3-corrected baseline
  while(rada[ln+i,1]==lfi[k]) {if(rada[(ln+i),imz]==mz[j]){ # substitute signal intensities
       rada[(ln+i),(imz+1)]<-round(mdist[[3]][j]); j<-j+1}
    i<-i+1; if((ln+i)>nrow(rada)) break }
    ln<-ln+i-1
   }
    write.table(tit, file=ouFile, sep=",", row.names = F, col.names = F)
    write.table(rada[-1,], file=ouFile, sep=",", row.names = F, col.names = F, append=T)
    unlink(temp, recursive = T, force = T)
}


