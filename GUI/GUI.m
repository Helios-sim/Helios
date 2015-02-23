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
    
    measured_spectrum = getSpectrum(handles);
    
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
    spectCon = getappdata(handles.figure1,'spectCon');
    if spectCon
        plot(measured_spectrum/max(measured_spectrum));
        xlabel('Wavelength [nm]')
        ylabel('Power [not to scale]')
        axis([400 1000 0 1.2])
        setappdata(handles.figure1, 'measured_spectrum', measured_spectrum);
    end
        setappdata(handles.figure1, 'clickState', 0);
    
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
        ylabel('Effekt [not to scale]')
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

% Loads the reference spectrum
handles = guidata(handles.figure1);
try
    debug = getappdata(handles.figure1, 'debug_mode');
    
    if debug
        disp('A new reference spectrum has been chosen, checking if proper');
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

% Saves the 16 voltage values (user spectrum)
handles = guidata(handles.figure1);
try
    debug = getappdata(handles.figure1, 'debug_mode');
    savespectrum = getappdata(handles.figure1, 'chosen_spectrum');
    
    if debug
        disp('Save_button_Callback: Saving spectrum')
        disp(savespectrum)
    end
        
    uisave('savespectrum','SparadeSpektrum/')
    
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

% Loads the 16 voltage values
try
    debug = getappdata(handles.figure1, 'debug_mode');
    savespectrum = uiopen('SparadeSpektrum/*.mat');
    
    if debug
        disp('Open_Spectrum_Callback: Opening spectrum');
        disp(savespectrum)
    end
    setappdata(handles.figure1,'chosen_spectrum',savespectrum);
    
catch err
    shutdown_simulator(handles);
    uiwait(errordlg(strcat(err.identifier, ': ', err.message)));
    rethrow(err);
end
