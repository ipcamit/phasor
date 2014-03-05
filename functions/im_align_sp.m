function [] =img_align_sp(inp,oup)
	cd ../data
	load('img_reldefocus.mat','defocus')
    load(inp,'stack2') %for relative defocus
	cd ../functions
    [sx sy]=size(stack2(1).raw);
    [dum num]=size(stack2);clear dum;

    row_shift=0; col_shift=0;                                     %intial value for shift vector, w.r.t origin as middle of img
	row=196; col=196;                                             %to get middle most area of image
    prev_row_shift=0; prev_col_shift=0;
    %baseimg=zeros(128);
    dimension=[1280 1280];

for count_=1:num-1
    	image=count_
        
        
        
        
	if count_==1
        baseimg=(stack2(count_).raw((row+row_shift):(128+row),(col):(128+col))); %crop image
        temp_im2=imresize((stack2(count_+1).raw((row+row_shift):(128+row),(col):(128+col))),dimension);
        %size(baseimg)
        %size(temp_im2)
        %next_img=stack2(count_+2).raw;
        %baseimg_raw=stack2(1).raw;

        temp_im1=imresize(baseimg,dimension);
        base_peak=phasepcorr_align(temp_im1,temp_im1,0,dimension);
	    [base_val, base_ind]=max(base_peak(:));
	    [base_row,base_col]=ind2sub(size(base_peak),base_ind);
    else
        
        temp_im2=imresize(stack2(count_+1).raw((row+row_shift):(128+row),(col):(128+col)),dimension);
        temp_im1=imresize(stack2(count_).raw((row+row_shift):(128+row),(col):(128+col)),dimension);
    end

%------------first round of alignment-----------------------------------
    img_peak=phasepcorr_align(temp_im1,temp_im2,defocus(count_),dimension);
    [img_val, img_ind]=max(img_peak(:));
    [img_row,img_col]=ind2sub(size(img_peak),img_ind);

    row_shift=-((base_row-img_row+prev_row_shift)/10)
    col_shift=-((base_col-img_col+prev_col_shift)/10)
    shift_vector=[1 0 0; 0 1 0; col_shift row_shift 1];
    T=maketform('affine',shift_vector);
    img3=imtransform(stack2(count_+1).raw,T,'XData',[1 sx],'YData',[1 sy]);
    
    %    pady=ceil(col_shift);
   %
    %    padx=ceil(row_shift);
    %    
    %    if col_shift>0
    %        img3(:,1:pady)=[];
    %        next_img(:,1:pady)=[];
    %        if(count_==1)
    %        baseimg_raw(:,1:pady)=[];
    %        end
    %    elseif col_shift<0
    %        img3(:,pady:sx)=[];
    %        next_img(:,pady:sx)=[];
    %        if(count_==1)
    %        baseimg_raw(:,1:pady)=[];
    %        end
    %    end
    %    if row_shift>0
    %        img3(1:padx,:)=[];
    %        next_img(1:padx,:)=[];
    %        if(count_==1)
    %        baseimg_raw(:,1:pady)=[];
    %        end
    %    elseif row_shift<0
    %        img3(padx:sy,:)=[];
    %        next_img(padx:sy,:)=[];
    %        if(count_==1)
    %        baseimg_raw(:,1:pady)=[];
    %            end            
    %    end

    %img3(padx,:)=0;img3(:,pady)=0;
    %img3(padx,:)=[];img3(:,pady)=[];
    %size(baseimg)
    %img1=stack2(1).raw;
    %img1(padx,:)=[];img1(:,pady)=[];
    %figure;imshow(img3,[])
    %figure;imshow(img1,[])
%   img4=img3((row+row_shift):(128+row),(col):(128+col));
%   img2=imresize(img4,[1280 1280]);
    
%------------first round of alignment-----------------------------------    

%%--------------second round of alignment--------------------------------
%
%    residue_peak=phasepcorr_align(temp_im1,img2,defocus(count_),dimension);
%    [res_val, res_ind]=max(residue_peak(:));
%    [res_row,res_col]=ind2sub(size(residue_peak),res_ind);
%    [resx,resy]=size(img2);
%    row_shift=((base_row-img_row)/10)
%    col_shift=((base_col-img_col)/10)
%    shift_vector=[1 0 0; 0 1 0; col_shift row_shift 1];
%    T=maketform('affine',shift_vector);
%    img3=imtransform(stack2(count_+1).raw,T,'XData',[1 sx],'YData',[1 sy]);
%    padx=ceil(row_shift)
%    pady=ceil(col_shift)
%    img3(padx,:)=0;img3(:,pady)=0;
%    %figure;imshow(img3,[])
%    img4=img3((row+row_shift):(128+row),(col):(128+col));
%    img2=imresize(img4,[1280 1280]);
%%--------------second round of alignment--------------------------------
%
%%--------------third round of alignment--------------------------------
%
%    residue_peak=phasepcorr_align(temp_im1,img2,defocus(count_),dimension);
%    [res_val, res_ind]=max(residue_peak(:));
%    [res_row,res_col]=ind2sub(size(residue_peak),res_ind);
%    row_shift=row-(res_row/10);
%    col_shift=col-(res_col/10);
%    shift_vector=[1 0 0; 0 1 0; col_shift row_shift 1];
%    T=maketform('affine',shift_vector);
%    img2=imtransform(stack2(count_+1).raw,T,'XData',[1 sx],'YData',[1 sy]);
%    img2=img2((row+row_shift):(128+row),(col):(128+col));
%
%%--------------third round of alignment--------------------------------

%figure; imshow(baseimg,[]);
%figure; imshow(img2,[]);
    if count_==1
       stack3(count_).raw=stack2(1).raw;
       stack3(count_+1).raw=img3;
    else
       stack3(count_+1).raw=img3;
    end
prev_row_shift=prev_row_shift+row_shift; prev_col_shift=prev_col_shift+col_shift;
  %  baseimg=img2; %previously aligned image is the new base image
end %end of for loop

    cd ../data
    save(oup)
    cd ../functions
end