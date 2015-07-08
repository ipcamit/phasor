function [] = fft_profiler(inputmat,outputmat)
%   calculates rotationally averaged fft patterns

     
    
    cd ../usr_data
    load(inputmat)
    cd ../functions
    [sizex,sizey]=size(stack(1).raw);
    
    if sizex>1000
        c_size=1024;
    else
        c_size=512;
    end
    num=max(size(stack));
    for count=1:num
        stackfft(count).raw=abs(fftshift(fft2(ham(imresize(imcrop(stack(count).raw, [0 0 c_size c_size]),[512 512])))));
        stackfft(count).raw=log(1+stackfft(count).raw);
        [sx,sy]=size(stackfft(count).raw);
        [stackfft(count).smth,profile(count).raw]=rotavg(stackfft(count).raw);
        stackfft(count).mix(1:sx/2,:)=stackfft(count).raw(1:sx/2,:); stackfft(count).mix((sx/2+1):sx,:)=stackfft(count).smth((sx/2+1):sx,:);
        profile(count).raw=(profile(count).raw-min(profile(count).raw))/max(profile(count).raw);
        profile(count).smth=smooth(profile(count).raw,'sgolay');
        profile(count).smth((512/2)+1)=[]; %%%replaced c_size with 512 to reduce noise
        dummy=profile(count).smth;          %%%% as in line 19 images are being resized to 512x512
        profile(count).smth=profile(count).smth(512/2:-1:1);
        %profile(count).smth=fliplr(profile(count).smth);
        profile(count).smth((512/2)+1:512)=dummy;
        %stackfft(count).smth=[];
        %stackfft(count).raw=[];
    end
    
    clear stack;
    cd ../usr_data;
    save(outputmat);
    cd ../functions
    end