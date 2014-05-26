% Pilla inte på denna kod om du inte är 100% säker på vad du gör!
function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_OutputFcn, ...
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

% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)
handles = guidata(handles.figure1);
handles.output = hObject;
set_up(hObject, handles);
% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
%
% Update handles structure
handles = guidata(handles.figure1);
guidata(handles.figure1, handles);

% --- Executes on button press in Measure_QE_button.
function Measure_QE_button_Callback(hObject, eventdata, handles)
% hObject    handle to Measure_QE_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.figure1);

button_state = get(hObject, 'Value');
if button_state == get(hObject, 'Max')
    try
        setappdata(handles.figure1,'measurement_type','QuantumEfficiency');
        set(handles.Measure_QE_button,'Value',get(hObject, 'Max'));
        set(handles.Measure_spectrum,'Value',get(hObject, 'Min'));
        
        guidata(handles.figure1, handles);
    catch err
        shutdown_simulator(handles);
        rethrow(err);
    end
end
% Hint: get(hObject,'Value') returns toggle state of Measure_QE_button


% --- Executes on button press in Measure_spectrum.
function Measure_spectrum_Callback(hObject, eventdata, handles)
% hObject    handle to Measure_spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.figure1);

button_state = get(hObject, 'Value');
if button_state == get(hObject, 'Max')
    try
        setappdata(handles.figure1,'measurement_type','specificSpectrum');
        set(handles.Measure_spectrum,'Value',get(hObject, 'Max'));
        set(handles.Measure_QE_button,'Value',get(hObject, 'Min'));
        
        guidata(handles.figure1, handles);
    catch err
        shutdown_simulator(handles);
        rethrow(err);
    end
end
% Hint: get(hObject,'Value') returns toggle state of Measure_spectrum

% --- Executes on button press in Start_measurement.
function Start_measurement_Callback(hObject, eventdata, handles)
% hObject    handle to Start_measurement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles = guidata(handles.figure1);
    
    switchCase = getappdata(handles.figure1,'measurement_type');
    switch(switchCase)
        case('specificSpectrum')
            Output_spectrum(handles)
        case('QuantumEfficiency')
            Output_quantum_vibrations(handles);
        otherwise
            return;
    end
catch err
    shutdown_simulator(handles);
    rethrow(err);
end
guidata(handles.figure1, handles);


% --- Executes on button press in Help_button.
function Help_button_Callback(hObject, eventdata, handles)
% hObject    handle to Help_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%checks if user manual excists and opens it, otherwise displays an error
%message
if exist('user_manual.pdf', 'file')==2
    open('user_manual.pdf');
else
    disp('Användarmanualen kunde inte öppnas');
end


% --- Executes on selection change in Chosen_spektrum.
function Chosen_spektrum_Callback(hObject, eventdata, handles)
% hObject    handle to Chosen_spektrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.figure1);
try
    contents = cellstr(get(hObject,'String'));
    spectrum = load('SparadeSpektrum/savedSpectrums', contents{get(hObject,'Value')}, '-ascii');
    
    %använd filnamn i drop-down-listan?
    setappdata(handles.figure1,'chosen_spectrum', spectrum);
catch err
    if strcmp(err.identifier,'MATLAB:load:couldNotReadFile');
        setappdata(handles.figure1,'chosen_spectrum', zeros(1,16));
    else
        shutdown_simulator(handles);
        rethrow(err);
    end
