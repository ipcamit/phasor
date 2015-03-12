function [pmat] = phasepcorr_4gui( im1,im2,d,fn,window_size)
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

d=d*10^-9;
gamma=pi*d*2.51*10^-12*(k.*k);
b=cos(gamma);
%figure;imshow(b,[]);
c=fftshift(b);
%a=1;
switch fn
  case 1
  	a=fspecial('gaussian',[1024 1024],window_size);
  case 2
    a=rotavg(chebwin(1024,ceil(window_size)));
  case 3
  	padding=512-max([floor(window_size/2) 1]);
    a=padarray(fspecial('disk',max([floor(window_size/2) 1])),[padding padding]);
    a(1025,:)=[];a(:,1025)=[];
  case 4
  	a=rotavg([zeros(1,1023-ceil(window_size/2)),fliplr(cos(([0:1/ceil(window_size/2):1]).*pi/2)), cos(([0:1/ceil(window_size/2):1]).*pi/2), zeros(1,1024-ceil(window_size/2))]);

end
%a=fspecial('gaussian',[1024 1024],window_size);
a=fftshift(a);
x=ham((im1));
y=ham((im2));
x_fft=(fft2(x));
%figure;imshow(x_fft.^.02,[]);
y_fft=conj((fft2(y)));
%figure;imshow(y_fft.^.02,[]);

pmat=ifftshift(ifft2(a.*((c.*x_fft.*y_fft)./abs(c.*(x_fft.*y_fft)+.000000001))));
end
