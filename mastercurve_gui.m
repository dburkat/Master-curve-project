function varargout = mastercurve_gui(varargin)
%MASTERCURVE_GUI M-file_menu for mastercurve_gui.fig
%      MASTERCURVE_GUI, by itself, creates a new MASTERCURVE_GUI or raises the existing
%      singleton*.
%
%      H = MASTERCURVE_GUI returns the handle to a new MASTERCURVE_GUI or the handle to
%      the existing singleton*.
%
%      MASTERCURVE_GUI('Property','Value',...) creates a new MASTERCURVE_GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to mastercurve_gui_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      MASTERCURVE_GUI('CALLBACK') and MASTERCURVE_GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in MASTERCURVE_GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mastercurve_gui

% Last Modified by GUIDE v2.5 13-Dec-2014 22:08:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mastercurve_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @mastercurve_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before mastercurve_gui is made visible.
function mastercurve_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)


handles.dataStruct = struct('info',{}, 'header', {}, 'xraw', {}, 'yraw', {}, 'xShifted', {}, 'yShifted',{}, 'modelStruct',{}, 'checkMatrix', {}, 'MasterCurve', {});


%Set up the text info on screen
set(handles.AllDataList,'Value',1);
set(handles.AllDataList,'String', 'Empty');
handles.currentlySelected = [];
set(handles.CurrentDataList, 'Value', 1);
set(handles.CurrentDataList, 'String', 'Empty');
set(handles.currentOpenFile,'String', 'NONE');

%clear the axis
cla reset;

% Choose default command line output for mastercurve_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mastercurve_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mastercurve_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in AllDataList.
function AllDataList_Callback(hObject, eventdata, handles)
% hObject    handle to AllDataList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AllDataList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AllDataList


% --- Executes during object creation, after setting all properties.
function AllDataList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AllDataList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in CurrentDataList.
function CurrentDataList_Callback(hObject, eventdata, handles)
% hObject    handle to CurrentDataList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CurrentDataList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CurrentDataList


% --- Executes during object creation, after setting all properties.
function CurrentDataList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CurrentDataList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RawPB.
function RawPB_Callback(hObject, eventdata, handles)
% hObject    handle to RawPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(handles.CurrentDataList,'String');
radioButton = get(handles.buttonGroup,'SelectedObject');
type = get(radioButton,'Tag');
if ~strcmp(str, 'Empty')
    RawPlot(handles.dataStruct, handles.currentlySelected, type);
end


% --- Executes on button press in ShiftedMCPB.
function ShiftedMCPB_Callback(hObject, eventdata, handles)
% hObject    handle to ShiftedMCPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(handles.CurrentDataList,'String');
radioButton = get(handles.buttonGroup,'SelectedObject');
type = get(radioButton,'Tag');
if ~strcmp(str, 'Empty')
    ShiftMCPlot(handles.dataStruct, handles.currentlySelected, type);
end

% --- Executes on button press in MasterCurvePB.
function MasterCurvePB_Callback(hObject, eventdata, handles)
% hObject    handle to MasterCurvePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(handles.CurrentDataList,'String');
radioButton = get(handles.buttonGroup,'SelectedObject');
type = get(radioButton,'Tag');
if ~strcmp(str, 'Empty')
    MCPlot(handles.dataStruct, handles.currentlySelected, type);
end

% --- Executes on button press in ArrheniusPB.
function ArrheniusPB_Callback(hObject, eventdata, handles)
% hObject    handle to ArrheniusPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(handles.CurrentDataList, 'String');
radioButton = get(handles.buttonGroup, 'SelectedObject');
type = get(radioButton, 'Tag');
if ~strcmp(str, 'Empty')
    ArrheniusPlot(handles.dataStruct, handles.currentlySelected, type);
end


% --- Executes on button press in AddPB.
function AddPB_Callback(hObject, eventdata, handles)
% hObject    handle to AddPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = get(handles.AllDataList,'Value');
if ~(any(index == handles.currentlySelected))
    handles.currentlySelected = [handles.currentlySelected, index];
    handles.currentlySelected = sort(handles.currentlySelected);
    names = {};
    j = 1;
    if length(handles.dataStruct) > 0
        for k = 1:length(handles.dataStruct)
            if any(k == handles.currentlySelected)
                info = handles.dataStruct(k).info;
                names{j} = info{1};
                j = j + 1;
            end
        end
    end
    set(handles.CurrentDataList,'String', {names{:}});
    
    % Update handles structure
    guidata(hObject, handles);
end

