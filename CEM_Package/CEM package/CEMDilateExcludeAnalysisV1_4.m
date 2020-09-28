function varargout = CEMDilateExcludeAnalysisV1_4(varargin)
% CEMDilateExcludeAnalysisV1_4 MATLAB code for CEMDilateExcludeAnalysisV1_4.fig
%      CEMDilateExcludeAnalysisV1_4, by itself, creates a new CEMDilateExcludeAnalysisV1_4 or raises the existing
%      singleton*.
%
%      H = CEMDilateExcludeAnalysisV1_4 returns the handle to a new CEMDilateExcludeAnalysisV1_4 or the handle to
%      the existing singleton*.
%
%      CEMDilateExcludeAnalysisV1_4('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CEMDilateExcludeAnalysisV1_4.M with the given input arguments.
%
%      CEMDilateExcludeAnalysisV1_4('Property','Value',...) creates a new CEMDilateExcludeAnalysisV1_4 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CEMDilateExcludeAnalysisV1_4_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CEMDilateExcludeAnalysisV1_4_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CEMDilateExcludeAnalysisV1_4

% Last Modified by GUIDE v2.5 06-Aug-2014 11:56:11

% this GUI was developed by Krishnan Padmanabhan at the Crick-Jacobs Center in the Salk Institute for the lab of 
% Fred H. Gage (Laboratory of Genetics) and was used in the manuscript Kerman et al. ______ as part of the myelin
% analysis tool kit.  
% 
% All functions are detailed below - and any questions can be sent to krishnan@salk.edu -
% These tools are provided as part of the fair use license.  Any use of them for scientific publication should include
% the references 
% 
% K. Padmanabhan, W.F. Eddy, J.C. Crowley. A novel algorithm for optimal image thresholding of biological data. 2010.  
% Journal of Neuroscience Methods 193(2):380-4.
% 
% and
% 
% Bilal E. Kerman1, Hyung Joon Kim1, Krishnan Padmanabhan1,2,3, 
% Arianna Mei1,Shereen Georges1, Matthew S. Joens4, 
% James A. J. Fitzpatrick4, Roberto Jappelli1, Karen J. Chandross5, Paul August6, and Fred H. Gage1% 
% 
% version 1.3 has the following updates: 
% 
% 1) it asks you if you would like to overwrite an existing save file and responds accordingly - 
% 2) There are progress bars for loading, saving, and processing - they are referenced as seperate figures that pop up 
% 3) the iterface was modified to rescale over different monitors. 








% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CEMDilateExcludeAnalysisV1_4_OpeningFcn, ...
                   'gui_OutputFcn',  @CEMDilateExcludeAnalysisV1_4_OutputFcn, ...
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


% --- Executes just before CEMDilateExcludeAnalysisV1_4 is made visible.
function CEMDilateExcludeAnalysisV1_4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CEMDilateExcludeAnalysisV1_4 (see VARARGIN)
axes(handles.DilateExcludeAxis1); 
imshow(zeros(100,100,3)); axis equal; axis tight; axis off; 

%Loads some blank data for the image groups 
set(handles.DilateBox1, 'Value', 0); 
set(handles.DilateBox2, 'Value', 0); 
set(handles.ExcludeBox1, 'Value', 0); 
set(handles.ExcludeBox2, 'Value', 0); 
set(handles.ProcessedBox, 'Value', 0); 
set(handles.OriginalBox, 'Value', 0); 



handles.ImageGroup.Original = zeros(10,10,3); 
handles.ImageGroup.Processed = zeros(10,10,3); 
handles.ImageGroup.OriginalSize = size(handles.ImageGroup.Original,3); 
handles.ImageGroup.ProcessedSize = size(handles.ImageGroup.Processed,3); 
handles.FileLoc.F = []; 
handles.FileLoc.P = []; 
handles.FileLoc.numberImages = 3; 

