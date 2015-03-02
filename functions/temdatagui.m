function varargout = temdatagui(varargin)
%temdatagui is called as the fist function in the programme. It is used to gather all the data from the user




gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @temdatagui_OpeningFcn, ...
                   'gui_OutputFcn',  @temdatagui_OutputFcn, ...
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


% --- Executes just before temdatagui is made visible.
function temdatagui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to temdatagui (see VARARGIN)

% Choose default command line output for temdatagui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes temdatagui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = temdatagui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%-----------------------------------------------------------------------------------------------------------------------------


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

%-----------------------------------------------------------------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-----------------------------------------------------------------------------------------------------------------------------

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
option = get(hObject,'Value');
display(option);
switch option
  case 1
    resolution=12.75*10^-12;
  case 2
    resolution=15.14*10^-12;
  case 3
    resolution=17.93*10^-12;
  case 4
    resolution=23.71*10^-12;
  case 5
    resolution=31.08*10^-12;    
end
global temdata;
temdata.ca=resolution;
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

%-----------------------------------------------------------------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-----------------------------------------------------------------------------------------------------------------------------

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%-----------------------------------------------------------------------------------------------------------------------------
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button = questdlg('Please make sure all the images are in serial order, done?');
switch button
  case 'Yes'
  
  case 'No'
    msgbox('Please rearrange and rename images in acending order first and the restart the program');
    error('Program closed for sequential images');
  case 'Cancel'
    error('Cancelled by user')
  end
path=uigetdir;
%ser=char(inputdlg('intput name of the series','s'));
%num=str2double(inputdlg('enter total number of images')); 
filelist=dir(path);

if ispc
  slash='\'; %to maintain compatibility in linux and window systems. yet to be checked in linux
else
  slash='/';
end
imgNumber=1;
for(i=1:max(size(filelist)))
  
  if filelist(i).isdir==1
    continue
  else
    stack(imgNumber).raw=im2double(imread(strcat(path,slash,char(filelist(i).name))));
    imgNumber=imgNumber+1;
  end
end
imgNumber=imgNumber-1;
cd ../usr_data
save('img_stack.mat')
cd ../functions


%-----------------------------------------------------------------------------------------------------------------------------
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data
switch get(get(handles.uipanel1,'SelectedObject'),'Tag')
case 'binning1'
  global temdata;temdata.binning=1;
case 'binning2'
  global temdata;temdata.binning=2;
end
check_existing_file=dir('../usr_data');
data_tem=0;
data_img=0;
for counter=1:max(size(check_existing_file))
  if check_existing_file(counter).isdir==0
    if strcmp(char(check_existing_file(counter).name),'datatem.mat')
      data_tem=1;
    elseif strcmp(char(check_existing_file(counter).name),'img_stack.mat')
      data_img=1;
    end
  end
end
if data_tem+data_img>0
  no_data_choice=questdlg('No data or image files were found in usr_data directory. Would you like to enter them? Press "No" for exiting the program');

  switch no_data_choice
    case 'Yes'
      pushbutton1_Callback(hObject, eventdata, handles)
      
    otherwise
      msgbox('Exiting the program. No data provided')
      error('No user data')
      
  end
end

cd ../usr_data
save('datatem.mat','temdata')
cd ../functions
