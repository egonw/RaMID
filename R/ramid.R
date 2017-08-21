ruramid<-function(inFile="ramidin.csv",ouFile="ramidout.csv",cdfzip="data/wd.zip"){
 temp <- paste(tempdir(),"/",sep="")  #"data/ttt/"  #
 lf<-unzip(cdfzip,exdir=temp)
# lcdf<-dir(path="./data/temp",pattern=".CDF") # list of names of ".CDF" files
 print(lf)

  fn<-inFile  #file.path(paste("./",inFile,sep=""));
  rada<-read.table(fn, sep=",");   # read experimental data
   tit<-rada[1,] # copy first line of titles
  for(i in 1:ncol(rada)) {
        if(grepl("m/z",rada[1,i])) imz=i # get a column of mz
        if(grepl("retent",rada[1,i])) iret=i # get a column of retentions
        if(grepl("signal i",rada[1,i])) iint=i # get a column of intensity
  }
         rada[,iret]<-as.numeric(as.character(rada[,iret]))
         rada[,imz]<-as.numeric(as.character(rada[,imz]))
         rada[,iint]<-as.numeric(as.character(rada[,iint])) # column of signal intensity
  lfi<-as.character(rada[2,1]); j<-1  # get lfi: list of CDF files
  lret<-rada[2,iret];
  lmz<-rada[2,imz];
  for(i in 2:nrow(rada)){ if(grepl(as.character(rada[i,1]),lfi[j])) next
   j<-j+1; lfi<-c(lfi,as.character(rada[i,1]))
        lret<-c(lret,rada[i,iret])
        lmz<-c(lmz,rada[i,imz])
           }
           ln<-1;
     ldf<-list(); # data frame to write Ramid output in PhenoMeNal format
     ifi<-0;
     finames=character()
   for(k in 1:(length(lfi))){
  a<-readcdf(paste(temp,lfi[k],sep="")) # read the following time courses from CDFs
#    mz, intensities, number of mz-point at each rett, sum of iv at each rett
     mz<-a[[1]]; iv<-a[[2]]; npoint<-a[[3]]; rett<-a[[4]]; totiv<-a[[5]];
#    summary: 
 a<-info(mz,iv,npoint); mzpt<-a[[1]]; tpos<-a[[2]]; mzind<-a[[3]]; mzrang<-a[[4]]; 
     
     icyc<-0; lmet<-numeric(); imet<--1; mzr<-list(); dispik<-list(); disar<-list()
     
     rts<-lret[k]*60.;
     
        for(ranum in 1:length(mzrang))
   if((lmz[k] %in% mzrang[[ranum]]) & (rts > rett[tpos[ranum]]) & (rts < rett[tpos[ranum+1]-5])) {
#   find whether mid for a given metabolite is presented in the file fi 
  nma<-findmax(totiv=totiv,tin=tpos[ranum],tfi=tpos[ranum+1]);
  tlim=50
  mzi<-mzind[ranum]+mzpt[ranum]*(nma-tlim)
   tl<-tpos[ranum]+nma-tlim;  tu<-tpos[ranum]+nma+tlim;
    tiv<-totiv[tl:tu]; rett1<-rett[tl:tu] #separate area peak ± tlim for total intensity and retention
    nmi<-which.min(tiv);
   
   lenpat<-gnmass(mzrang[[ranum]])
   ofs<-0
   for(ii in lenpat){ mzr<-mzrang[[ranum]][(ofs+1):ii]
    if(rada[ln+1,imz] %in% mzr){
#  a<-setmat( ii,mzrang=mzrang[[ranum]],mzind=mzi,iv=iv, mzpt=mzpt[ranum],tini=tl,tfin=tu,ofs=ofs); ofs<-ii
   intens<-matrix(ncol=(ii-ofs),nrow=(tu-tl))
     intens<-filmat(intens,iv,mzpt=mzpt[ranum],mzi-1+ofs)
    
  bas=baseln(intens,nmi,tlim)   # baseline:
  intens<-subas(intens,bas)    # subtract baseline
  
    a<- peakdist(intens,rett1,tlim)
    dispik<-c(0.,a[[1]]); disar<-c(0.,a[[2]]); j<-0
 for(i in 1:length(mzr)) if(rada[ln+i,1]==lfi[k]) {j=j+1; rada[(ln+j),iint]<-round(disar[i],3)}
    ln<-ln+j
 break
 }
   ofs<-ii
    }
      } }


    write.table(tit, file=ouFile, sep=",", row.names = F, col.names = F)
    write.table(rada[-1,], file=ouFile, sep=",", row.names = F, col.names = F, append=T)
    unlink(temp, recursive = T, force = T)
}

