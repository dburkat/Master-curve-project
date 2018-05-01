function varargout = ImportPopup(varargin)
%IMPORTPOPUP M-file for ImportPopup.fig
%      IMPORTPOPUP, by itself, creates a new IMPORTPOPUP or raises the existing
%      singleton*.
%
%      H = IMPORTPOPUP returns the handle to a new IMPORTPOPUP or the handle to
%      the existing singleton*.
%
%      IMPORTPOPUP('Property','Value',...) creates a new IMPORTPOPUP using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to ImportPopup_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      IMPORTPOPUP('CALLBACK') and IMPORTPOPUP('CALLBACK',hObject,...) call the
%      local function named CALLBACK in IMPORTPOPUP.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImportPopup

% Last Modified by GUIDE v2.5 25-Jun-2014 13:50:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImportPopup_OpeningFcn, ...
                   'gui_OutputFcn',  @ImportPopup_OutputFcn, ...
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


% --- Executes just before ImportPopup is made visible.
function ImportPopup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

%Bring in the Pop-up Menu data to the handle structure from varargin
%Print the status of the import to the StatusList
status = varargin{1};
colhead = varargin{2};
set(handles.StatusList, 'str',{status{:}});
set(handles.RefTempPopUp, 'String', {colhead{1:length(colhead)-1}});
handles.analyzeState = 0;

% Choose default command line output for ImportPopup
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImportPopup wait for user response (see UIRESUME)
uiwait(handles.ImportPopup);


% --- Outputs from this function are returned to the command line.
function varargout = ImportPopup_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.analyzeState;
varargout{3} = get(handles.RefTempPopUp,'Value');
varargout{4} = get(handles.rheometerDataEdit, 'String');
delete(hObject);


% --- Executes on key press with focus on ImportPopup and none of its controls.
function ImportPopup_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to ImportPopup (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close ImportPopup.
function ImportPopup_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to ImportPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on button press in AnalyzePB.
function AnalyzePB_Callback(hObject, eventdata, handles)
% hObject    handle to AnalyzePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.analyzeState = 1;
guidata(handles.ImportPopup, handles);
close(handles.ImportPopup);


% --- Executes on button press in CancelPB.
function CancelPB_Callback(hObject, eventdata, handles)
% hObject    handle to CancelPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.analyzeState = 0;
guidata(handles.ImportPopup, handles);
close(handles.ImportPopup);



function rheometerDataEdit_Callback(hObject, eventdata, handles)
% hObject    handle to rheometerDataEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rheometerDataEdit as text
%        str2double(get(hObject,'String')) returns contents of rheometerDataEdit as a double
%handles.dataName = get(hObject, 'String');
%guidata(handles.ImportPopup, handles);



% --- Executes during object creation, after setting all properties.
function rheometerDataEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rheometerDataEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in RefTempPopUp.
function RefTempPopUp_Callback(hObject, eventdata, handles)
% hObject    handle to RefTempPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns RefTempPopUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RefTempPopUp




% --- Executes during object creation, after setting all properties.
function RefTempPopUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RefTempPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in StatusList.
function StatusList_Callback(hObject, eventdata, handles)
% hObject    handle to StatusList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns StatusList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from StatusList


% --- Executes during object creation, after setting all properties.
function StatusList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StatusList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
