
function [ctf1d] = waf1d(df1)
%waf- wave abberation function
%   takes size of image as input ant returns wave abberatiuon function
%   matrix as output. Assumes energy= 200kv, coma, higher order spherical
%   abberation to be zero. Asks for defocus and azmuthal angle( for
%   astigmatism), spherical abberation constant and chromatic abberation
%   constant.
cd ../data
load datatem.mat;
cd ../functions
df=df1*10^-9;
clear df1;

X=pi* lambda*(df+(A1/2)*cos(2*(ang-azmuth))).*k.*k + 0.5*pi*lambda^3*csa.*k.*k.*k.*k;
i=(-1)^.5;
%figure;plot(X)



%MTF=gen_mtf(1024);
MTF=1;

Ec_spat=exp((-1*bet^2/(4*lambda^2))*((2*pi*lambda)*(df.*k+lambda^2*csa.*k.*k.*k)).*((2*pi*lambda)*(df.*k+lambda^2*csa.*k.*k.*k)));
%figure;plot(Ec_spat)
Ec_delta=exp(-1*delta^2*pi^2*lambda^2.*k.*k.*k.*k);
%figure;plot(Ec_delta)
ctf1d=MTF.*Ec_spat.*sin(X).*sin(X).*Ec_delta;



%ctfr=0*ctf;
%for(c1=1:m)
 %   for(c2=1:m)
  %      if(anglectf(c1,c2)<=.15 && anglectf(c1,c2)>=-.15)
   %         ctfr(c1,c2)=1;
    %    end
   % end
%end

end

