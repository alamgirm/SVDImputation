function varargout = SVD_Imp_GUI(varargin)
% SVD_IMP_GUI MATLAB code for SVD_Imp_GUI.fig
%      SVD_IMP_GUI, by itself, creates a new SVD_IMP_GUI or raises the existing
%      singleton*.
%
%      H = SVD_IMP_GUI returns the handle to a new SVD_IMP_GUI or the handle to
%      the existing singleton*.
%
%      SVD_IMP_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SVD_IMP_GUI.M with the given input arguments.
%
%      SVD_IMP_GUI('Property','Value',...) creates a new SVD_IMP_GUI or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SVD_Imp_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SVD_Imp_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SVD_Imp_GUI

% Last Modified by GUIDE v2.5 25-Aug-2015 03:18:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SVD_Imp_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SVD_Imp_GUI_OutputFcn, ...
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

% --- Executes just before SVD_Imp_GUI is made visible.
function SVD_Imp_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SVD_Imp_GUI (see VARARGIN)

%initialize user vars
handles = init_user_vars(handles, 1);

% Choose default command line output for SVD_Imp_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% update the GUI
update_gui(hObject, handles);

% UIWAIT makes SVD_Imp_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SVD_Imp_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function oh = init_user_vars(handles,  dirty)

oh = handles;
%user variables 
oh.srcFileName = '';
oh.dstFileName = '';
oh.numInstances = 0;
oh.numNFeatures  = 0; % number of numerical features
oh.numCFeatures = 0;  % number of categorical feaures
oh.catgData     = ''; %Yes or No
oh.missingData  = ''; %Yes or No
oh.missingRate  = 0;  % 
oh.missingPattern = '';  %Random, canonical, univariate


oh.inCatData = {}; % cat data part
oh.inNumData  = []; %numerical data part
% inNumData and inTextData are combined into inData
oh.inData = [];  %numeric values only (cat data are coded)
oh.numCols    = []; %which col of inData were originally numeric
oh.catCols    = []; %which col of inData were originally category data

oh.inAllData = {}; %all data both numerica and cat, raw format

%these two tables hold the cat <-> numeric mapping info
oh.mapTable = containers.Map('NaN',0);
oh.mapITable= containers.Map(0,'NaN');

oh.inDataValid = false;

%SVD imputation related
oh.numSV = 1;
oh.lvlEnergy = 90; % 90 energy level
oh.numOptSV = 0;
oh.numIter = 1;
oh.impData = []; %numeric data, imputed values
oh.impAllData = {}; %numeric and cat data
oh.dDiscrete = true;
oh.impDone = 0;

%error calculation related
if dirty
    oh.gndTruthFileName = '';
    oh.gndData = []; %ground truth data (all numeric)
    oh.gndAllData = {}; %numeric and category data
    oh.gndDataValid = 0;
end;    
    oh.nrms = 0.0;
    oh.ae = 0.0;


% --------------------------------------------------------------------
function update_gui(fig_handle, handles)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
% if isfield(handles, 'metricdata') && ~isreset
%     return;
% end

%Input Data block
set(handles.edtSrcFileName, 'String', handles.srcFileName);
set(handles.txtNumInstances,'String', handles.numInstances);

set(handles.txtCatgData,    'String', handles.catgData); %Yes or No
set(handles.txtMissingData, 'String', handles.missingData);
set(handles.txtMissingRate, 'String', [handles.missingRate,'%']);
set(handles.txtMissingPattern, 'String', handles.missingPattern);

if strcmpi(handles.catgData, 'Yes')
    set(handles.btnDiscretize, 'Enable', 'on');
   % set(handles.txtNumFeatures, 'String', sprintf('%d%/%d',handles.numNFeatures,handles.numCFeatures));
else
    set(handles.btnDiscretize, 'Enable', 'off');
end
 set(handles.txtNumFeatures, 'String', [num2str(handles.numNFeatures),'+',num2str(handles.numCFeatures)]);

