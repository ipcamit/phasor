function [ output_args ] = stack_image()
%take a series of images and stacks them in a file named img_stack.mat in data directory
%Stack_image function will be used to load the image series in MATLAB
%if get time will try to make it name and os independent
path=uigetdir;
ser=input('intput name of the series\n','s');
num=input('enter total number of images\n'); 
%matname=input('enter output file name\n','s');

for(i=1:num)
    a=num2str(i);
    if ispc
       file=strcat(path,'\',ser,a,'.tif');   %change file name format here
       img=im2double(imread(file));
       stack(i).raw=img;
       else
         	file=strcat(path,'/',ser,a,'.tif');    %change filename format here
         	img=im2double(imread(file));
         	stack(i).raw=img;  
         end

end



clear a

clear img

cd ../data
save('img_stack.mat')
cd ../functions
end