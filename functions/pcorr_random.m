function [pmat] = pcorr_random( im1,im2,d)
%   pcorr_random: gives defocus compensated phase correlation between 2 images 
%   just that nothing more, requires datatem2d.mat to contain data 

cd ../usr_data
load('datatem.mat','temdata')
cd ../functions

%--------------------------------------------------------------------------------
[m n]=size(im1);
if m~=n
    if m<n
        im1=imcrop(im1,[0 0 m m]);
        im2=imcrop(im2,[0 0 m m]);

    else
        im1=imcrop(im1,[0 0 n n]);
        im2=imcrop(im2,[0 0 n n]);
        m=n;
    end
end


Ca=temdata.ca;
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
b(b==0)=0.00001;
%c=fftshift(b);

a=fspecial('gaussian',[sx sy],25);
%a=fftshift(a);
x_fft=fftshift(fft2(im1));
y_fft=fftshift(conj((fft2(im2))));
%display(size(a))
%display(size(b))
%display(size(x_fft))
%display(size(y_fft))

pmat=fftshift(ifft2(ifftshift(a.*b.*x_fft.*y_fft./(abs(b.*x_fft.*y_fft)+.000001))));
end