function [pmat] = phasepcorr( im1,im2,d)
%pcorr: gives phase compensated phase correlation between 2 images 
%   just that nothing more. one more thing u have to supply defocus as
%   arguement for using it in phase compensation


[m n]=size(im1);
cd ../usr_data
load('datatem.mat','temdata')
cd ../functions
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

%------------------------------------------------------------------------------------
[sx,sy]=size(im1);

%d=d*10^-9;
%gamma=pi*d*2.51*10^-12*(k.*k);
%b=cos(gamma);
%%figure;imshow(b,[]);
%c=fftshift(b);
%a=1;
%a=fftshift(fspecial('gaussian',[1024 1024],500));

%x=ham((im1));
%y=ham((im2));
%x_fft=fft2(ham((im1)));
%figure;imshow(x_fft.^.02,[]);
%y_fft=conj((fft2(ham((im2)))));
%figure;imshow(y_fft.^.02,[]);

pmat=ifftshift(ifft2(fftshift(fspecial('gaussian',[1024 1024],500)).*((fftshift(cos(pi*d*10^-9*2.51*10^-12*(k.*k))).*fft2(ham((im1))).*conj((fft2(ham((im2))))))./abs(fftshift(cos(pi*d*10^-9*2.51*10^-12*(k.*k))).*(fft2(ham((im1))).*conj((fft2(ham((im2))))))+.000000001))));
end
