% Pilla inte p� denna kod om du inte �r 100% s�ker p� vad du g�r!
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
        helpdlg(strcat(err.identifier, ': ', err.message));
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
        helpdlg(strcat(err.identifier, ': ', err.message));
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
    session = getappdata(handles.figure1,'session');
    if ~session.IsDone
        error('daqRuntime:sessionNotDone','The session is running a measurement, be patient.')
    end
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
    if strcmp(err.identifier,'daqRuntime:sessionNotDone')
        helpdlg(err.message);
    else
    shutdown_simulator(handles);
    helpdlg(strcat(err.identifier, ': ', err.message));
    rethrow(err);
    end
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
    helpdlg('Anv�ndarmanualen kunde inte �ppnas, filen kunde inte hittas');
end


% --- Executes on selection change in Chosen_spektrum.
function Chosen_spektrum_Callback(hObject, eventdata, handles)
% hObject    handle to Chosen_spektrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.figure1);
try
    contents = cellstr(get(hObject,'String'));
    spectrum = ImportSpectrum(contents{get(hObject,'Value')});
    % f�r framtida bruk, ovanst�ende funktion h�mtar alltid AM1.5 tills
    % ImportSpectrum �r automatiserad.
        
    %anv�nd filnamn i drop-down-listan?
    setappdata(handles.figure1,'chosen_spectrum', spectrum);
catch err
    if strcmp(err.identifier,'MATLAB:load:couldNotReadFile');
        setappdata(handles.figure1,'chosen_spectrum', zeros(1,16));
    elseif strcmp(err.identifier,'runtimeError:spectrumFault')
        helpdlg(err.message);
    else
        shutdown_simulator(handles);
        helpdlg(strcat(err.identifier, ': ', err.message));
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

from_iv = str2double(get(hObject,'String'));
%checks if the given intervall is ok
if isnan(from_iv)
    disp('du har matat in ett ogiltigt v�rde, v�nligen f�rs�k igen');
    setappdata(handles.figure1,'from_iv', -1);
    set(handles.From_IV_edit,'String','-1');
    
elseif from_iv<-5
    disp('Du har valt ett otill�tet intervall, sp�nningen s�tts automatiskt till -5 V');
    setappdata(handles.figure1,'from_iv', -5);
    set(handles.From_IV_edit,'String','-5');
    
elseif from_iv >= getappdata(handles.figure1,'to_iv')
    disp('startintervallet b�rjar efter slutintervallet, startintervallet s�tts nu automatiskt till -5');
    setappdata(handles.figure1,'from_iv', -5);
    set(handles.From_IV_edit,'String','-5');
    
elseif from_iv > 15
    disp('Du har valt ett otill�tet intervall, sp�nningen s�tts automatiskt till 0');
    setappdata(handles.figure1,'from_iv', 0);
    set(handles.From_IV_edit,'String','0');
    
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
to_iv = str2double(get(hObject,'String'));

if isnan(to_iv)
    disp('du har matat in ett ogiltigt v�rde, v�nligen f�rs�k igen');
    setappdata(handles.figure1, 'to_iv', 2);
    set(handles.To_IV_edit,'String','2');
    
elseif to_iv > 15
    disp('Du har valt ett otill�tet intervall,slutsp�nningen s�tts nu automatiskt till 15');
    setappdata(handles.figure1, 'to_iv', 15);
    set(handles.To_IV_edit,'String','15');
    
elseif to_iv <= getappdata(handles.figure1,'from_iv')
    disp('Din slutsp�nning �r mindre �n din startsp�nningen, slutsp�nningen s�tts nu till 15');
    setappdata(handles.figure1, 'to_iv', 15);
    set(handles.To_IV_edit,'String','15');

elseif to_iv < -5
    disp('Du har valt ett otill�tet intervall, sp�nningen s�tts automatiskt till 0');
    setappdata(handles.figure1,'from_iv', 0);
    set(handles.From_IV_edit,'String','0');
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
step_IV = str2double(get(hObject,'String'));
if isnan(step_IV)
    disp('du har matat in ett ogiltigt v�rde, v�nligen f�rs�k igen');
    setappdata(handles.figure1, 'step_iv', 100);
    set(handles.Step_IV_edit,'String','100');
    