%loads some blank data for the text groups; 
handles.TextBoxGroup.DilateText = ''; set(handles.DilateText, 'String', '');  
handles.TextBoxGroup.ExcludeText = ''; set(handles.ExcludeText, 'String', ''); 
handles.TextBoxGroup.SaveText = ''; set(handles.SaveText, 'String', ''); 

handles.BoxStates.BoxVector = [0 0 0 0]; 


% Choose default command line output for CEMDilateExcludeAnalysisV1_4
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CEMDilateExcludeAnalysisV1_4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CEMDilateExcludeAnalysisV1_4_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in OriginalBox.
function OriginalBox_Callback(hObject, eventdata, handles)
% hObject    handle to OriginalBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of OriginalBox

OriginalBoxValue = get(hObject, 'Value'); 
if OriginalBoxValue == 1; 
   %toggles the Processed View Box off; 
    set(handles.ProcessedBox, 'Value', 0); 
  %Displays the Image
    
    axes(handles.DilateExcludeAxis1); 
    
    if handles.FileLoc.numberImages == 1; 
        if length(size(handles.ImageGroup.Original)) == 2; 
            imshow(handles.ImageGroup.Original); axis equal; axis tight; axis off; colormap(gray); 
        else
            imshow(handles.ImageGroup.Original); axis equal; axis tight; axis off; 
        end
        
    else
        
                imshow(max(handles.ImageGroup.Original, [], 3)); axis equal; axis tight; axis off; colormap(gray); 
        
    end
    
else
end

guidata(hObject, handles);


% --- Executes on button press in ProcessedBox.
function ProcessedBox_Callback(hObject, eventdata, handles)

ProcessedBoxValue = get(hObject, 'Value'); 
if ProcessedBoxValue == 1; 
    set(handles.OriginalBox, 'Value', 0);
    axes(handles.DilateExcludeAxis1); 
    

    if handles.FileLoc.numberImages == 1; 
        if length(size(handles.ImageGroup.Processed)) == 2; 
            imshow(handles.ImageGroup.Processed); axis equal; axis tight; axis off; colormap(gray); 
        else
            imshow(handles.ImageGroup.Processed); axis equal; axis tight; axis off; 
        end
        
    else
        
                imshow(max(handles.ImageGroup.Processed, [], 3)); axis equal; axis tight; axis off; colormap(gray); 
        
    end
    

else
end


% hObject    handle to ProcessedBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ProcessedBox
guidata(hObject, handles);


% --- Executes on button press in LoadButton.
function LoadButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CurrentDir = pwd; 
handles.FileLoc.CurrentDir = CurrentDir; 

[F P] = uigetfile('*.*', 'Open Image'); 
if F == 0; 
    handles.FileLoc.F = []; 
    F = []; 
    P = []; 
else
end
if ~isempty(F); 
    
    handles.FileLoc.F = F; 
    handles.FileLoc.P = P; 
    
    cd(P); 
    
    iInfo = imfinfo(F); 
    nImage = iInfo(1).Width; handles.FileLoc.nImage = nImage; 
    mImage = iInfo(1).Height; handles.FileLoc.mImage = mImage; 
    numberImages = length(iInfo); handles.FileLoc.numberImages = numberImages; 
    
    if numberImages == 1; 
        Original = imread(F); 
           h_LoadingFig = figure(998); axis off; axis equal; axis tight; 
           LoadingImage = zeros(20,150,3); LoadingImage(:,:,2) = ones(size(LoadingImage,1), size(LoadingImage, 2));
           figure(h_LoadingFig); imshow(LoadingImage); axis off; axis equal; axis tight; 
           h_LoadingText = text(5, 10, 'YES!! It is loading...', 'FontSize', 16); 
        
        
    else
        for qq = 1:numberImages; 
            Original(:,:,qq) = imread(F, 'Index', qq); 
            h_LoadingFig = figure(998); axis off; axis equal; axis tight; 
           LoadingImage = zeros(20,150,3); LoadingImage(:,:,2) = ones(size(LoadingImage,1), size(LoadingImage, 2));
           figure(h_LoadingFig); imshow(LoadingImage); axis off; axis equal; axis tight; 
           h_LoadingText = text(5, 10, 'YES!! It is loading...', 'FontSize', 16); 
        end
    end
    
    delete(h_LoadingText); 
    close(h_LoadingFig); 
    
    handles.ImageGroup.Original = Original; 
    
    axes(handles.DilateExcludeAxis1); 
    if numberImages == 1; 
        if length(size(Original)) == 2; 
            imshow(Original); axis equal; axis tight; axis off; colormap(gray); 
        else
            imshow(Original); axis equal; axis tight; axis off; 
        end
        
    else %Max intensity of the zstack
        
        imshow(max(Original, [], 3)); axis equal; axis tight; axis off; colormap(gray); 
        
    end
    
    
