function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 04-Sep-2018 13:47:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
global jk
global A
A=cell(3);
jk=2;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I 
[path, user_cancel] = imgetfile();
if user_cancel
    msgbox(sprintf('Invalid Selection'),'Error','Warn');
    return
end
I = imread(path);
axes(handles.axes1);
imshow(I)
title('\fontsize{18}\color[rgb]{0.635 0.078 0.184} Classroom Photo')


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I

FDetect = vision.CascadeObjectDetector;
FDetect.MergeThreshold = 15;
axes(handles.axes2)
BB = step(FDetect,I);
global k;
k=1;
imshow(I)
title('\fontsize{18}\color[rgb]{0.635 0.078 0.184} Faces Detected')
hold on
for i = 1:size(BB,1) % draw rectanlge in row wise
    rectangle('Position',BB(i,:),'LineWidth',2,'LineStyle','-','EdgeColor','g');
    %start from first row then second and ....
   
end
% title('Face Detection');

  
  faceDatabase = imageSet('FaceDatabaseATT','recursive');

%% Display Montage of First Face



%% Split Database into Training & Test Sets
[training,test] = partition(faceDatabase,[0.5 0.5]);


%% Extract and display Histogram of Oriented Gradient Features for single face 

%% Extract HOG Features for training set 
trainingFeatures = zeros(size(training,2)*training(1).Count,4680);
featureCount = 1;
for i=1:size(training,2)
    for j = 1:training(i).Count
        trainingFeatures(featureCount,:) = extractHOGFeatures(read(training(i),j));
        trainingLabel{featureCount} = training(i).Description;    
        featureCount = featureCount + 1;
    end
    personIndex{i} = training(i).Description;
    
end

%% Create 40 class classifier using fitcecoc 
faceClassifier = fitcecoc(trainingFeatures,trainingLabel);


%% Test Images from Test Set 
global A
global jk;
st='RollNumber';
p=char(st);
A{1,2}=p;
st='No.';
p=char(st);
A{1,1}=p;
c=datetime('today');
p=char(c);
A{1,3}=p;

index=0;
hold off
for i= 1:size(BB,1)
    index=0;
    J= imcrop(I,BB(i,:));
    a = imresize(J,[112 92]);
 a = rgb2gray(a);
queryImage =a;
queryFeatures = extractHOGFeatures(queryImage);
personLabel = predict(faceClassifier,queryFeatures);
d = char(personLabel);

for kj = 1:jk-1
    if isequal(A{kj,2},d)
        index=1;
    end
end

if index==0
    A{jk,2}=d;
    A{jk,1}=jk-1;
    st='Present';
    p=char(st);
    A{jk,3}=p;
    jk=jk+1;
end

% Map back to training set to find identity 
booleanIndex = strcmp(personLabel, personIndex);
integerIndex = find(booleanIndex);


  figure,
subplot(1,2,1);imshow(queryImage);title('Query Face');
subplot(1,2,2);imshow(read(training(integerIndex),1));title('PRESENT');
pause(1.5);


end
filename= 'excel.xlsx';

xlswrite(filename,A)
A



% --------------------------------------------------------------------
function author_Callback(hObject, eventdata, handles)
% hObject    handle to author (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox(sprintf('Name : C.LALNUNCHAMA,\n             MANUKUMAR RUDRESH\nB.Tech CSE\nNIT Rourkela'),'Author','Help')
