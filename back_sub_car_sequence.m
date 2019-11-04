%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% VISUAL TRACKING
% ----------------------
% Q1: Implement the frame differencing approach for background subtraction 
% and apply it to the car sequence.
% ----------------
% Date: October 2016
% Authors: Charalampaki Eirini

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all
close all


%%%%% LOAD THE IMAGES
% Give image directory and extension
imPath = 'car'; imExt = 'jpg';

% check if directory and files exist
if isdir(imPath) == 0
    error('USER ERROR : The image directory does not exist');
end

filearray = dir([imPath filesep '*.' imExt]); % get all files in the directory
NumImages = size(filearray,1); % get the number of images
if NumImages < 0
    error('No image in the directory');
end

disp('Loading image files from the video sequence, please be patient...');
% Get image parameters
imgname = [imPath filesep filearray(1).name]; % get image name
I = imread(imgname); % read the 1st image and pick its size
VIDEO_WIDTH = size(I,2);
VIDEO_HEIGHT = size(I,1);

ImSeq = zeros(VIDEO_HEIGHT, VIDEO_WIDTH, NumImages);
for i=1:NumImages
    imgname = [imPath filesep filearray(i).name]; % get image name
    ImSeq(:,:,i) = imread(imgname); % load image
end
disp('So far so good...');

% BACKGROUND SUBTRACTION
%=======================

% Describe here your background subtraction method
T= 10; % start after T images
for i = 11: NumImages
    I = ImSeq(:,:,i);
    PastImages = ImSeq(:,:,i-T:i-1);   % take previous T images
    Background = median(PastImages,3);  % (3 is for t dimension)estimate a backgroun image
    Diff= abs(I - Background);
    Diff = mat2gray(Diff);
    Diff = Diff > graythresh(Diff);
   
end

% Draw the rectangle %%%%%%

 s = regionprops(Diff, 'Area', 'BoundingBox');     
     boundary =size(s);      
     
     Blob=0;
      for k = 1: boundary(1)         
        Blob(k)=s(k).Area;
      end      
     [maxValue, DrawIt] = max(Blob(:)); % Find the biggest region detected  
     Position = s(DrawIt).BoundingBox;
     %linearIndexesOfMaxes
    figure(1);
    subplot(141), imshow(I,[])
    title('Current frame')
    subplot(142), imshow(Background,[])
    title('Estimated background')

    subplot(143),imshow(Diff,[])
   
    title('Detected moving object')
    
    subplot(144),imshow(I,[])
    title('Detected moving object with bounding box')
    rectangle('Position',Position, 'EdgeColor','c')







