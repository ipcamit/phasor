function [] =img_align(inp,oup)
	cd data
	load(inp)
    load('r_defocus.mat','defocus') %for relative defocus
	


    cd ../functions
    row_shift=0; col_shift=0;                                     %intial value for shift vector, w.r.t origin as middle of img
	row=260; col=432;                                             %to get middle most area of image
    baseimg_prev=zero(512);


for count=1:num-1
    	image=count
	if count==1
        baseimg=stack(count).raw((row+row_shift):(512+row);(col):(512+col)); %crop image
        temp_im2=imresize(stack(count+1).raw((row+row_shift):(512+row);(col):(512+col)),[5120 5120]);
        temp_im1=imresize(baseimg,[5120 5120]);
        base_peak=phasepcorr(temp_im1,temp_im1,0);
	    [base_val, base_ind]=max(base_peak(:));
	    [base_row,base_col]=ind2sub(size(base_peak),base_ind);
    end
    temp_im2=imresize(stack(count+1).raw((row+row_shift):(512+row);(col):(512+col)),[5120 5120]);
    temp_im1=imresize(baseimg,[5120 5120]);

%------------first round of alignment-----------------------------------
    img_peak=phasepcorr(temp_im1,temp_im2,defocus(count));
    [img_val, img_ind]=max(img_peak(:));
    [img_row,img_col]=ind2sub(size(img_peak),img_ind);

    row_shift=row-(img_row/10);
    col_shift=col-(img_col/10);
    shift_vector=[1 0 0; 0 1 0; col_shift row_shift 1];
    T=maketform('affine',shift_vector);
    img2=imtransform(stack(count+1).raw,T,'XData',[1 1372],'YData',[1 1032]);
    img2=imresize(img2((row+row_shift):(512+row);(col):(512+col)),[5120 5120]);    
%------------first round of alignment-----------------------------------    

%--------------second round of alignment--------------------------------

    residue_peak=phasepcorr(baseimg,img2,defocus(count));
    [res_val, res_ind]=max(residue_peak(:));
    [res_row,res_col]=ind2sub(size(residue_peak),res_ind);
    [resx,resy]=size(img2)


    row_shift=row-(res_row/10);
    col_shift=col-(res_col/10);
    shift_vector=[1 0 0; 0 1 0; col_shift row_shift 1];
    T=maketform('affine',shift_vector);
    img2=imtransform(stack(count+1).raw,T,'XData',[1 1372],'YData',[1 1032]);
    img2=imresize(img2((row+row_shift):(512+row);(col):(512+col)),[5120 5120]);

%--------------second round of alignment--------------------------------

%--------------third round of alignment--------------------------------

    residue_peak=phasepcorr(baseimg,img2,defocus(count));
    [res_val, res_ind]=max(residue_peak(:));
    [res_row,res_col]=ind2sub(size(residue_peak),res_ind)
    row_shift=row-(res_row/10);
    col_shift=col-(res_col/10);
    shift_vector=[1 0 0; 0 1 0; col_shift row_shift 1];
    T=maketform('affine',shift_vector);
    img2=imtransform(stack(count+1).raw,T,'XData',[1 1372],'YData',[1 1032]);
    img2=img2((row+row_shift):(512+row);(col):(512+col));

%--------------third round of alignment--------------------------------


    if count==1
       stack2(count).raw=baseimg;
       stack2(count+1).raw=img2;
    else
       stack2(count+1).raw=img2;
    end
    baseimg=img2; %previously aligned image is the new base image
end %end of for loop

    cd data
    save(oup)
    cd ../functions
end