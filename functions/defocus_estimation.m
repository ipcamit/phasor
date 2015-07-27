function varargout = defocus_estimation(varargin)

  gui_Singleton = 1;
  gui_State = struct('gui_Name',       mfilename, ...
                     'gui_Singleton',  gui_Singleton, ...
                     'gui_OpeningFcn', @defocus_estimation_OpeningFcn, ...
                     'gui_OutputFcn',  @defocus_estimation_OutputFcn, ...
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

function defocus_estimation_OpeningFcn(hObject, eventdata, handles, varargin)

  handles.output = hObject;
  handles.fname='fft_stack.mat';
  handles.imnumber=1; %input('input image number which u want to open\n');
  cd ../usr_data
  load(handles.fname)
  %handles.img=im2double(im1);
%-----------------------------------------------------------
  load('datatem.mat','temdata')
    m=1024/temdata.binning;
    Ca=temdata.ca;
    if(mod(m,2)==0)
     zro = m/2+0.5;
     ind = m/2;
    else 
      zro = ceil(m/2); 
      ind=m/2+.05;
    end
  [ix,jx] = meshgrid(1:m); 
  r = ((ix-zro).^2 + (jx-zro).^2).^(0.5); 
  handles.k = r./(m*Ca);
%-------------------------------------------------------
  load(handles.fname,'profile')
  cd ../functions
  handles.img=flipud(stackfft(handles.imnumber).raw);
  handles.prof=profile(handles.imnumber).smth;
  global defocus;
  clear profile
  clear stackfft
  set(handles.edit_min,'String',-10);
  set(handles.edit_max,'String',10);
  guidata(hObject, handles);




% --- Outputs from this function are returned to the command line.
function varargout = defocus_estimation_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;





% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
  
 df=get(handles.slider1,'Value');
 [ctf2d]=waf1d(df);
 back=handles.prof;
 a=max(handles.img(:));
 [sx,sy]=size(handles.img);
 handles.img(:,1:sx/2)=(a.*(ctf2d(:,1:sx/2)));
 
 cla
 
 % Flip the image upside down before showing it, as cordinate system changes in image and graph mode
 size_k=max(size(handles.k));
 imagesc([-max(handles.k(round(size_k/2),:)) max(handles.k(round(size_k/2),:))],[-3.5,4.5], flipud(handles.img));
 colormap('gray');
 
 hold on;
 
 plot(handles.k(round(size_k/2),:),back+.3,'LineWidth',2,'Color',[0 .5 1])
 plot(linspace(-handles.k(round(size_k/2),1),handles.k(round(size_k/2),1),size_k),ctf2d(round(size_k/2),:)+.5,'LineWidth',2,'Color',[1 1 0])
 axis([-.45*10^10 .45*10^10 -.5 1.5]);
  
 % set the y-axis back to normal.
 set(gca,'ydir','normal');
 
 set(handles.text1,'String',num2str(df));
 guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_min_Callback(hObject, eventdata, handles)

  minimum=get(handles.edit_min,'String');
  minimum=str2num(minimum);
  set(handles.slider1,'Min',minimum);
  set(handles.edit_min,'String',num2str(minimum));
  guidata(hObject,handles);
  % Hints: get(hObject,'String') returns contents of edit_min as text
  %        str2double(get(hObject,'String')) returns contents of edit_min as a double
  
  
% --- Executes during object creation, after setting all properties.
function edit_min_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_max_Callback(hObject, eventdata, handles)
  
  maximum=get(handles.edit_max,'String');
  set(handles.edit_max,'String',maximum);
  maximum=str2num(maximum);
  set(handles.slider1,'Max',maximum)
  guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function edit_max_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_def_Callback(hObject, eventdata, handles)
  
  val=get(handles.edit_def,'String');
  set(handles.edit_def,'String',val);
  val=str2num(val);
  maximum=get(handles.slider1,'Max');
  minimum=get(handles.slider1,'Min');
  if(val>maximum)
      set(handles.slider1,'Max',val);
      set(handles.edit_max,'String',num2str(val));
  end
  if(val<minimum)
      set(handles.slider1,'Min',val);
      set(handles.edit_min,'String',num2str(val));
  end
  
  
  yaxis=waf1d(val);
  back=handles.prof;
  cla
  
  % Flip the image upside down before showing it
  imagesc([-max(handles.k(:)) max(handles.k(:))], [-1.5 1.5], flipud(handles.img.^.05));
   colormap('gray');
  
  hold on;
  plot(handles.k,yaxis,'LineWidth',2,'Color',[0 1 0])
  plot(handles.k,back,'LineWidth',2,'Color',[0 .5 1])
  axis([-.8*10^10 0 0 1]);
   
  % set the y-axis back to normal.
  set(gca,'ydir','normal');
  
  set(handles.text1,'String',num2str(val));
  guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_def_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_spherical_Callback(hObject, eventdata, handles)
  cd ../usr_data
  load('datatem.mat');
  a=get(handles.edit_spherical,'String');
  set(handles.edit_spherical,'String',a);
  a=str2num(a)*10^-3;
  temdata.cs=a;
  save('datatem.mat','temdata','-append');
  cd ../functions
  guidata(hObject,handles)

function edit_spherical_CreateFcn(hObject, eventdata, handles)


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_scale_Callback(hObject, eventdata, handles)
  cd ../usr_data
  load('datatem.mat');
  Ca=get(handles.edit_scale,'String');
  set(handles.edit_scale,'String',Ca);
  temdata.ca=str2num(Ca)*10^-10;
  
  save('datatem.mat');
  cd ../functions
  guidata(hObject,handles)

function edit_scale_CreateFcn(hObject, eventdata, handles)


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton3_Callback(hObject, eventdata, handles)
  global defocus;
  defocus(handles.imnumber)=str2double(get(handles.text1,'String'));
  %defocus(handles.imnumber)=str2double(defocus(handles.imnumber));
  
  
  try
    cd ../usr_data
    handles.imnumber=handles.imnumber+1;
    load(handles.fname)
    load('fft_stack.mat','profile')
    cd ../functions
    handles.img=(stackfft(handles.imnumber).raw);
    handles.prof=profile(handles.imnumber).smth;
    clear profile
    clear stackfft
  catch
    msgbox('Done with all images!! Running reconstruction!')
    cd ../usr_data
    save('defocus.mat','defocus') 
    cd ../functions
    reconstruction()
  end

guidata(hObject,handles)
