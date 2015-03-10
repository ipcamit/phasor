function varargout = phasecomcor_gui(varargin)
% phasecomcor_gui compares 2 images' phase correlation function 

% Last Modified by GUIDE v2.5 04-Mar-2015 01:09:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @phasecomcor_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @phasecomcor_gui_OutputFcn, ...
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


% --- Executes just before phasecomcor_gui is made visible.
function phasecomcor_gui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
cd ../usr_data
load ('img_stack.mat','stack')
cd ../functions
handles.img1= imcrop(stack(1).raw,[0,0,1024,1024]);
handles.img2= imcrop(stack(1).raw,[0,0,1024,1024]);
axes(handles.image1);
imshow(handles.img1,[]);
axes(handles.image2);
imshow(handles.img2,[]);
set(handles.edit2,'String','25');
set(handles.edit1,'String','-25');
set(handles.slider1,'Max',25);
set(handles.slider1,'Min',-25);

guidata(hObject, handles);
% ----------------------------------------------------------------------------------------------





function varargout = phasecomcor_gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
% ----------------------------------------------------------------------------------------------


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
df=get(handles.slider1,'Value');
pmat=abs(phasepcorr(handles.img1,handles.img2,df));
pmat_zoom=pmat(256:(512+256),256:(512+256));
[maximum,index]=max(pmat_zoom(:));
max_loc_x=ind2sub(index,size(pmat_zoom));
overlav_mat=ones(size(pmat_zoom));overlav_mat((max_loc_x(1)-256),:)=0;
%size(pmat_zoom)
%size(overlav_mat)
axes(handles.axes3)
rgb = ind2rgb(gray2ind((((abs(pmat_zoom)))./abs(max(pmat_zoom(:))))*250.*overlav_mat,255),winter(255));
imshow(rgb,[])
handles.maxh=max(pmat(:));
axes(handles.axes4)
plot((pmat_zoom(max_loc_x(1),:)))
a=num2str(handles.maxh);
set(handles.text1,'String',a);  


guidata(hObject,handles);



% ----------------------------------------------------------------------------------------------


function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% ----------------------------------------------------------------------------------------------


function edit1_Callback(hObject, eventdata, handles)

minval=get(handles.edit1,'String');
minval=str2double(minval);
set(handles.slider1,'Min',minval);
guidata(hObject,handles);



% ----------------------------------------------------------------------------------------------

function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% ----------------------------------------------------------------------------------------------


function edit2_Callback(hObject, eventdata, handles)
maxval=get(handles.edit2,'String');
maxval=str2double(maxval);
set(handles.slider1,'Max',maxval);
guidata(hObject,handles);



% ----------------------------------------------------------------------------------------------

function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ----------------------------------------------------------------------------------------------


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% ----------------------------------------------------------------------------------------------





function slider2_Callback(hObject, eventdata, handles)
% ----------------------------------------------------------------------------------------------







function slider2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