else
end
set(handles.OriginalBox, 'Value', 1); 


guidata(hObject, handles);


% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if  length(handles.TextBoxGroup.SaveText) == 0; 
    if isempty(handles.FileLoc.F)
                
    else
      
        tmpsaveFileName = [handles.FileLoc.F(1:end-4) '_Processed.tif']; 
        
        if exist(tmpsaveFileName, 'file');
            getStateofSavedFile = questdlg('ACK! This file Already Exists...Erase and Rewrite?', 'Save Error', 'Yes', 'No','Yes');
            
            switch getStateofSavedFile
                case 'Yes'
                    delete(tmpsaveFileName);
                    if size(handles.ImageGroup.Processed,3) > 3;
                        
                        for tt = 1:size(handles.ImageGroup.Processed, 3);
                            imwrite(handles.ImageGroup.Processed(:,:,tt), tmpsaveFileName, 'WriteMode', 'append', 'Compression', 'none');
                            pause(0.2); 
                                h_SavingFig = figure(999); axis off; axis equal; axis tight; 
                SavingImage = zeros(20,100,3); SavingImage(:,:,2) = ones(size(SavingImage,1), size(SavingImage, 2));
                figure(h_SavingFig); imshow(SavingImage); axis off; axis equal; axis tight; 
                h_SavingText = text(5, 10, 'Saving....', 'FontSize', 16); 
                        end
                    else
                        imwrite(handles.ImageGroup.Processed, tmpsaveFileName, 'tif');
                                                    pause(0.2); 
                            h_SavingFig = figure(999); axis off; axis equal; axis tight; 
                SavingImage = zeros(20,100,3); SavingImage(:,:,2) = ones(size(SavingImage,1), size(SavingImage, 2));
                figure(h_SavingFig); imshow(SavingImage); axis off; axis equal; axis tight; 
                h_SavingText = text(5, 10, 'Saving....', 'FontSize', 16); 
                    end
                    
                case 'No'
                    errorCaseMessageBox = msgbox('Change the save file name and try again'); 
                    
                    
            end
            
        else
            if size(handles.ImageGroup.Processed,3) > 3;
                
                for tt = 1:size(handles.ImageGroup.Processed, 3);
                    imwrite(handles.ImageGroup.Processed(:,:,tt), tmpsaveFileName, 'WriteMode', 'append', 'Compression', 'none');
                                                pause(0.2); 
                        h_SavingFig = figure(999); axis off; axis equal; axis tight; 
                SavingImage = zeros(20,100,3); SavingImage(:,:,2) = ones(size(SavingImage,1), size(SavingImage, 2));
                figure(h_SavingFig); imshow(SavingImage); axis off; axis equal; axis tight; 
                h_SavingText = text(5, 10, 'Saving....', 'FontSize', 16); 
                end
            else
                imwrite(handles.ImageGroup.Processed, tmpsaveFileName, 'tif');
                                            pause(0.2); 
                    h_SavingFig = figure(999); axis off; axis equal; axis tight; 
                SavingImage = zeros(20,100,3); SavingImage(:,:,2) = ones(size(SavingImage,1), size(SavingImage, 2));
                figure(h_SavingFig); imshow(SavingImage); axis off; axis equal; axis tight; 
                h_SavingText = text(5, 10, 'Saving....', 'FontSize', 16); 
            end
        end
    end
    