% SVD Imputation block
if handles.inDataValid 
    set(handles.edtNumSV, 'String', handles.numSV);
    set(handles.edtNumIter, 'String', handles.numIter);
    set(handles.btnDoImputation, 'Enable', 'on');
    set(handles.btnSaveImpData, 'Enable', 'on');
else
    set(handles.edtNumSV, 'String', 0);
    set(handles.edtNumIter, 'String', 0);
    set(handles.btnDoImputation, 'Enable', 'off');
    set(handles.btnSaveImpData, 'Enable', 'off');
end;

if handles.impDone
    set(handles.btnDoImputation, 'Enable', 'off');
    set(handles.btnSaveImpData, 'Enable', 'on');
    set(handles.btnCalError, 'Enable', 'on');
else
    set(handles.btnDoImputation, 'Enable', 'on');
    set(handles.btnSaveImpData, 'Enable', 'off');
    set(handles.btnCalError, 'Enable', 'off');
end;

% if(handles.dDiscrete)
%     set(handles.btnSaveImpData
%Error cal block
if handles.inDataValid 
    set(handles.chkDeDiscretize, 'Enable', 'on');
    set(handles.btnCalError, 'Enable', 'on');
    if isempty(handles.catCols) == 0 %cat data existed
        set(handles.chkDeDiscretize, 'Value', 1);
    else %uncheck+disable the checkbox, if cat data didnt exist
        set(handles.chkDeDiscretize, 'Value', 0);
        set(handles.chkDeDiscretize, 'Enable', 'off');
    end;
else
    set(handles.chkDeDiscretize, 'Enable', 'off');
    set(handles.btnCalError, 'Enable', 'off');
end;
set(handles.edtGroundTruthFileName, 'String', handles.gndTruthFileName);
set(handles.txtNRMS, 'String', sprintf('%0.4f',handles.nrms));
if isempty(handles.catCols)
    set(handles.txtAE, 'String', 'n/a');
else
    set(handles.txtAE, 'String', sprintf('%0.4f', handles.ae));
end;

function edtSrcFileName_Callback(hObject, eventdata, handles)
% hObject    handle to edtSrcFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtSrcFileName as text
%        str2double(get(hObject,'String')) returns contents of edtSrcFileName as a double


% --- Executes during object creation, after setting all properties.
function edtSrcFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtSrcFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnBrowse.
function btnBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to btnBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName] = uigetfile( ... 
{'*.csv;*.xls;*.xlsx','Data Files (*.csv,*.xls,*.xlsx)';
  % '*.csv',  'Comma separated values files (*.csv)'; ...
   '*.xls','Excel file (*.xls)'; ...
   '*.xlsx','Excel 2010 file (*.xls)'; ...
   '*.*',  'All Files (*.*)'}, ...
   'Select a data file');

if FileName ~= 0
    handles = init_user_vars(handles, 0);
    handles.srcFileName = [PathName,FileName];
end;
% Update handles structure
guidata(hObject, handles);
update_gui(hObject, handles);

% --- Executes on button press in btnReadData.
function btnReadData_Callback(hObject, eventdata, handles)
% hObject    handle to btnReadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%read data
%look at the extension of the file name
%only csv and xls/xlsx file are supported
ext = handles.srcFileName(strfind(handles.srcFileName,'.')+1:end);
inDataValid = false;

if isempty(handles.srcFileName)
    return;
end;

if(strcmpi(ext,'csv')==1)
    % csv file
%     inData = csvread(handles.srcFileName);
%     inDataValid = true;
%     inTextData = {};
%     inAllData = {};
    msgbox('CSV is not supported yet.','Warning','warning');
elseif strcmpi(ext,'xls') == 1 ||  strcmpi(ext,'xlsx') == 1
    %xls file
    wh = waitbar(0.0, 'Reading data ... Please wait');
    [inData, inTextData, inAllData] = xlsread(handles.srcFileName);
    close(wh);
    if isempty(inAllData)
        msgbox('Data file empty or unknown format.','Error','error');
    end;
    [handles.inNumData, handles.numCols, handles.inCatData, handles.catCols] = pre_process_data(inAllData);

    %copy the numerical data to inData
    %cat data will be copied by the discretizer
    for j=1:length(handles.numCols)
        handles.inData(:, handles.numCols(j)) = handles.inNumData(:,j);
    end;

    if isempty(handles.catCols)
        inDataValid = true;
    end;
