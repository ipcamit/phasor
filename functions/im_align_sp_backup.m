function [] =img_align_backup(inp,oup)
	cd data
	load(inp)
    load('r_defocus.mat','defocus')
	
    %create supersized images and save them to temporary file to avoid ram being clogged with data. These files will be loaded when needed
    for count=1:num
        stack10(count).raw=imresize(stack(count).raw,[c_size*10,c_size*10]);
    end
    save('tempdata.mat','stack10')
    %--------------------------------------------------------------------------


    cd ../functions
	
    for count=1:num-1
    	image=count
		if count==1
    		[baseimg,img_pos]=imcrop(stack(count).raw);        %get ROI
		else
    		[baseimg,img_pos]=imcrop(stack(count).raw,img_pos);
        end
    img_pos=    
	
    temp_im1=imcrop(stack(count).raw,[0 0 c_size c_size]);
	temp_im2=imcrop(stack(count+1).raw,[0 0 c_size c_size]);
	
	base_peak=pcorr(temp_im1,temp_im1,0);
	[base_val, base_ind]=max(base_peak(:));
	[base_row,base_col]=ind2sub(size(base_peak),base_ind);

    img_peak=pcorr(stack(count).raw,stack(count+1).raw,defocus);
    [img_val, img_ind]=max(img_peak(:));
    [img_row,img_col]=ind2sub(size(img_peak),img_ind);
    
%figure; imshow(img_peak,[]);
    
    [img2,img_pos]=imcrop(stack(count+1).raw,[img_pos(1)-base_col+img_col img_pos(2)-base_row+img_row img_pos(3) img_pos(4)]);
%img_pos
    [sx,sy]=size(baseimg)
    [m,n]=size(img2);
        if((sx~=m)||(sy~=n))
            img2(m,:)=[];
            img2(:,n)=[];
        end
    
    residue_peak=pcorr(baseimg,img2,defocus);
    [res_val, res_ind]=max(residue_peak(:));
    [res_row,res_col]=ind2sub(size(residue_peak),res_ind)
    [resx,resy]=size(img2)
%figure;imshow(residue_peak,[])

    [img2,img_pos]=imcrop(stack(count+1).raw,[img_pos(1)-res_col+round(resx/2) img_pos(2)-res_row+round(resx/2) img_pos(3) img_pos(4)]);
%img_pos
    [sx,sy]=size(baseimg);
    [m,n]=size(img2);
        if((sx~=m)||(sy~=n))
            img2(m,:)=[];
            img2(:,n)=[];
        end
    
    residue_peak=pcorr(baseimg,img2,defocus);
    [res_val, res_ind]=max(residue_peak(:));
    [res_row,res_col]=ind2sub(size(residue_peak),res_ind)
%figure;imshow(residue_peak,[])

    if count==1
       stack2(count).raw=baseimg;
       stack2(count+1).raw=img2;
    else
       stack2(count+1).raw=img2;
    end
    cd data
    save(oup)
    cd ../functions
end