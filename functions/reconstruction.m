function [] = reconstruction()
%reconstruction() function restores the wafefunction

%Alright lets first sort the images in order of defocus as sometimes the order changes
%load defocus matrix
cd ../usr_data
load('defocus.mat','defocus')
load('img_aligned_stack.mat','stack2')
cd ../functions

size_of_defocus=numel(defocus);
defocus_sort_array=sortrows([linspace(1,size_of_defocus,size_of_defocus)',defocus'],-2)';

for(count=1:size_of_defocus)
    %count
    stack2(count).img=wiener2(ham(stack2(count).raw),[2 3]);
   
    %size(stack2(count).img)
    %waves(count).phase=stack2(count).img.*0;
    wavefunc(count).ini=stack2(count).img.^.5;
    %size(wavefunc(count).ini)
end
image_size=max(size(stack2(1).img));
%lf = fft2([0 1 0; 1 -4 1; 0 1 0],image_size,image_size);
[m n]=size(stack2(1).img);
%savedat2d(m);
Loop1=1;

%propogation to zero defocus
phase=0;
%------------------------------------------------------------------------------------

m
v=.5;

%******W&V*******
W=zeros(m);
V=zeros(m);
[len,brd]=size(defocus);
for(count=10:size_of_defocus-8)
  
   TF=waf_recon(defocus(count),image_size);
    %TF=Ec.*Ed.*TF;
    W=W+TF.*conj(TF);
    V=V+TF.*TF;
   % end
end

waveavg=zeros(m);
brd
for(count=10:size_of_defocus-8)
 count
  wavefftd=zeros(m);
    wavefftd=fftshift(fft2((wavefunc(count).ini)));
  
    TF=waf_recon(defocus(count),image_size);
    %TF=Ec.*Ed.*TF;
 size(W)
 size(TF)
    
     %******MEYER FILTER******* 
     wavefft(count).def0=(((W+v).*conj(TF)-conj(V).*TF)./((W+v).*(W+v)-V.*conj(V))).*wavefftd;
       
   
    waveavg=waveavg+wavefft(count).def0;
    %end
end

cd ../usr_data
current_time=clock;
savename=strcat('result','_',num2str(current_time(3)),'_',num2str(current_time(2)),'_',num2str(current_time(1)),'_',num2str(current_time(4)),'_',num2str(current_time(5)),'_',num2str(round(current_time(6))),'_','.mat');
save(savename);
cd ../functions
end






%for(iteration=5:size_of_defocus-14)
%  iteration
%  waveavg=0;
%    for(count=1:size_of_defocus)
%      % count
%        wavefftd=0;
%        wavefftd=fftshift(fft2(wavefunc(count).ini.*exp(i*phase)));
%        %wafefftd=wavefftd/max(wavefftd(:));
%       % wavefft(count).amp=abs(wavefftd);
%       % wavefft(count).phase=angle(wavefftd);
%        TF=waf_recon(defocus(count),image_size);
%       % size(wavefunc(count).ini)
%        %size(wavefftd)
%       size(TF)
%       size(lf)
%       
%        wavefft(count).def0=wavefftd.*(TF./(TF.*TF +lf.*lf*.0001));
%        waveavg=waveavg+wavefft(count).def0;
%        
%    end
%  loop2=1;
%  waveavg=waveavg./size_of_defocus;
%  SSE(5:size_of_defocus-14)=0;
%    for(count=15:size_of_defocus-4)
%       % count
%       TF=waf_recon(defocus(count),image_size);
%        wavecalc(count).def=waveavg.*TF;
%        wavediff(count).diff=ifft2(wavecalc(count).def)-wavefunc(count).ini;
%        wavediff(count).diff=(wavediff(count).diff.*wavediff(count).diff);
%        SSE(count)=SSE(count)+sum(wavediff(count).diff(:))/sum(stack2(count).img( :) );
%  end
%  SSEAVG=sum(SSE)/size_of_defocus;
%  loop3=1;
%  phase=atan2(angle(ifft2(waveavg)),abs(ifft2(waveavg)));
%  end