info<-function(mz,iv,npoint){
#  mz,iv,npoint: mz, intensities and number mz points in every scan
      j<-1
  mzpt<-numeric() # number of m/z points in each pattern
  tpos<-numeric() # initial time position for each m/z pattern 
   mzi<-numeric() # initial value for each m/z pattern presented in the CDF file
    mzind<-numeric() # index in mz array corresponding to mzi
     mzrang<-list() # list of mz patterns presented in the .CDF
  mzpt[j]<-npoint[1]; tpos[j]<-1; mzi[j]<-mz[1]; imz<-1; mzind[j]<-imz
  mzrang[[1]]<-mz[1:mzpt[1]];
    for(i in 2:length(npoint)) { imz<-imz+npoint[i-1];
     if(mzi[j]!=mz[imz]){  j<-j+1; tpos[j]<-i;  mzpt[j]<-npoint[i]; mzi[j]<-mz[imz];
      mzind[j]<-imz; mzrang[[j]]<-mz[(mzind[j]):(mzind[j]-1+mzpt[j])] }
    }
  tpos[length(tpos)+1]<- length(npoint) # add the last timepoint
  return(list(mzpt,tpos,mzind,mzrang))
  }
  
findmax<-function(totiv,tin,tfi){
  totiv1<-totiv[tin:(tfi-1)]
  nma<-which.max(totiv1);
  return(nma)}
  

#       for(fi in lcdf){itrac<-0 #labname<-" "; labpos<-" "; abund<-" "; ti<-0 #CDF files one by one
#     a <-findpats(fi,finames,ldf);
#     finames<-a[[1]]; ldf<-a[[2]]   # output 1: reltive intensities; 2: relative peak areas;
# if(length(a)>1)  { ifi<-ifi+1; mzr<-a[[3]]; imet<-a[[4]]; dist<-a[[5]];
#        for(j in 1:length(imet)) {data=metabs[[imet[j]]]; miso=character(); miso=paste("13C",mzr[[j]]-data$mz0,sep="") #isotopomer names
#  dfrow<-data.frame(fi,cel,labname,labpos,abund,tinc,data$metname,data$chebi,data$Cfrg,data$Cder,data$rt, mzr[[j]], c(0,dist[[j]]), miso," ")
#  df0<-rbind(df0,dfrow) # filling df with dfrow
#     }
#     }
#       }
  peakdist<-function(intens,rett1,tlim=50,peakf=5,ipmi=5,stabin=2){
# fi: file name
# met: parameters of metabolite (mz for m0, retention time)
# ilim: number of points limiting half peak
# peakf: factor to define lower limit of peak interval used for fitting
# ipmi: minimal number of points for half peak taken for fitting
# stabin: numer of points after peak to defing mi ratio
   inmax<-which.max(intens[tlim,]); porog<-intens[tlim,inmax]/peakf
   ip<-1; while(intens[tlim-ip,inmax]>porog & intens[tlim+ip,inmax]>porog) ip<-ip+1
   if(ip<ipmi) ip<-ipmi
  mm1=eimpact(intens)      # correct electron impact
  mm0=rowfr(mm1)        # normalization
   a<-fitdist(rett1,mm1,tlim,pint=ip)
   reti<-a[[1]]; ye<-a[[2]]; yf<-a[[3]]; area<-a[[4]]
    relar<-area/sum(area)
#    savplt(intens,mm0,nma,fi)
#    plal(fi,reti,ye,yf)
 return(list(mm0[tlim,],relar))#MID calculated as ratio either of intensities or areas of fitted peaks
  }

