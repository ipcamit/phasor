function [  ] = relative_def(inp,oup,df_range)
% Finds relative defocus between successive images using Phase correlation
% Depends on function pcorr(), max defocus range is 30nm, if differnce between mages is more then increase in line 12
cd ../usr_data
load(inp,'stack')
load('datatem.mat','temdata')
cd ../functions
m=1024;n=1024;
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

num=max(size(stack));
max_val(1:num)=0;
defocus(1:num)=0;
%def=[1:.5:df_range];
%def3d=zeros(1024,1024,max(size(def)));
%def3d(:,:,max(size(def)))=def;
h=waitbar(0,['Finding approximate defocus for better alignment, please wait... ']);
tic
for imcount=1:num-1
    im1=imcrop(stack(imcount).raw,[0 0 1024 1024]);
    im2=imcrop(stack(imcount+1).raw,[0 0 1024 1024]);
    for def=1:1:df_range
        pmat=abs(ifftshift(ifft2(fftshift(fspecial('gaussian',[1024 1024],500)).*...
        ((fftshift(cos(pi*def*10^-9*2.51*10^-12*(k.*k))).*fft2(ham((im1))).*...
            conj((fft2(ham((im2))))))./abs(fftshift(cos(pi*def*10^-9*2.51*10^-12.*...
                (k.*k))).*(fft2(ham((im1))).*conj((fft2(ham((im2))))))+.000000001)))));;
        maxi=max(pmat(:));
        if(max_val(imcount)<maxi)
            max_val(imcount)=maxi;
            defocus(imcount)=def;
        end   
    h=waitbar(((imcount-1)/(num-1))+def/((df_range)*(num-1)),h,['Finished ', num2str(imcount), '  out of  ', num2str(num-1), '  images']);
    end

end
%time_taken=toc;
%display(time_taken)
waitbar(1,h,'Completed!!!!')
%uiwait(h);
close(h)
clear stack
cd ../usr_data
save(oup)
cd ../functions
end