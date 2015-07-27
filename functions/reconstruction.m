function [] = reconstruction()
%reconstruction() function restores the wafefunction

%Alright lets first sort the images in order of defocus as sometimes the order changes
%load defocus matrix


load('../usr_data/defocus.mat','defocus')
%load('img_aligned_stack.mat','stack2')
load('../usr_data/img_aligned_stack.mat','stack_final')

size_of_defocus=numel(defocus);

%defocus_sort_array=sortrows([linspace(1,size_of_defocus,size_of_defocus)',defocus'],-2)';

[m n]=size(stack_final(1).raw);

if m~=n
    if m<n
      for count=1:size_of_defocus
        img_stack(count).raw=imcrop(stack_final(count).raw,[0 0 m m]);
      end        
    else
        for count=1:size_of_defocus
          img_stack(count).raw=imcrop(stack_final(count).raw,[0 0 n n]);
        end 
        m=n;
    end
end
for(count=1:size_of_defocus)
    
    img_stack(count).img=wiener2(ham(img_stack(count).raw),[2 3]);
    wavefunc(count).ini=img_stack(count).img.^.5;
end

image_size=max(size(img_stack(1).img));
%lf = fft2([0 1 0; 1 -4 1; 0 1 0],image_size,image_size);


%propogation to zero defocus
phase=0;
%------------------------------------------------------------------------------------

m
v=.3;

%******W&V*******
W=zeros(m);
V=zeros(m);
[len,brd]=size(defocus);
for(count=1:size_of_defocus)
  
   TF=waf_recon(defocus(count),image_size);
    W=W+TF.*conj(TF);
    V=V+TF.*TF;
end

waveavg=zeros(m);
brd
for(count=1:size_of_defocus)
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
current_time=clock;
savename=strcat('../usr_data/result','_',num2str(current_time(3)),'_',num2str(current_time(2)),'_',num2str(current_time(1)),'_',num2str(current_time(4)),'_',num2str(current_time(5)),'_',num2str(round(current_time(6))),'_','.mat');
save(savename);
end

