function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%   GUI acts as the main function of the Helios system.
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


%% --- Executes just before GUI is made visible.
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

%% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% Self descriptory
function initialize_gui(fig_handle, handles, isreset)
% Update handles structure
handles = guidata(handles.figure1);
guidata(handles.figure1, handles);


%% --- Executes on button press in Measure_QE_button.
function Measure_QE_button_Callback(hObject, eventdata, handles)
% hObject    handle to Measure_QE_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.figure1);

% This button sets the measurement_type attribute so that an quantum
% efficiency measurement will take place when the start measurement-button
% is pressed. It also makes sure that the IV-measurement button is not
% pressed.
try
    debug = getappdata(handles.figure1, 'debug_mode');
    if debug
        disp('Measure_QE_callback!');
    end
    
    button_state = get(hObject, 'Value');
    if button_state == get(hObject, 'Max')
        if debug
            disp('QE_measurement on');
        end
        setappdata(handles.figure1,'measurement_type','QuantumEfficiency');
        set(handles.Measure_QE_button,'Value',get(hObject, 'Max'));
        set(handles.Measure_spectrum,'Value',get(hObject, 'Min'));
        
        guidata(handles.figure1, handles);
    end
catch err
    shutdown_simulator(handles);
    uiwait(errordlg(strcat(err.identifier, ': ', err.message)));
    rethrow(err);
end

%% --- Executes on button press in Measure_spectrum.
function Measure_spectrum_Callback(hObject, eventdata, handles)
% hObject    handle to Measure_spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.figure1);

% Same as above but sets the attribute to IV-measurement instead.
try
    button_state = get(hObject, 'Value');
    debug = getappdata(handles.figure1, 'debug_mode');
    if debug
        disp('Measure_spectrum_callback!');
    end
    if button_state == get(hObject, 'Max')
        if debug
            disp('IV_measurement on');
        end
        setappdata(handles.figure1,'measurement_type','specificSpectrum');
        set(handles.Measure_spectrum,'Value',get(hObject, 'Max'));
        set(handles.Measure_QE_button,'Value',get(hObject, 'Min'));
        
        guidata(handles.figure1, handles);
    end
    
catch err
    shutdown_simulator(handles);
    uiwait(errordlg(strcat(err.identifier, ': ', err.message)));
    rethrow(err);
end

%% --- Executes on button press in Start_measurement.
function Start_measurement_Callback(hObject, eventdata, handles)
% hObject    handle to Start_measurement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When the start measurement-button is pressed this function first checks
% which type of measurement was intended, unless there is a measurement
% already in progress in which case the call will be terminated and an
% error message will be displayed.
% When a type of measurement has been established the function calls
% the appropriate control function.
try
    handles = guidata(handles.figure1);
    debug = getappdata(handles.figure1, 'debug_mode');
    if debug
        disp('Starting measurement');
    end
    setappdata(handles.figure1, 'clickState', -1);
    session = getappdata(handles.figure1,'session');
    if ~session.IsDone
        error('daqRuntime:sessionNotDone','The session is running a measurement, be patient.')
    end
    switchCase = getappdata(handles.figure1,'measurement_type');
    if debug
        disp(switchCase);
    end
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
        uiwait(errordlg(err.message));
    else
        shutdown_simulator(handles);
        uiwait(errordlg(strcat(err.identifier, ': ', err.message)));
        rethrow(err);
    end
end
guidata(handles.figure1, handles);




%% --- Exectues when the From_IV tab is altered
function From_IV_edit_Callback(hObject, eventdata, handles)
% hObject    handle to From_IV_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of From_IV_edit as text
%        str2double(get(hObject,'String')) returns contents of From_IV_edit as a double
handles = guidata(handles.figure1);
debug = getappdata(handles.figure1, 'debug_mode');
from_iv = str2double(get(hObject,'String'));
if debug
    disp('from_edit called');
    strcat('from_iv: ', num2str(from_iv));
end

