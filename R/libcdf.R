gnmass<-function(mzrang){# mzrang is a set of mz values for a given pattern of intensities
#gnmass finds the length of the first fragment assuming that a gap in mz values separates franments
  len=length(mzrang); 
 for(i in 2:len){ if((mzrang[i]-mzrang[i-1])>1){return(1+mzrang[i-1]-mzrang[1]);}}
     return(len); }
     
filmat<-function(mat,np,numis,inten,ofset=0){#np is a number of mz points in the spectrum
#numis is a number of mz points in the fragment
  for(i in 1:nrow(mat)){ ip=(i-1)*np;
    for(j in 1:numis)  mat[i,j]=inten[ip+j+ofset];
               }
     return(mat);}

baseln<-function(matis,mi,ma,niso){ #finds baseline
  vlim=matis[mi,2]*1.7; bas=numeric(niso); k=0;
     for(i in 1:ma){
  if(matis[i,2]<vlim){ k=k+1;
    for(j in 1:niso) {bas[j]=bas[j]+matis[i,j];}}
  }
  for(j in 1:niso) bas[j]=bas[j]/k;
     return(bas);
}

subas<-function(matis,bas,niso){ # subtract baseline
  for(j in 1:niso)
    for(i in 1:nrow(matis)){ matis[i,j]=matis[i,j]-bas[j]; 
     if(matis[i,j]<0) matis[i,j]=0;
     }
       return(matis) }

eimpact<-function(matis,niso){
  rsum=numeric(2);
 for(i in 1:nrow(matis)){
  if(max(matis[i,])>1000){rsum[1]=rsum[1]+matis[i,1]; rsum[2]=rsum[2]+matis[i,2];} }
   ef=rsum[1]/rsum[2]; # factor proton impact
    for(i in 1:nrow(matis)){
  if(max(matis[i,])>1000){
    for(j in 1:(niso-1)) { prim=matis[i,j+1]*ef;
    matis[i,j]=matis[i,j]-prim; if(matis[i,j]<0) matis[i,j]=0;
       matis[i,j+1]=matis[i,j+1]+prim;}}}
         return(matis)}
         
rowfr<-function(matis,niso ){# normalization in each row
  mm0=matis;
       mm0[,]=0;
    for(i in 1:nrow(mm0)){
  if(max(matis[i,])>1000){ sum0=sum(matis[i,2:(niso)])
    for(j in 2:(niso))  mm0[i,j-1]=matis[i,j]/sum0; }
     mm0[i,niso]=sum(mm0[i,1:(niso-1)]) }
        return(mm0)}
        
  readcdf<-function(fi) {
 nc <- nc_open(fi, readunlim=FALSE)  #open cdf file
   mz=ncvar_get( nc, "mass_values" )
   iv=ncvar_get( nc, "intensity_values" )
   ind=ncvar_get( nc, "actual_scan_number" )
     npoint=ncvar_get( nc, "point_count" )[1]
   nc_close( nc )
        return(list(mz[1:npoint],iv))    }
        
  getfrg<-function(mrang){# finds length of fragments 
      lfr=1; npnt=length(mrang)
      tmp=gnmass(mrang);
         if(tmp<npnt) {niso=numeric(2); niso[1]=tmp; niso[2]=npnt-niso[1]; return(niso) }
    return(npnt) }
    
  savplt<-function(mm,mm0,nma,i,plname){
  png(paste("./graf/",plname,"png",sep=""))
  par(mfrow=c(2,1))
    if(i==1)plot(mm[,2],xlim=c(nma-50,nma+50))
    if(i==1)plot(mm0[,1],xlim=c(nma-50,nma+50))
   dev.off()
  }
    
  distr<-function(niso,iv,i,plname){
    ofset=0; if(i>1) ofset=ofset+niso[i-1]
    npoint=sum(niso); sclen=length(iv)/npoint
# fill matrix:
  mm=matrix(nrow=sclen,ncol=niso[i]);#columns are vectors of intensities at timepoints for a given mz
  mm=filmat(mm,npoint,niso[i],iv,ofset)
 nma=which.max(mm[,2]); nmi=which.min(mm[1:nma,2]); # max, min
# baseline:
 bas=baseln(mm,nmi,nma,niso[i])
  ilim=50; mm=mm[(nma-ilim):(nma+ilim),]; nma=ilim+1
  mm=subas(mm,bas,niso[i])    # subtract baseline
  mm1=eimpact(mm,niso[i])      # correct electron impact
  mm0=rowfr(mm,niso[i])        # normalization
#    savplt(mm1,mm0,nma,i,plname)
   pint=7;  nma1= which.max(mm0[(nma):(nma+pint),1])
 prep= nma1+nma-1
      return(list(mm0[prep,],mm1[prep,],mm[prep,])) }

