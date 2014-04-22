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

% Last Modified by GUIDE v2.5 10-Apr-2014 16:43:11


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

%set_up(handles); %set up per scan or per executable run?
% Choose default command line output for GUI

handles.output = hObject;

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
guidata(handles.figure1, handles);

% --- Executes on button press in Measure_QE_button.
function Measure_QE_button_Callback(hObject, eventdata, handles)
% hObject    handle to Measure_QE_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.figure1,'measurement_type','QuantumEfficiency');
setappdata(handles.figure1,'chosen_spectrum',getappdata(handles.figure1,'QE_spectrum'));
% Hint: get(hObject,'Value') returns toggle state of Measure_QE_button


% --- Executes on button press in Measure_spectrum.
function Measure_spectrum_Callback(hObject, eventdata, handles)
% hObject    handle to Measure_spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.figure1,'measurement_type','SpecificSpectrum');
% Hint: get(hObject,'Value') returns toggle state of Measure_spectrum


% --- Executes on button press in Measure_IV_curve.
function Measure_IV_curve_Callback(hObject, eventdata, handles)
% hObject    handle to Measure_IV_curve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.figure1,'measurement_type','IVCurve');
% Hint: get(hObject,'Value') returns toggle state of Measure_IV_curve


% --- Executes on button press in Start_measurement.
function Start_measurement_Callback(hObject, eventdata, handles)
% hObject    handle to Start_measurement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switchCase = getappdata(handles.figure1,'measurement_type'); 
switch(switchCase)
    case('specificSpectrum')
        error('measuring specific spectrum')
    case('IVCurve')
        error('measuring IV-curve')
    case('QuantumEfficiency')
        error('measuring quantum efficiency')
    otherwise
        return;
end


% --- Executes on button press in Help_button.
function Help_button_Callback(hObject, eventdata, handles)
% hObject    handle to Help_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in Chosen_spektrum.
function Chosen_spektrum_Callback(hObject, eventdata, handles)
% hObject    handle to Chosen_spektrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
spectrum = load(contents{get(Hobject,'Value')} + '.m','Data');

%använd filnamn i drop-down-listan?
setappdata(handles.figure1,'chosen_spectrum',spectrum);

% Hints: contents = cellstr(get(hObject,'String')) returns Chosen_spektrum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Chosen_spektrum


% --- Executes during object creation, after setting all properties.
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




function From_IV_edit_Callback(hObject, eventdata, handles)
% hObject    handle to From_IV_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of From_IV_edit as text
%        str2double(get(hObject,'String')) returns contents of From_IV_edit as a double


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


% --- Executes on button press in calibration_QE.
function calibration_QE_Callback(hObject, eventdata, handles)
% hObject    handle to calibration_QE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of calibration_QE



function Measure_time_Callback(hObject, eventdata, handles)
% hObject    handle to Measure_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Measure_time as text
%        str2double(get(hObject,'String')) returns contents of Measure_time as a double

% --- Executes during object creation, after setting all properties.

function Measure_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Measure_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