%checks if the given intervall is ok
if isnan(from_iv)
    disp('du har matat in ett ogiltigt värde, vänligen försök igen');
    setappdata(handles.figure1,'from_iv', -1);
    set(handles.From_IV_edit,'String','-1');
    
elseif from_iv<-5
    disp('Du har valt ett otillåtet intervall, spänningen sätts automatiskt till -5 V');
    setappdata(handles.figure1,'from_iv', -5);
    set(handles.From_IV_edit,'String','-5');
    
elseif from_iv >= getappdata(handles.figure1,'to_iv')
    disp('startintervallet börjar efter slutintervallet, startintervallet sätts nu automatiskt till -5');
    setappdata(handles.figure1,'from_iv', -5);
    set(handles.From_IV_edit,'String','-5');
    
elseif from_iv > 15
    disp('Du har valt ett otillåtet intervall, spänningen sätts automatiskt till 0');
    setappdata(handles.figure1,'from_iv', 0);
    set(handles.From_IV_edit,'String','0');
    
else
    setappdata(handles.figure1, 'from_iv', from_iv);
end
guidata(handles.figure1, handles);


%% --- Executes during object creation, after setting all properties.
function From_IV_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to From_IV_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes when the To_IV tab is altered
function To_IV_edit_Callback(hObject, eventdata, handles)
% hObject    handle to To_IV_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of To_IV_edit as text
%        str2double(get(hObject,'String')) returns contents of To_IV_edit as a double
handles = guidata(handles.figure1);
debug = getappdata(handles.figure1, 'debug_mode');
to_iv = str2double(get(hObject,'String'));
if debug
    disp('to_IV called');
    disp(strcat('to_iv: ', num2str(to_iv)));
end
if isnan(to_iv)
    disp('du har matat in ett ogiltigt värde, vänligen försök igen');
    setappdata(handles.figure1, 'to_iv', 2);
    set(handles.To_IV_edit,'String','2');
    
elseif to_iv > 15
    disp('Du har valt ett otillåtet intervall,slutspänningen sätts nu automatiskt till 15');
    setappdata(handles.figure1, 'to_iv', 15);
    set(handles.To_IV_edit,'String','15');
    
elseif to_iv <= getappdata(handles.figure1,'from_iv')
    disp('Din slutspänning är mindre än din startspänningen, slutspänningen sätts nu till 15');
    setappdata(handles.figure1, 'to_iv', 15);
    set(handles.To_IV_edit,'String','15');
    
elseif to_iv < -5
    disp('Du har valt ett otillåtet intervall, spänningen sätts automatiskt till 0');
    setappdata(handles.figure1,'from_iv', 0);
    set(handles.From_IV_edit,'String','0');
else
    setappdata(handles.figure1, 'to_iv', to_iv);
end
guidata(handles.figure1, handles);

%% --- Executes during object creation, after setting all properties.
function To_IV_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to To_IV_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes when Step_IV tab is altered
function Step_IV_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Step_IV_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Step_IV_edit as text
%        str2double(get(hObject,'String')) returns contents of Step_IV_edit as a double
handles = guidata(handles.figure1);

debug = getappdata(handles.figure1, 'debug_mode');
step_IV = str2double(get(hObject,'String'));
if debug
    disp('to_IV called');
    disp(strcat('to_iv: ', num2str(step_IV)));
end

if isnan(step_IV)
    disp('du har matat in ett ogiltigt värde, vänligen försök igen');
    setappdata(handles.figure1, 'step_iv', 100);
    set(handles.Step_IV_edit,'String','100');
    
elseif step_IV <100
    disp('du har matat in en steglängd som inte går att använda, steglängden sätts nu automatiskt till 100.');
    setappdata(handles.figure1, 'step_iv', 100);
    set(handles.Step_IV_edit,'String','100');
    