else
    tmpsaveFileName = [handles.TextBoxGroup.SaveText '.tif']; 
    
    if exist(tmpsaveFileName, 'file');
        getStateofSavedFile = questdlg('ACK! This file Already Exists...Erase and Rewrite?', 'Save Error', 'Yes', 'No','Yes');
        
        switch getStateofSavedFile
            case 'Yes'
                delete(tmpsaveFileName);
                if size(handles.ImageGroup.Processed,3) > 3;
                    
                    for tt = 1:size(handles.ImageGroup.Processed, 3);
                        imwrite(handles.ImageGroup.Processed(:,:,tt), tmpsaveFileName, 'WriteMode', 'append', 'Compression', 'none');                            pause(0.2); 
                                                    pause(0.2); 

                        h_SavingFig = figure(999); axis off; axis equal; axis tight; 
                SavingImage = zeros(20,100,3); SavingImage(:,:,2) = ones(size(SavingImage,1), size(SavingImage, 2));
                figure(h_SavingFig); imshow(SavingImage); axis off; axis equal; axis tight; 
                h_SavingText = text(5, 10, 'Saving....', 'FontSize', 16); 
                    end
                else
                    imwrite(handles.ImageGroup.Processed, tmpsaveFileName, 'tif');
                                                pause(0.2); 

                    h_SavingFig = figure(999); axis off; axis equal; axis tight; 
                SavingImage = zeros(20,100,3); SavingImage(:,:,2) = ones(size(SavingImage,1), size(SavingImage, 2));
                figure(h_SavingFig); imshow(SavingImage); axis off; axis equal; axis tight; 
                h_SavingText = text(5, 10, 'Saving....', 'FontSize', 16); 
                end
                
            case 'No'
                errorCaseMessageBox = msgbox('Change the save file name and try again');
                
                
        end
    else
        if size(handles.ImageGroup.Processed,3) > 3;
            
            for tt = 1:size(handles.ImageGroup.Processed, 3);
                imwrite(handles.ImageGroup.Processed(:,:,tt), tmpsaveFileName, 'WriteMode', 'append', 'Compression', 'none');
                                            pause(0.2); 

                h_SavingFig = figure(999); axis off; axis equal; axis tight; 
                SavingImage = zeros(20,100,3); SavingImage(:,:,2) = ones(size(SavingImage,1), size(SavingImage, 2));
                figure(h_SavingFig); imshow(SavingImage); axis off; axis equal; axis tight; 
                h_SavingText = text(5, 10, 'Saving....', 'FontSize', 16); 
                
                
            end
        else
            imwrite(handles.ImageGroup.Processed, tmpsaveFileName, 'tif');
                                        pause(0.2); 

            h_SavingFig = figure(999); axis off; axis equal; axis tight; 
                SavingImage = zeros(20,100,3); SavingImage(:,:,2) = ones(size(SavingImage,1), size(SavingImage, 2));
                figure(h_SavingFig); imshow(SavingImage); axis off; axis equal; axis tight; 
                h_SavingText = text(5, 10, 'Saving....', 'FontSize', 16); 
        end
    end
   
end
delete(h_SavingText); 
close(h_SavingFig); 
guidata(hObject, handles);



function SaveText_Callback(hObject, eventdata, handles)
% hObject    handle to SaveText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SaveText as text
%        str2double(get(hObject,'String')) returns contents of SaveText as a double

handles.TextBoxGroup.SaveText = get(hObject, 'String'); 
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function SaveText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SaveText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ExcludeText_Callback(hObject, eventdata, handles)
% hObject    handle to ExcludeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ExcludeText as text
%        str2double(get(hObject,'String')) returns contents of ExcludeText as a double