elseif step_IV <100
    disp('du har matat in en stegl�ngd som inte g�r att anv�nda, stegl�ngden s�tts nu automatiskt till 100.');
    setappdata(handles.figure1, 'step_iv', 100);
    set(handles.Step_IV_edit,'String','100');
    
elseif ~mod(step_IV,1)==0
    disp('du har matat in en stegl�ngd som inte �r ett heltal, stegl�ngden s�tts nu automatiskt till n�rmsta heltal.');
    setappdata(handles.figure1, 'step_iv', round(str2double(get(hObject,'String'))));
    set(handles.Step_IV_edit,'String', num2str(getappdata(handles.figure1, 'step_iv')));
    
elseif step_IV>16300
    disp('du har matat in en stegl�ngd som inte g�r att anv�nda, stegl�ngden s�tts nu automatiskt till det maximala.')
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
try
area = str2double(get(handles.Illuminated_area_edit, 'String'));
if isnan(area)
    written_string = get(handles.Illuminated_area_edit, 'String');
    if strcmpi(written_string, 'Disco');
        Disco(handles);
    else
        error('runtime:edit_error','Du har matat in ett felaktigt v�rde, f�rs�k igen');
    end
elseif area <= 0
    error('runtime:forbidden_value','den belysta ytan kan inte vara mindre �n 0, mata in korrekt area annars anv�nds arean 10');
elseif area > 960
    error('runtime:forbidden_value','den belysta ytan kan inte vara st�rre �n diodpanelen, mata in korrekt area annars anv�nds arean 10');
else
    setappdata(handles.figure1, 'illuminated_area', str2double(get(hObject,'String')));
end
guidata(handles.figure1, handles);

catch err
    if strcmp(err.identifier, 'runtime:edit_error') || strcmp(err.identifier, 'runtime:forbidden_value')
        helpdlg(err.message);
        setappdata(handles.figure1, 'illuminated_area', 10);
        set(handles.Illuminated_area_edit,'String','10');
    else
        helpdlg(err.message);
        rethrow(err);
    end
end
    
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


function R_edit_Callback(hObject, eventdata, handles)
% hObject    handle to R_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R_edit as text
%        str2double(get(hObject,'String')) returns contents of R_edit as a double
handles = guidata(handles.figure1);
R = getappdata(handles.figure1,'R');
if isnan(R)
    disp('du har matat in ett ogiltigt v�rde, v�nligen f�rs�k igen');
    set(handles.R_edit,'String','10');
    setappdata(handles.figure1, 'R', 10);
elseif R <=0
    disp('Resistansen m�ste vara st�rre �n 0, mata in korrekt v�rde annars anv�nds R=10 ohm');
    set(handles.R_edit,'String','10');
    setappdata(handles.figure1, 'R', 1);
elseif R > 1000000000
    disp('Resistansen m�ste vara mindre �n eller lika med 1 GOhm, resistansen s�tts nu till 1 GOhm')
    set(handles.R_edit,'String','1000000000');
    setappdata(handles.figure1, 'R', 1000000000);
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


% --- Executes on button press in Simulator_on.
function Simulator_on_Callback(hObject, eventdata, handles)
% hObject    handle to Simulator_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.figure1);

try
button_state = get(hObject, 'Value');
    if button_state == get(hObject, 'Max')
        set(hObject, 'String', 'Sl�ck solsimulator');
        Simulator_on(handles);
    else
        shutdown_simulator(handles);
        set(hObject, 'String', 'T�nd solsimulator');
    end
catch err
    shutdown_simulator(handles);
    helpdlg(strcat(err.identifier, ': ', err.message));
    rethrow(err);
end
guidata(handles.figure1, handles);


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
try
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clickState = getappdata(handles.figure1, 'clickState');
if (clickState == 0)
    setappdata(handles.figure1, 'clickState', 1);
    manualAdjustment(handles);
end

catch err
    shutdown_simulator(handles);
    helpdlg(strcat(err.identifier, ': ', err.message));
    rethrow(err);
end