else
            msgbox('Unsupported file format','Error','error');
end
 
  handles.inDataValid = inDataValid;  
  handles.inAllData = inAllData;
  handles = analyze_data(handles);  %call the analyze function
  
  if inDataValid == true
    handles.numSV =  min([handles.numOptSV,handles.numInstances]); %choose a better guess
  end;  


guidata(hObject, handles);
update_gui(hObject, handles);

            
% --- Executes on button press in btnDiscretize.
function btnDiscretize_Callback(hObject, eventdata, handles)
% hObject    handle to btnDiscretize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = discretize(handles);
handles = analyze_data(handles);
if handles.inDataValid == 1
    handles.numSV = min([handles.numOptSV,handles.numInstances]); %choose a better guess
end; 

guidata(hObject, handles);
update_gui(hObject, handles);


% --- Executes on button press in btnSaveData.
function btnSaveData_Callback(hObject, eventdata, handles)
% hObject    handle to btnSaveData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uiputfile( ... 
{'*.csv','Data Files (*.csv)';
   '*.csv',  'Comma separated values files (*.csv)'; ...
   '*.*',  'All Files (*.*)'}, ...
   'Select a name to save');

if FileName ~= 0
    wh = waitbar(0.0, 'Saving data ... Please wait.');
    csvwrite([PathName,FileName], handles.inData);
    close(wh);
end;


