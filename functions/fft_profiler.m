function [] = fft_profiler(inputmat,outputmat)
%   calculates rotationally averaged fft patterns
cd ../data
load(inputmat);
cd ../functions
[sizex,sizey]=size(stack(1).raw);
if sizex>1000
    c_size=1024;
else
    c_size=512;
for count=1:num
    
    stackfft(count).raw=abs(fftshift(fft2(ham(imcrop(stack(count).raw, [0 0 c_size c_size])))));
    stackfft(count).raw=log(1+stackfft(count).raw);
    [sx,sy]=size(stackfft(count).raw);
    [profile(count).raw,stackfft(count).smth]=rotavg(stackfft(count).raw);
    stackfft(count).mix(1:sx/2,:)=stackfft(count).raw(1:sx/2,:); stackfft(count).mix((sx/2+1):sx,:)=stackfft(count).smth((sx/2+1):sx,:);
    profile(count).raw=(profile(count).raw-min(profile(count).raw))/max(profile(count).raw);
    profile(count).smth=smooth(profile(count).raw,'sgolay');
    profile(count).smth((c_size/2)+1)=[];
    dummy=profile(count).smth;
    profile(count).smth=profile(count).smth(c_size/2:-1:1);
    %profile(count).smth=fliplr(profile(count).smth);
    profile(count).smth((c_size/2)+1:c_size)=dummy;
    stackfft(count).smth=[];
    stackfft(count).raw=[];
end

clear stack;
cd ../data;
save(outputmat);
cd ../functions
end
