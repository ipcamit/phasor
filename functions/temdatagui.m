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
 
  handles.output = hObject;
  % Update handles structure
  guidata(hObject, handles);




% --- Outputs from this function are returned to the command line.
function varargout = temdatagui_OutputFcn(hObject, eventdata, handles) 
  
  
  % Get default command line output from handles structure
  varargout{1} = handles.output;

%-----------------------------------------------------------------------------------------------------------------------------


function edit1_Callback(hObject, eventdata, handles)

  global temdata;
  temdata.cs = str2double(get(hObject,'String'))*10^-3;
  
  
  %-----------------------------------------------------------------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
  
  
  
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

%-----------------------------------------------------------------------------------------------------------------------------

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)

  option = get(hObject,'Value');
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
  

%-----------------------------------------------------------------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
  % Hint: popupmenu controls usually have a white background on Windows.
  %       See ISPC and COMPUTER.
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end
  
%-----------------------------------------------------------------------------------------------------------------------------


function figure1_WindowButtonDownFcn(hObject, eventdata, handles)



%-----------------------------------------------------------------------------------------------------------------------------
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
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
  filelist.name
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
  save('../usr_data/img_stack.mat','stack')
  guidata(hObject,handles)

%-----------------------------------------------------------------------------------------------------------------------------
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
  
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
  
  if (data_tem+data_img)<2
    no_data_choice=questdlg('No data or image files were found in usr_data directory. Please press save data button to save current setting. Press Yes to enter image folder? Press "No" for exiting the program');
  
    switch no_data_choice
      case 'Yes'
        pushbutton1_Callback(hObject, eventdata, handles)
        
      otherwise
        msgbox('Exiting the program. No data provided')
        error('No user data')    
    end
  else
    imagealign_gui
  end
  guidata(hObject,handles)



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
  
  global temdata;
  
  switch get(get(handles.uipanel1,'SelectedObject'),'Tag')
  case 'binning1'
    global temdata;temdata.binning=1;
  case 'binning2'
    global temdata;temdata.binning=2;
  end
  temdata.lambda=2.74*10^(-12);
  if (isfield(temdata,'cs'))&(isfield(temdata,'bet'))&(isfield(temdata,'delt'))
    temdata.ca=temdata.ca*temdata.binning;
    save('../usr_data/datatem.mat','temdata')
  else
    msgbox('Please eneter proper value for coefficients and press save again')
  end



function edit2_Callback(hObject, eventdata, handles)
  
  global temdata;
  temdata.delt = str2double(get(hObject,'String'));
  temdata.delt=temdata.delt*10^-9; %convert to nanometer
  
  


function edit2_CreateFcn(hObject, eventdata, handles)

 
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end
  
  

function edit3_Callback(hObject, eventdata, handles)

  global temdata;
  temdata.bet = str2double(get(hObject,'String'));
  temdata.bet = temdata.bet*10^-3; %convert to milirad




function edit3_CreateFcn(hObject, eventdata, handles)
  
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end
