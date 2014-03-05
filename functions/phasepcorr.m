function [pmat] = phasepcorr( im1,im2,d)
%pcorr: gives phase compensated phase correlation between 2 images 
%   just that nothing more. one more thing u have to supply defocus as
%   arguement for using it in phase compensation


cd ../data
load('datatem2d.mat','k');
cd ../functions
%k=k*10^-9;
d=d*10^-9;
gamma=pi*d*2.51*10^-12*(k.*k);
b=cos(gamma);
%figure;imshow(b,[]);
c=fftshift(b);
%a=1;
a=fspecial('gaussian',[1024 1024],500);
a=fftshift(a);
x=ham((im1));
y=ham((im2));
x_fft=(fft2(x));
%figure;imshow(x_fft.^.02,[]);
y_fft=conj((fft2(y)));
%figure;imshow(y_fft.^.02,[]);

pmat=ifftshift(ifft2(a.*((c.*x_fft.*y_fft)./abs(c.*(x_fft.*y_fft)+.000000001))));
%imshow(pmat,[]);
%max(abs(pmat(:)))
end

