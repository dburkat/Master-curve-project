function varargout = exportPopup(varargin)
% EXPORTPOPUP MATLAB code for exportPopup.fig
%      EXPORTPOPUP, by itself, creates a new EXPORTPOPUP or raises the existing
%      singleton*.
%
%      H = EXPORTPOPUP returns the handle to a new EXPORTPOPUP or the handle to
%      the existing singleton*.
%
%      EXPORTPOPUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPORTPOPUP.M with the given input arguments.
%
%      EXPORTPOPUP('Property','Value',...) creates a new EXPORTPOPUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before exportPopup_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to exportPopup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help exportPopup

% Last Modified by GUIDE v2.5 11-Aug-2014 16:06:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @exportPopup_OpeningFcn, ...
                   'gui_OutputFcn',  @exportPopup_OutputFcn, ...
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


% --- Executes just before exportPopup is made visible.
function exportPopup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to exportPopup (see VARARGIN)

% Choose default command line output for exportPopup
handles.output = hObject;
handles.exportState = 0;
handles.exportOptions = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes exportPopup wait for user response (see UIRESUME)
uiwait(handles.ExportPopup);


% --- Outputs from this function are returned to the command line.
function varargout = exportPopup_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = get(handles.filename_edit, 'String');
varargout{2} = handles.exportOptions;
varargout{3} = handles.exportState;
delete(handles.ExportPopup);



function filename_edit_Callback(hObject, eventdata, handles)
% hObject    handle to filename_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename_edit as text
%        str2double(get(hObject,'String')) returns contents of filename_edit as a double


% --- Executes during object creation, after setting all properties.
function filename_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CancelPB.
function CancelPB_Callback(hObject, eventdata, handles)
% hObject    handle to CancelPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.exportState = 0;
guidata(handles.ExportPopup, handles);
close(handles.ExportPopup);


% --- Executes on button press in ExportPB.
function ExportPB_Callback(hObject, eventdata, handles)
% hObject    handle to ExportPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.exportState = 1;
radioButton = get(handles.exportType, 'SelectedObject');
type = get(radioButton,'Tag');
handles.exportOptions = type;

guidata(handles.ExportPopup, handles);
close(handles.ExportPopup);


% --- Executes when user attempts to close ExportPopup.
function ExportPopup_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to ExportPopup (see GCBO)
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