#  
#     
# nma1= which.max(mm0[(nma):(nma+stabin),1])
# prep= nma1+nma-1; # print(prep)
# list(mm0[prep,],relar,mzr)
# }
#     
#   
#  return(list(mativ,rett1,totiv1,mzr))
## mativ: matrix of intensities corresponding to various mz in rows and to retention times in columns, corresponding to metp
## rett1: vector of retention times, corresponding to metp
## totiv1: sum of intensities in each row
#}

fitG <-function(x,y,mu,sig,scale){
# x,y: x and y values for fitting
# mu,sig,scale: initial values for patameters to fit  
  f = function(p){
    d = p[3]*dnorm(x,mean=p[1],sd=p[2])
    sum((d-y)^2)
  }
  optim(c(mu,sig,scale),f,method="CG")
 # nlm(f, c(mu,sig,scale))
# output: optimized parameters
   }
  
fitdist<-function(x,ymat,nma,pint=5,cini=2,fsig=1.5,fsc=2.){ # fits distributions
# x: vector of x-values
# ymat: matrix of experimental values where columns are time courses for sequential mz
# nma: point of maximal value
# pint: half interval taken for fitting
# cini: initial column number
  cfin<-ncol(ymat)#cini+nmi-1;
  nmi<-cfin-cini+1 #ncol(ymat)-1;
   fscale<-numeric()
   xe<-x[(nma-pint):(nma+pint)];    facin<-max(ymat[nma,]);
   yemat<-ymat[(nma-pint):(nma+pint),cini:cfin]/facin
      yfmat<-yemat
          mu<-xe[pint+1]
          sig<-(xe[2*pint]-xe[2])/fsig
   for(i in 1:nmi){
          scale<-yemat[pint,i]*sig/fsc
   fp<-fitG(xe,yemat[,i],mu,sig,scale)
    fscale[i]<-fp$par[3]*facin
    yfmat[,i]<-fp$par[3]*dnorm(xe,mean=fp$par[1],sd=fp$par[2])
#    fscale[i]<-fp$estimate[3]*facin
#    yfmat[,i]<-fp$estimate[3]*dnorm(xe,mean=fp$estimate[1],sd=fp$estimate[2])
#   mu<-fp$par[1];  sig<-fp$par[2];# scale<-fp$par[3]
   }
   list(xe,yemat,yfmat,fscale)
#   xe: x-values used for fit
#   yemat: matrix of experimental intensities
#   yfmat: matrix of fitted intensities
#   fscale: areas of peaks
}
     
plal<-function(fi,x,me,mf){# plots intensities from matrix mm; nma - position of peaks; abs - 0 or 1 depending on mm
# fi: file to plot in
# x: vector of x-values
# me: matrix of experimental values where columns are time courses for sequential mz
# mf: matrix of fittings corresponding to me
    fi<-strsplit(fi,"CDF")[[1]][1]
  png(paste("../graf/",fi,"png",sep=""))
  x_range<-range(x[1],x[length(x)])
  g_range <- range(0,1)
  nkriv<-ncol(me); sleg<-"m0"
  plot(x,me[,1], xlim=x_range, ylim=g_range,col=1)
  lines(x,mf[,1],col=1, lty=1)
   for(i in 2:nkriv){ sleg<-c(sleg,paste("m",i-1))
    points(x,me[,i],pch=i,col=i)
    lines(x,mf[,i],col=i, lty=i)
  }
  legend("topright",sleg,col = 1:length(sleg),lty=1:length(sleg))
   dev.off()
   }
     
