function [] =img_align_self()
    cd ../usr_data
    load('img_stack.mat')
    load('rel_def.mat','defocus')
    cd ../functions
    %display('this is working function')
    %msg=msgbox('Aligning images, please wait...');
    num=max(size(stack));

    if(max(stack(1).raw)>1000)
        bin_int=1;
    else
        bin_int=2;
    end
    [num_row,num_col]=size(stack(1).raw);
    blank_pad=zeros(3*num_row,3*num_col);

    
       
    base_peak=pcorr(imcrop(stack(1).raw,[0 0 512/bin_int 512/bin_int]),imcrop(stack(1).raw,[0 0 512/bin_int 512/bin_int]),0);
    [base_val, base_ind]=max(base_peak(:));    
    [base_row,base_col]=ind2sub(size(base_peak),base_ind);
    T_coordinates= [base_row,base_col];
    img_cord(1,:)=[0,0];
    for count=1:num-1
        temp_im1=imcrop(stack(count).raw,[0 0 512/bin_int 512/bin_int]);
        temp_im2=imcrop(stack(count+1).raw,[0 0 512/bin_int 512/bin_int]);
        
        img_peak=pcorr(stack(count).raw,stack(count+1).raw,defocus(count));
        [img_val, img_ind]=max(img_peak(:));
        [img_row,img_col]=ind2sub(size(img_peak),img_ind);
        
        
        img_cord(count+1,:)=[img_cord(count,1)+(img_row-T_coordinates(1)),img_cord(count,2)+(img_col-T_coordinates(2))];
        
    
    end
    
    for count=1:num
        stack3(count).raw=blank_pad+(-1)*(num+1);
        stack3(count).raw(...
            (num_row+img_cord(count,1)):(num_row+img_cord(count,1)+num_row-1),...
            (num_col+img_cord(count,2)):(num_col+img_cord(count,2)+num_col-1))=...
        stack(count).raw;
    end
    
    mask=blank_pad;

    for count=1:num
        mask=mask+stack3(count).raw;
    end

    mask(mask<0)=0;

    mask=im2bw(mask,0.5);
    [non_zero_row,non_zero_col]=find(mask);

    for count=1:num
        stack2(count).raw=stack3(count).raw(non_zero_row(1):non_zero_row(end),non_zero_col(1):non_zero_col(end));
    end

    clear stack3
    cd ../usr_data
    save('trial.mat')
    cd ../functions
    
end