handles.TextBoxGroup.ExcludeText = get(hObject, 'String'); 
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ExcludeText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ExcludeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DilateBox1.
function DilateBox1_Callback(hObject, eventdata, handles)

handles.BoxStates.BoxVector(1) = get(hObject, 'Value'); 

if handles.BoxStates.BoxVector(1) == 1; 
    set(handles.DilateBox2, 'Value', 0); 
    set(handles.ExcludeBox1, 'Value', 0); 
    handles.BoxStates.BoxVector(2) = 0; 
    handles.BoxStates.BoxVector(3) = 0; 
else
end
% hObject    handle to DilateBox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DilateBox1
guidata(hObject, handles);


% --- Executes on button press in DilateBox2.
function DilateBox2_Callback(hObject, eventdata, handles)

handles.BoxStates.BoxVector(2) = get(hObject, 'Value'); 

if handles.BoxStates.BoxVector(2) == 1; 
    set(handles.DilateBox1, 'Value', 0); 
    set(handles.ExcludeBox2, 'Value', 0); 
    set(handles.ExcludeBox1, 'Value', 1); 
    handles.BoxStates.BoxVector(1) = 0; 
    handles.BoxStates.BoxVector(3) = 1; 
    handles.BoxStates.BoxVector(4) = 0; 
else
end
% hObject    handle to DilateBox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DilateBox2
guidata(hObject, handles);


% --- Executes on button press in ExcludeBox1.
function ExcludeBox1_Callback(hObject, eventdata, handles)

handles.BoxStates.BoxVector(3) = get(hObject, 'Value'); 

if handles.BoxStates.BoxVector(3) == 1; 
    set(handles.DilateBox1, 'Value', 0); 
    set(handles.ExcludeBox2, 'Value', 0); 
    handles.BoxStates.BoxVector(1) = 0; 
    handles.BoxStates.BoxVector(4) = 0; 
else
end

% hObject    handle to ExcludeBox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ExcludeBox1
guidata(hObject, handles);


% --- Executes on button press in ExcludeBox2.
function ExcludeBox2_Callback(hObject, eventdata, handles)

handles.BoxStates.BoxVector(4) = get(hObject, 'Value'); 

if handles.BoxStates.BoxVector(4) == 1; 
    set(handles.DilateBox1, 'Value', 1); 
    set(handles.DilateBox2, 'Value', 0); 
    set(handles.ExcludeBox1, 'Value', 0); 
    handles.BoxStates.BoxVector(1) = 1; 
    handles.BoxStates.BoxVector(2) = 0; 
    handles.BoxStates.BoxVector(3) = 0; 
else
end

% hObject    handle to ExcludeBox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ExcludeBox2
guidata(hObject, handles);


% --- Executes on button press in ProcessButton.
function ProcessButton_Callback(hObject, eventdata, handles)
% hObject    handle to ProcessButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

binaryofBoxStates = handles.BoxStates.BoxVector; 
decofBoxStates = sum(binaryofBoxStates.*(2.^[4-1 :-1 : 0]));

if length(handles.TextBoxGroup.DilateText) == 0; 
        
            dilateValue = 1; 
else
    dilateValue = str2num(handles.TextBoxGroup.DilateText); 
end

if length(handles.TextBoxGroup.ExcludeText) == 0; 
    
    excludeValue = 1; 
else
    excludeValue = str2num(handles.TextBoxGroup.ExcludeText); 
end


