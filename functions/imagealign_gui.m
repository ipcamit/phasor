function varargout = imagealign_gui(varargin)
% IMAGEALIGN_GUI MATLAB code for imagealign_gui.fig


% Last Modified by GUIDE v2.5 10-Jul-2015 18:07:32

% Begin initialization code - DO NOT EDIT
	gui_Singleton = 1;
	gui_State = struct('gui_Name',       mfilename, ...
	                   'gui_Singleton',  gui_Singleton, ...
	                   'gui_OpeningFcn', @imagealign_gui_OpeningFcn, ...
	                   'gui_OutputFcn',  @imagealign_gui_OutputFcn, ...
	                   'gui_LayoutFcn',  [] , ...
	                   'gui_Callback',   []);
	if nargin && ischar(varargin{1})
	    gui_State.gui_Callback = str2func(varargin{1});
	end
	
	if nargout
	    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
	else
	    gui_mainfcn(gui_State, varargin{:});
	end
	% End initialization code - DO NOT EDIT
%--------------------------------------------------------------------------------

% --- Executes just before imagealign_gui is made visible.
function imagealign_gui_OpeningFcn(hObject, eventdata, handles, varargin)

	handles.output = hObject;
	set(handles.pushbutton3,'Visible','off')
	cd ../usr_data
	handles.stack=load('img_stack.mat','stack');
	cd ../functions
	axes(handles.axes1)
	imshow(handles.stack.stack(1).raw)
	handles.imgnum=max([size(handles.stack.stack)]);
	axes(handles.axes2)
	imshow(handles.stack.stack(handles.imgnum).raw)
	handles.position=0;
	% Update handles structure
	guidata(hObject, handles);

%--------------------------------------------------------------------------------



% --- Outputs from this function are returned to the command line.
function varargout = imagealign_gui_OutputFcn(hObject, eventdata, handles) 
	varargout{1} = handles.output;
%--------------------------------------------------------------------------------


% --- Executes on button press in pushbutton1.
%function pushbutton1_Callback(hObject, eventdata, handles)
%	h=msgbox('Please select area of image you want to reconstruct (in image 1)');
%	uiwait(h);
%	hfindROI = findobj(handles.axes1,'Type','imrect');
%	delete(hfindROI)
%	
%	
%	hROI = imrect(handles.axes1,[10 10 100 100]); %copied from stackexchange!!!
%	setFixedAspectRatioMode(hROI,1); 
%	%position = wait(h);
%	axes(handles.axes2)
%	rectangle('Position',[10 10 100 100],'EdgeColor','y','LineWidth',2)
%	id = addNewPositionCallback(hROI,@(s,e) GetROIPosition(hROI,hObject, eventdata, handles));
%		
%	
%	handles.position = wait(hROI);
%  	handles.stack(1).crop = imcrop(handles.stack.stack(1).raw,handles.position);
%	figure;set(gcf,'name','Cropped Image');imshow(handles.stack(1).crop);
%	guidata(hObject,handles)
%
%	%[cropped_image,crop_coordinates]=imcrop(handles.stack.stack(1).raw);
%%--------------------------------------------------------------------------------





% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
	df_rng=str2double(inputdlg('Please enter approximate maximum defocus iteration'));
	relative_def('img_stack.mat','rel_def.mat',df_rng)
	position=handles.position;
	im_align_self()
	%im_align('img_stack.mat','img_aligned_stack.mat',round(position))
	guidata(hObject,handles)
%--------------------------------------------------------------------------------





% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
	h=msgbox('Generating FFT pattern for all images, it might take a little while');
	fft_profiler('img_stack.mat','fft_stack.mat')
	close(h)
	defocus_estimation
	guidata(hObject,handles)
%--------------------------------------------------------------------------------





% --- Executes on button press in pushbutton4.
%function pushbutton4_Callback(hObject, eventdata, handles)
%	imagealign_gui
%	pushbutton1_Callback(hObject, eventdata, handles)
%	guidata(hObject,handles)
%--------------------------------------------------------------------------------






function ROIPos = GetROIPosition(hROI,hObject, eventdata, handles)

	ROIPos = round(getPosition(hROI));

	axes(handles.axes2)

	hRect = findobj('Type','rectangle');
	delete(hRect)
	rectangle('Position',ROIPos,'EdgeColor','y','LineWidth',2);
