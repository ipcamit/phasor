function [pmat] = phasepcorr( im1,varargin)
%   phasepcorr: gives defocus compensated phase correlation between 2 images 
%   just that nothing more, requires datatem2d.mat to contain data

if length(varargin)==1
    d=varargin{1};
    scaling_factor=1;
else
    d=varargin{1};
    scaling_factor=2;
end
load('../usr_data/datatem.mat','temdata')


im1=imcrop(im1,[0 0 min(size(im1)) min(size(im1))]);
%--------------------------------------------------------------------------------
[m n]=size(im1);

Ca=temdata.ca/scaling_factor;

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

%------------------------------------------------------------------------------------
[sx,sy]=size(im1);


gamma=0.5*d*temdata.lambda*(k.*k)+0.25*temdata.cs*temdata.lambda^3*k.^4;
%b=cos(gamma);
%b(b==0)=0.00001;
%c=fftshift(b);

x_fft=fft2(im1);
max(gamma(:))
max((x_fft(:)))
min(gamma(:))
min((x_fft(:)))

pmat=-cos(x_fft+conj(x_fft)+2*gamma);
end