switch decofBoxStates
    
    case 0 %dont do anything 
        
    case 8 %Dilate only 
       handles.ImageGroup.Processed = []; 
        for ww = 1:size(handles.ImageGroup.Original,3); 
           handles.ImageGroup.Processed(:,:,ww) = imdilate(handles.ImageGroup.Original(:,:,ww), strel('disk', dilateValue)); 
           h_ProcessingFig = figure(999); axis off; axis equal; axis tight; 
           ProcessingImage = zeros(20,250,3); ProcessingImage(:,:,1) = ones(size(ProcessingImage,1), size(ProcessingImage, 2));
           figure(h_ProcessingFig); imshow(ProcessingImage); axis off; axis equal; axis tight; 
           h_ProcessingText = text(5, 10, 'Hold your horses...Processing', 'FontSize', 16); 
        
       end
        
    case 9 %dilate First then exclude
        handles.ImageGroup.Processed = []; 
        for ww = 1:size(handles.ImageGroup.Original,3); 
            handles.ImageGroup.Processed(:,:,ww) = bwareaopen(imdilate(handles.ImageGroup.Original(:,:,ww), strel('disk', dilateValue)), excludeValue);
             h_ProcessingFig = figure(999); axis off; axis equal; axis tight; 
           ProcessingImage = zeros(20,250,3); ProcessingImage(:,:,1) = ones(size(ProcessingImage,1), size(ProcessingImage, 2));
           figure(h_ProcessingFig); imshow(ProcessingImage); axis off; axis equal; axis tight; 
           h_ProcessingText = text(5, 10, 'Hold your horses...Processing', 'FontSize', 16); 
        end
        
    case 2 % exclude only 
         handles.ImageGroup.Processed = []; 
        for ww = 1:size(handles.ImageGroup.Original,3); 
            handles.ImageGroup.Processed(:,:,ww) = bwareaopen(handles.ImageGroup.Original(:,:,ww), excludeValue);
             h_ProcessingFig = figure(999); axis off; axis equal; axis tight; 
           ProcessingImage = zeros(20,250,3); ProcessingImage(:,:,1) = ones(size(ProcessingImage,1), size(ProcessingImage, 2));
           figure(h_ProcessingFig); imshow(ProcessingImage); axis off; axis equal; axis tight; 
           h_ProcessingText = text(5, 10, 'Hold your horses...Processing', 'FontSize', 16); 
        end
        
    case 6 %exclude First, then dilate
          handles.ImageGroup.Processed = []; 
        for ww = 1:size(handles.ImageGroup.Original,3); 
            handles.ImageGroup.Processed(:,:,ww) = imdilate(bwareaopen(handles.ImageGroup.Original(:,:,ww), excludeValue),strel('disk', dilateValue));
             h_ProcessingFig = figure(999); axis off; axis equal; axis tight; 
           ProcessingImage = zeros(20,250,3); ProcessingImage(:,:,1) = ones(size(ProcessingImage,1), size(ProcessingImage, 2));
           figure(h_ProcessingFig); imshow(ProcessingImage); axis off; axis equal; axis tight; 
           h_ProcessingText = text(5, 10, 'Hold your horses...Processing', 'FontSize', 16); 
        end    
end

delete(h_ProcessingText); 
close(h_ProcessingFig); 

axes(handles.DilateExcludeAxis1); 
if size(handles.ImageGroup.Processed,3) > 3; 
    imshow(max(handles.ImageGroup.Processed, [], 3)); axis equal; axis tight; axis off; colormap(gray); 
    
else
    if size(handles.ImageGroup.Processed,3) == 3; 
        imshow(handles.ImageGroup.Processed); axis equal; axis tight; axis off; 
    else; 
        imshow(handles.ImageGroup.Processed); axis equal; axis tight; axis off; colormap(gray); 
    end
end

set(handles.ProcessedBox, 'Value', 1); 
set(handles.OriginalBox, 'Value', 0); 


guidata(hObject, handles);


function DilateText_Callback(hObject, eventdata, handles)
% hObject    handle to DilateText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DilateText as text
%        str2double(get(hObject,'String')) returns contents of DilateText as a double

handles.TextBoxGroup.DilateText = get(hObject, 'String'); 
 
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function DilateText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DilateText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