% --- Executes on button press in RemovePB.
function RemovePB_Callback(hObject, eventdata, handles)
% hObject    handle to RemovePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = get(handles.CurrentDataList, 'Value');
str = get(handles.CurrentDataList, 'String');
if ~strcmp(str, 'Empty')
    handles.currentlySelected(index) = [];
    names = {};
    j = 1;
    if length(handles.dataStruct) > 0
        for k = 1:length(handles.dataStruct)
            if any(k == handles.currentlySelected)
                info = handles.dataStruct(k).info;
                names{j} = info{1};
                j = j + 1;
            end
        end
    end
    if isempty(handles.currentlySelected)
        names = {'Empty'};
    end
    set(handles.CurrentDataList, 'Value', 1);
    set(handles.CurrentDataList,'String', {names{:}});
    
    % Update handles structure
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function import_menu_Callback(hObject, eventdata, handles)
% hObject    handle to import_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[status, data, colheaders] = importRawData_1_0(handles.dataStruct)

%Importing data popup to select a series name an select the reference
%temperature.
%Also the popup will display a status that signals if ok or if there is any
%problem with the data.
%When the analyze button is pressed proceed to MasterCurve, if canceled is
%pressed remove the data series from the base workspace and return to the
%same state as before importRawData was attempted.
if ~isempty(status)
    [f, state, reft, name] = ImportPopup(status, colheaders);
    
    if state == 1
        nextDataStruct = MasterCurve_1_0(data, colheaders, reft, name);
        
        %Add the new set of MasterCurve data to the handle.dataStruct
        b = size(handles.dataStruct);
        handles.dataStruct(b(1,2) + 1) = nextDataStruct;
        
        
        %Import the data from the base workspace
        %     handles.dataStruct = evalin('base', 's');
        
        
        names = {};
        if length(handles.dataStruct) > 0
            for k = 1:length(handles.dataStruct)
                info = handles.dataStruct(k).info;
                names{k} = info{1};
            end
        end
        set(handles.AllDataList, 'Value',1);
        set(handles.AllDataList,'String', {names{:}});
        
        % Update handles structure
        guidata(hObject, handles);
    end
end


% --------------------------------------------------------------------
function export_menu_Callback(hObject, eventdata, handles)
% hObject    handle to export_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%export the data in CurrentDataList
[filename, exportOption, state] = exportPopup;

%If the export pushbutton was pressed then do the export.
if state == 1 
    filePath = pwd;
    %saves the file to the folder named MasterCurveProject/ExportData
    targetFile = strcat(filePath,filesep,'ExportData',filesep, filename,'.xlsx');
    matFile = get(handles.currentOpenFile, 'String');
    writeToExcelFast(targetFile,exportOption,handles.dataStruct, matFile);
end


% --------------------------------------------------------------------
function open_menu_Callback(hObject, eventdata, handles)
% hObject    handle to open_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName,filePath,fileIndex] = uigetfile('*.mat');
if fileName ~= 0
    %load the targeFile from disk
    %NOTE: look up S = load(__) for more info why I do it this way.
    targetFile = strcat(filePath,filesep, fileName);
    Snew = load(targetFile); 
    
    
    if isfield(Snew, 's')
        set(handles.currentOpenFile, 'String', fileName);
        handles.dataStruct = Snew.s;
        clear Snew;
        
        %update the AllDataList in the gui
        names = {};
        if length(handles.dataStruct) > 0
            for k = 1:length(handles.dataStruct)
                info = handles.dataStruct(k).info;
                names{k} = info{1};
            end
            set(handles.AllDataList,'String', {names{:}});
        else
            set(handles.AllDataList,'String', 'Empty');
        end
        
        %update the CurrentlySelected to be empty
        handles.currentlySelected = [];
        set(handles.CurrentDataList, 'Value', 1);
        set(handles.CurrentDataList, 'String', 'Empty');
        
        % Update handles structure
        guidata(hObject, handles);
    end
end


% --------------------------------------------------------------------
function save_menu_Callback(hObject, eventdata, handles)
% hObject    handle to save_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, filepath] = uiputfile('*.mat');
if filename ~= 0
    targetFile = strcat(filepath, filesep, filename);
    s = handles.dataStruct;
    save(targetFile, 's');
    set(handles.currentOpenFile, 'String', filename);
    guidata(hObject, handles);
    
end

% --------------------------------------------------------------------
function edit_menu_Callback(hObject, eventdata, handles)
% hObject    handle to edit_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function manage_menu_Callback(hObject, eventdata, handles)
% hObject    handle to manage_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function buttonGroup_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to buttonGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