elseif ~mod(step_IV,1)==0
    disp('du har matat in en steglängd som inte är ett heltal, steglängden sätts nu automatiskt till närmsta heltal.');
    setappdata(handles.figure1, 'step_iv', round(str2double(get(hObject,'String'))));
    set(handles.Step_IV_edit,'String', num2str(getappdata(handles.figure1, 'step_iv')));
    
elseif step_IV>16300
    disp('du har matat in en steglängd som inte går att använda, steglängden sätts nu automatiskt till det maximala.')
    setappdata(handles.figure1,'step_iv',16300);
    set(handles.Step_IV_edit,'String','16300');
else
    setappdata(handles.figure1, 'step_iv', str2double(get(hObject,'String')));
end
guidata(handles.figure1, handles);


%% --- Executes during object creation, after setting all properties.
function Step_IV_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Step_IV_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Exectues when the Illuminated_area tab is altered
function Illuminated_area_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Illuminated_area_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Illuminated_area_edit as text
%        str2double(get(hObject,'String')) returns contents of Illuminated_area_edit as a double
handles = guidata(handles.figure1);
try
    debug = getappdata(handles.figure1, 'debug_mode');
    area = str2double(get(handles.Illuminated_area_edit, 'String'));
    if debug
        disp('Illuminated_area called');
        disp(strcat('area: ', num2str(area)));
    end
    if isnan(area)
        written_string = get(handles.Illuminated_area_edit, 'String');
        if strcmpi(written_string, 'Disco');
            Disco(handles);
        else
            error('runtime:edit_error','Du har matat in ett felaktigt värde, försök igen');
        end
    elseif area <= 0
        error('runtime:forbidden_value','den belysta ytan kan inte vara mindre än 0, mata in korrekt area annars används arean 10');
    elseif area > 960
        error('runtime:forbidden_value','den belysta ytan kan inte vara större än diodpanelen, mata in korrekt area annars används arean 10');
    else
        setappdata(handles.figure1, 'illuminated_area', str2double(get(hObject,'String')));
    end
    guidata(handles.figure1, handles);
    
catch err
    if strcmp(err.identifier, 'runtime:edit_error') || strcmp(err.identifier, 'runtime:forbidden_value')
        uiwait(errordlg(err.message));
        setappdata(handles.figure1, 'illuminated_area', 10);
        set(handles.Illuminated_area_edit,'String','10');
    else
        uiwait(errordlg(err.message));
        rethrow(err);
    end
end

%% --- Executes during object creation, after setting all properties.
function Illuminated_area_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Illuminated_area_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% --- Executes when the R tab is altered
function R_edit_Callback(hObject, eventdata, handles)
% hObject    handle to R_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R_edit as text
%        str2double(get(hObject,'String')) returns contents of R_edit as a double
handles = guidata(handles.figure1);
try
    debug = getappdata(handles.figure1, 'debug_mode');
    R = getappdata(handles.figure1,'R');
    if debug
        disp('R_edit called');
        disp(strcat('R: ', num2str(area)));
    end
    if isnan(R)
        disp('du har matat in ett ogiltigt värde, vänligen försök igen');
        set(handles.R_edit,'String','10');
        setappdata(handles.figure1, 'R', 10);
    elseif R <=0
        disp('Resistansen måste vara större än 0, mata in korrekt värde annars används R=10 ohm');
        set(handles.R_edit,'String','10');
        setappdata(handles.figure1, 'R', 1);
    elseif R > 1000000000
        disp('Resistansen måste vara mindre än eller lika med 1 GOhm, resistansen sätts nu till 1 GOhm')
        set(handles.R_edit,'String','1000000000');
        setappdata(handles.figure1, 'R', 1000000000);
    else
        setappdata(handles.figure1, 'R', str2double(get(hObject,'String')));
    end
    guidata(handles.figure1, handles);
    
catch err
    if strcmp(err.identifier, 'runtime:edit_error') || strcmp(err.identifier, 'runtime:forbidden_value')
        uiwait(errordlg(err.message));
        setappdata(handles.figure1, 'R', 10);
        set(handles.R_edit,'String','10');
    else
        disp(err.message);
        rethrow(err);
    end
