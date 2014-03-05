
function [new_MTF] =gen_mtf(size)
	% Gives MTF for the given image size
	%Resizes predetermined MTF which is saved under name MTF_2d in a file nbamed MTF_2d.mat in same directory
	cd ../data
	load('MTF_2d.mat');
	new_MTF=imresize(MTF_2d,[size,size]);
	new_MTF=(new_MTF./(max(new_MTF(:)))).*max(MTF_2d(:));
	new_MTF(new_MTF<0)=0;
	cd ../functions

end