end
guidata(handles.figure1, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns Chosen_spektrum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Chosen_spektrum

% --- Executes during object creation, after setting all properties.
%fix so that it displays all the files in savedSpectrums
function Chosen_spektrum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Chosen_spektrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
   


% --- Executes on button press in Create_spectrum.
function Create_spectrum_Callback(hObject, eventdata, handles)
% hObject    handle to Create_spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% support for this functionality is left for future iterations of the
% project


function From_IV_edit_Callback(hObject, eventdata, handles)
% hObject    handle to From_IV_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of From_IV_edit as text
%        str2double(get(hObject,'String')) returns contents of From_IV_edit as a double
handles = guidata(handles.figure1);

from_iv=getappdata(handles.figure1, 'from_iv');
%checks if the given intervall is ok
if from_iv<-5
    disp('Du har valt ett otillåtet intervall, spänningen sätts automatiskt till -5 V');
    setappdata(handles.figure1,'from_iv', -5);
    set(handles.From_IV_edit,'String','-5');
elseif from_iv>= getappdata(handles.figure1,'to_iv')
    disp('startintervallet börjar efter slutintervallet, startintervallet sätts nu automatiskt till -5');
    setappdata(handles.figure1,'from_iv', -5);
    set(handles.From_IV_edit,'String','-5');
else
    
setappdata(handles.figure1, 'from_iv', from_iv);
end
guidata(handles.figure1, handles);


% --- Executes during object creation, after setting all properties.
function From_IV_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to From_IV_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function To_IV_edit_Callback(hObject, eventdata, handles)
% hObject    handle to To_IV_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of To_IV_edit as text
%        str2double(get(hObject,'String')) returns contents of To_IV_edit as a double
handles = guidata(handles.figure1);
to_iv = getappdata(handles.figure1,'to_iv');
if to_iv>15
    disp('Du har valt ett otillåtet intervall,slutspänningen sätts nu automatiskt till 15');
    setappdata(handles.figure1, 'to_iv', 15);
    set(handles.To_IV_edit,'String','15');
elseif to_iv <=getappdata(handles.figure1,'from_iv')
    disp('Din slutspänning är mindre än din startspänningen, slutspänningen sätts nu till 15');
    setappdata(handles.figure1, 'to_iv', 15);
    set(handles.To_IV_edit,'String','15');
else
    setappdata(handles.figure1, 'to_iv', to_iv);
end
guidata(handles.figure1, handles);

% --- Executes during object creation, after setting all properties.
function To_IV_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to To_IV_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Step_IV_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Step_IV_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Step_IV_edit as text
%        str2double(get(hObject,'String')) returns contents of Step_IV_edit as a double
handles = guidata(handles.figure1);
if str2double(get(hObject,'String'))<100
    disp('du har matat in en steglängd som inte går att använda, steglängden sätts nu automatiskt till 100.');
    setappdata(handles.figure1, 'step_iv', 100);
    set(handles.Step_IV_edit,'String','100');
elseif ~mod(str2double(get(hObject,'String')),1)==0
    disp('du har matat in en steglängd som inte är ett heltal, steglängden sätts nu automatiskt till närmsta heltal.');
    setappdata(handles.figure1, 'step_iv', round(str2double(get(hObject,'String'))));
    set(handles.Step_IV_edit,'String', num2str(getappdata(handles.figure1, 'step_iv')));
elseif str2double(get(hObject,'String'))>16300
    disp('du har matat in en steglängd som inte går att använda, steglängden sätts nu automatiskt till det maximala.')
    setappdata(handles.figure1,'step_iv',16300);
    set(handles.Step_IV_edit,'String','16300');
else
    setappdata(handles.figure1, 'step_iv', str2double(get(hObject,'String')));
end
guidata(handles.figure1, handles);


% --- Executes during object creation, after setting all properties.
function Step_IV_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Step_IV_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Illuminated_area_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Illuminated_area_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Illuminated_area_edit as text
%        str2double(get(hObject,'String')) returns contents of Illuminated_area_edit as a double
handles = guidata(handles.figure1);

if getappdata(handles.figure1,'illuminated_area')<=0
    disp('den belysta ytan kan inte vara mindre än 0, mata in korrekt area annars används arean 10');
    setappdata(handles.figure1, 'illuminated_area', 10);
    set(handles.Illuminated_area_edit,'String','10');
else
    setappdata(handles.figure1, 'illuminated_area', str2double(get(hObject,'String')));
end
guidata(handles.figure1, handles);

% --- Executes during object creation, after setting all properties.
function Illuminated_area_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Illuminated_area_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Measure_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Measure_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function R_edit_Callback(hObject, eventdata, handles)
% hObject    handle to R_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R_edit as text
%        str2double(get(hObject,'String')) returns contents of R_edit as a double
handles = guidata(handles.figure1);
if getappdata(handles.figure1,'R')<=0
    disp('Resistansen måste vara större än 0, mata in korrekt värde annars används R=10 ohm');
    set(handles.R_edit,'String','10');
    setappdata(handles.figure1, 'R', 1);
else
    setappdata(handles.figure1, 'R', str2double(get(hObject,'String')));
end
guidata(handles.figure1, handles);

% --- Executes during object creation, after setting all properties.
function R_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