end

%% --- Executes during object creation, after setting all properties.
function R_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on button press in Simulator_on.
function Simulator_on_Callback(hObject, eventdata, handles)
% hObject    handle to Simulator_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.figure1);
try
    button_state = get(hObject, 'Value');
    if button_state == get(hObject, 'Max')
        Simulator_on(handles,hObject);
    else
        shutdown_simulator(handles);
        debug = getappdata(handles.figure1, 'debug_mode');
        if debug
            disp('simulator turning off');
        end
        set(hObject, 'String', 'Switch on');
    end
    
catch err
    shutdown_simulator(handles);
    uiwait(errordlg(strcat(err.identifier, ': ', err.message)));
    rethrow(err);
end
guidata(handles.figure1, handles);


%% --- Executes on button press in ShowSpectrum.
function ShowSpectrum_Callback(hObject, eventdata, handles)
% hObject    handle to ShowSpectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles = guidata(handles.figure1);
    debug = getappdata(handles.figure1, 'debug_mode');
    wanted_spectrum = getappdata(handles.figure1, 'wanted_spectrum');
    
    [measured_spectrum, success] = getSpectrum(handles);
    
    if debug
        disp('In showSpectrum: ');
        disp('size of measured spectrum: ');
        disp(size(measured_spectrum));
        disp('clickState: ');
        disp(getappdata(handles.figure1, 'clickState'));
        
        axes(handles.axes1);
        cla;
        %Scales the measured spectrum so both can be seen in the same plot
        cla;
        plot(wanted_spectrum/max(wanted_spectrum),'color',[1 0 0]);
        
        axis([400 1000 0 max(wanted_spectrum)*1.2])
        
    end
    
    if success
        plot(measured_spectrum/max(measured_spectrum));
        xlabel('Wavelength [nm]')
        ylabel('Power [Arbitrary]')
        axis([400 1000 0 1.2])
        
        setappdata(handles.figure1, 'clickState', 0);
        setappdata(handles.figure1, 'measured_spectrum', measured_spectrum);
    end
    
    if debug
        disp(['clickState: ' num2str(getappdata(handles.figure1, 'clickState'))]);
    end
    guidata(handles.figure1, handles);
catch err
    uiwait(errordlg(err.message));
    rethrow(err);
end


%% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
try
    % hObject    handle to axes1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    handles = guidata(handles.figure1);
    debug = getappdata(handles.figure1, 'debug_mode');
    clickState = getappdata(handles.figure1, 'clickState');
    if debug
        disp('in axes1_buttonDownFcn');
        disp('clickState: ');
        disp(clickState);
    end
    if (clickState == 0)
        setappdata(handles.figure1, 'clickState', 1);
        guidata(handles.figure1, handles);
        manualAdjustment(handles);
        measured_spectrum = getappdata(handles.figure1,'measured_spectrum');
        wanted_spectrum = getappdata(handles.figure1,'wanted_spectrum');
        plot(wanted_spectrum/max(wanted_spectrum),'color',[1 0 0]);
        plot(measured_spectrum/max(measured_spectrum), 'HitTest','off')
        xlabel('Våglängd [nm]')
        ylabel('Effekt [Arbitrary]')
        axis([400 1000 0 1.2])
    end
catch err
    uiwait(errordlg(err.message));
    rethrow(err);
end



