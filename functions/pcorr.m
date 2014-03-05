function [pmat] = pcorr( im1,im2,d)
%   pcorr: gives defocus compensated phase correlation between 2 images 
%   just that nothing more, requires datatem2d.mat to contain data

im1=imcrop(im1,[0 0 520 520]);
im2=imcrop(im2,[0 0 520 520]);
%--------------------------------------------------------------------------------
[m n]=size(im1);
cd ../data
load('datatem2d.mat', 'Ca')
cd ../functions
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

d=d*10^-9;
gamma=pi*d*2.51*10^-12*(k.*k);
b=cos(gamma);
c=fftshift(b);

a=fspecial('gaussian',[sx sy],25);
a=fftshift(a);

x_fft=(fft2(im1));
y_fft=conj((fft2(im2)));

pmat=fftshift(ifft2(a.*((c.*x_fft.*y_fft)./abs(c.*x_fft.*y_fft))));

end