
function [ctf] = waf_recon(df,image_size)
%waf- wave abberation function
%   takes size of image as input ant returns wave abberatiuon function
%   matrix as output. Assumes energy= 200kv, coma, higher order spherical
%   abberation to be zero. Asks for defocus and azmuthal angle( for
%   astigmatism), spherical abberation constant and chromatic abberation
%   constant.

cd ../usr_data
load('datatem.mat','temdata');
cd ../functions
%df=df*10^-9;
%clear df1;
%-----------------------------------------------------------
    m=image_size;
    Ca=temdata.ca;
    if(mod(m,2)==0)
     zro = m/2+0.5;
     ind = m/2;
    else 
      zro = ceil(m/2); 
      ind=m/2+.05;
    end
  [ix,jx] = meshgrid(1:m); 
  r = ((ix-zro).^2 + (jx-zro).^2).^(0.5); 
  k = r./(m*Ca);
  
%-------------------------------------------------------
df=df*10^-9;

A1=0;ang=0;azmuth=0;
X=pi* temdata.lambda*(df+(A1/2)*cos(2*(ang-azmuth))).*k.*k + 0.5*pi*temdata.lambda^3*temdata.cs.*k.*k.*k.*k;
i=(-1)^.5;




MTF=gen_mtf(image_size);


Ec_spat=exp((-1*temdata.bet^2/(4*temdata.lambda^2))*((2*pi*temdata.lambda)*(df.*k+temdata.lambda^2*temdata.cs.*k.*k.*k)).*((2*pi*temdata.lambda)*(df.*k+temdata.lambda^2*temdata.cs.*k.*k.*k)));

Ec_delta=exp(-1*temdata.delt^2*pi^2*temdata.lambda^2.*k.*k.*k.*k);

ctf=MTF.*Ec_spat.*exp(i.*X).*Ec_delta;



end