%% --- Executes on button press in Automatic_Calibration.
function Automatic_Calibration_Callback(hObject, eventdata, handles)
try
    % hObject    handle to Automatic_Calibration (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    handles = guidata(handles.figure1);
    debug = getappdata(handles.figure1, 'debug_mode');
    if debug
        disp('in Automatic_Calibration_Callback');
    end
    
    % How close to the correct intensity do we want to go before we
    % consider ourselves done. Slack = 0.05 means that a 5% deviation from
    % the correct intensity within a given 100 nm interval is ok.
    slack = 0.05;
    tight = false;
    i = 0;
    allowed_iterations = 4;
    success = true;
    while tight == false && i < allowed_iterations && success
        i = i + 1;
        if debug
            disp(['Auto_Calibrate is about to begin its : ' num2str(i) ' iteration']);
        end
        [tight, new_daq_voltage, success] = Auto_Calibrate(handles, slack);
    end
    shutdown_simulator(handles);
    
catch err
    shutdown_simulator(handles);
    uiwait(errordlg(strcat(err.identifier, ': ', err.message)));
    rethrow(err);
end

% Hint: get(hObject,'Value') returns toggle state of Automatic_Calibration


%% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    % Hint: delete(hObject) closes the figure
    shutdown_simulator(handles);
    
    debug = getappdata(handles.figure1, 'debug_mode');
    if debug
        disp('CloseRequest')
    end
    
    delete(hObject);
catch err
    
    disp(errordlg(err.message));
    
end



%% --- Executes during object deletion, before destroying properties.
function axes1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    delete(hObject);
    
catch err
    if strcmp (err.identifier, 'MATLAB:ginput:FigureDeletionPause')
        if debug
            disp('MATLAB:ginput:Interrupted')
        end
    else
        rethrow(err);
    end
end



%% --- Executes on button press in Choose_spectrum.
function Choose_spectrum_Callback(hObject, eventdata, handles)
% hObject    handle to Choose_spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.figure1);
try
    debug = getappdata(handles.figure1, 'debug_mode');
    
    if debug
        disp('A new spectrum has been chosen, checking if proper');
    end
    
    FileName = uigetfile('SparadeSpektrum/*.spec','Välj fil att ladda spektrumet ifrån');
    spectrum = ImportRawSpectrum(FileName);
    
    setappdata(handles.figure1, 'wanted_spectrum', spectrum);
    
    if debug
        disp(size(spectrum));
    end
    
catch err
    shutdown_simulator(handles);
    uiwait(errordlg(strcat(err.identifier, ': ', err.message)));
    rethrow(err);
end
guidata(handles.figure1, handles);




%% --- Executes on button press in Save_button.
function Save_button_Callback(hObject, eventdata, handles)
% hObject    handle to Save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.figure1);
try
    debug = getappdata(handles.figure1, 'debug_mode');
    
    if debug
        disp('Save_button_Callback: Saving spectrum');
    end
    savespectrum = getappdata(handles.figure1, 'chosen_spectrum');
    %     [savespectrum, path] = uiputfile('*.mat','Save Spectrum As');
    
    
    uisave('savespectrum','')
    
catch err
    shutdown_simulator(handles);
    uiwait(errordlg(strcat(err.identifier, ': ', err.message)));
    rethrow(err);
end



% --- Executes on button press in Open_Spectrum.
function Open_Spectrum_Callback(hObject, eventdata, handles)
% hObject    handle to Open_Spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    debug = getappdata(handles.figure1, 'debug_mode');
    
    if debug
        disp('Open_Spectrum_Callback: Opening spectrum');
    end

    fileToRead1 = uigetfile('*.mat','Choose Spectrum');
%     spectrum = load(Filename,'savespectrum');
    
    %IMPORTFILE(FILETOREAD1)
%  Imports data from the specified file
%  FILETOREAD1:  file to read

%  Auto-generated by MATLAB on 11-Nov-2014 18:35:54

% Import the file
newData1 = load('-mat', fileToRead1);

% Create new variables in the base workspace from those fields.
vars = fieldnames(newData1);
for i = 1:length(vars)
    assignin('base', vars{i}, newData1.(vars{i}));
    disp('vars{i})')
    vars{i}
end
    
    fieldnames(newData1)
    newData1
    savespectrum
    
    
%     setappdata(handles.figure1,'chosen_spectrum',spectrum);

    if debug
        
        
    end
    
catch err
    shutdown_simulator(handles);
    uiwait(errordlg(strcat(err.identifier, ': ', err.message)));
    rethrow(err);
end