function edtNumSV_Callback(hObject, eventdata, handles)
% hObject    handle to edtNumSV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtNumSV as text
%        str2double(get(hObject,'String')) returns contents of edtNumSV as a double
handles.numSV = get(hObject,'String');
handles.impDone = 0;
guidata(hObject, handles);
update_gui(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edtNumSV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtNumSV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edtNumIter_Callback(hObject, eventdata, handles)
% hObject    handle to edtNumIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtNumIter as text
%        str2double(get(hObject,'String')) returns contents of edtNumIter as a double
handles.numIter = get(hObject,'String');
handles.impDone = 0;
guidata(hObject, handles);
update_gui(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edtNumIter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtNumIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnDoImputation.
function btnDoImputation_Callback(hObject, eventdata, handles)
% hObject    handle to btnDoImputation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.impDone
    return;
end;

nSV = str2double(get(handles.edtNumSV,'String'));
nIt = str2double(get(handles.edtNumIter,'String'));

if nSV > size(handles.inData, 2) || nIt > 100
    msgbox('Too many SV or iterations given', 'Error', 'error');
else 
   wh = waitbar(0.0, 'Imputing missing data ... Please wait.');
    handles.impData = ImputeBySVD(handles.inData, nSV, nIt );
    close(wh);
    handles.impDone = 1;
end;    

%see if de-discretization is checked
if handles.dDiscrete
    handles.impAllData = de_discretize(handles);
end;

guidata(hObject, handles);
update_gui(hObject, handles);

% --- Executes on button press in chkDeDiscretize.
function chkDeDiscretize_Callback(hObject, eventdata, handles)
% hObject    handle to chkDeDiscretize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkDeDiscretize
handles.dDiscrete = get(hObject,'Value');
guidata(hObject, handles);

% --- Executes on button press in btnSaveImpData.
function btnSaveImpData_Callback(hObject, eventdata, handles)
% hObject    handle to btnSaveImpData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.impDone == 0
    msgbox('Impute the data first.', 'Error', 'error');
    return;
end;

[FileName,PathName] = uiputfile( ... 
{  '*.csv',  'Comma separated value files (*.csv)'; ...
   '*.*',  'All Files (*.*)'}, ...
   'Select a name to save');

if FileName ~= 0
   save_csv([PathName,FileName], handles.impAllData);
end;
% Update handles structure
guidata(hObject, handles);
update_gui(hObject, handles);

function edtGroundTruthFileName_Callback(hObject, eventdata, handles)
% hObject    handle to edtGroundTruthFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtGroundTruthFileName as text
%        str2double(get(hObject,'String')) returns contents of edtGroundTruthFileName as a double


% --- Executes during object creation, after setting all properties.
function edtGroundTruthFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtGroundTruthFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnBrowseGrndTruth.
function btnBrowseGrndTruth_Callback(hObject, eventdata, handles)
% hObject    handle to btnBrowseGrndTruth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile( ... 
{'*.csv;*.xls;*.xlsx','Data Files (*.csv,*.xls,*.xlsx)';
   '*.xls','Excel file (*.xls)'; ...
   '*.xlsx','Excel 2010 file (*.xls)'; ...
   '*.*',  'All Files (*.*)'}, ...
   'Select a data file');

if FileName ~= 0
    handles.gndTruthFileName = [PathName,FileName];
    handles.gndDataValid = 0;
end;
% Update handles structure
guidata(hObject, handles);
update_gui(hObject, handles);


% --- Executes on button press in btnCalError.
function btnCalError_Callback(hObject, eventdata, handles)
% hObject    handle to btnCalError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%1. load the ground truth data
%2. discretize if there is any category data using the same map table
%3. calculate NRMS

if handles.impDone == 0
    msgbox('Impute the data first.', 'Error', 'error');
    return;
end;

ext = handles.gndTruthFileName(strfind(handles.gndTruthFileName,'.')+1:end);

if handles.gndDataValid == false %only load the data when needed
    wh = waitbar(0.0, 'Processing ground truth data ... Please wait.');
    if strcmpi(ext,'xls') == 1 ||  strcmpi(ext,'xlsx') == 1
    %xls file
    [gndNumData, gndCatData, gndAllData ] = xlsread(handles.gndTruthFileName);
    else
            msgbox('File empty or unsupported file format','Error','error');
            return;
    end

    if isempty(gndAllData)
            msgbox('File reading error.', 'Error', 'error');
            return;
    end;

    handles.gndData = zeros(size(gndAllData)); %initialize
    
    for i=1:size(gndAllData, 1) % for each row
        waitbar(i/size(gndAllData, 1), wh);
    
        for j=1:size(gndAllData, 2);
            aVal = cell2mat(gndAllData(i, j));
            if isnumeric(aVal)
                 if isnan(aVal)
                     handles.gndData(i,j) = 0; %set NaN to zero
                 else
                     handles.gndData(i,j) = aVal;
                 end;
            else % cat data
                aVal = strtrim(aVal);
                gndAllData(i, j) = {aVal}; %remove leading/lagging space
                 if isKey(handles.mapTable, {aVal}) == 0 %key doesnt exist, ignore
                    handles.gndData(i,j) = 0;
                 else %key exists, take the code
                    handles.gndData(i,j) = handles.mapTable(aVal);
                 end;
            end;
        end; %for j
     end; %for i
    close(wh);
    %copy the raw array
    handles.gndAllData = gndAllData;
    %set the validity flag
    handles.gndDataValid = true;
end; %if gndDataValid 

%NRMS of entire data array
%handles.nrms = CalNRMS(handles.impData, handles.gndData);
%NRMS of just he numeric part
handles.nrms = CalNRMS(handles.impData(:,handles.numCols), handles.gndData(:, handles.numCols));
%AE works on cat part, cell array
if isempty(handles.catCols)
    handles.ae = '0';
else
    handles.ae   = CalAE(handles.impAllData(:,handles.catCols), handles.gndAllData(:,handles.catCols));
end;

guidata(hObject, handles);
update_gui(hObject, handles);


% --- Executes on selection change in mnuEnergyLvl.
function mnuEnergyLvl_Callback(hObject, eventdata, handles)
% hObject    handle to mnuEnergyLvl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mnuEnergyLvl contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnuEnergyLvl
contents = cellstr(get(hObject,'String'));
handles.lvlEnergy = contents{get(hObject,'Value')};
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function mnuEnergyLvl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuEnergyLvl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
