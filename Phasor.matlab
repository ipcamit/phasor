% One program to bind them all!!!
% main wrapping script for the "Phasor"
% Divided into following parts :
% 1. Assembling images into one .mat file
% 2. Cropping images into 1024x1024 square and finding there fft profiles for defocus estimation (till i find a way to automate it)
% 3. Finding phase correlation function to align images, at this stage area of interest will be asked
% 4. Aligning the images and finding relative defocus
% 5. Finding absolute defocus of some intermediate image (preferably last one)
% 6. Determining defocus of whole series and using it to reconstruct phase
% Possible improvement to be added at later stages: Automated defocus, preferably through Kirkland routine, Parabolic Krivanek fit for Cs
% Here be Dragons!!!
display('Starting program...');
display('Assuming images are named as "name1.tiff", "name2.tiff" etc. If not then please modify stack_image function in ../functions directory')
stack_image();
inp='img_stack.mat';oup='img_fftstack.mat';
fft_profiler(inp,oup);
display('Checking microscope parameters...')
savedat2d();
display('Determining relative defocus between images...');
relative_def(inp,oup);
display('Aligning the images')
oup2='img_alignstack.mat';
img_align(inp,oup2);
display('Images aligned and saved as stack2.raw under file ../data/img_alignstack.mat')
display('Determine absolute defocus of any image to start reconstruction...')
cont=input('Shall we continue? (y/n)',s);
if cont=='y'
	defocus_estimation();
else
	break;
end


