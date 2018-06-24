% WorMotel w/ light stimulation image processing file
% By Matt Churgin.  Last updated 22 Sep. 2016
% Dependents include ComputeActivityMatt.m,
% ComputeTimeDiffBtwTwoDateVectorsMatt, GetImageTimeArrayMatt.m,
% ROIDefine.m, SearchActiveImagingPeriodsMatt.m, and
% SearchStimulationTimeMatt.m

% Run this code to process images

clear all
close all

ROIDefine
pause(1)
close all
pause(1)
display(['ROI selection complete.  Now moving on to image processing step.'])

foldername=uigetdir('Select Directory with images to process');
srcDir=foldername; % change to let user select
imageFileExtension = 'png'; % change to let user input

destAnalysisFolder = [srcDir '\Analysis60'];


if ~exist(destAnalysisFolder, 'dir')
    mkdir(destAnalysisFolder);
end

d=dir([srcDir '\*.' imageFileExtension]);

imageTimeArray = GetImageTimeArrayMatt(d);

disp('Searching active imaging periods');
maxTimeIntervalSec = 30;
minDurationMin = 18;
activePeriodsArray = SearchActiveImagingPeriodsMatt(imageTimeArray, maxTimeIntervalSec, minDurationMin);
disp('Done');

activePeriodsArray = SearchStimulationTimeMatt(srcDir, d, imageTimeArray, activePeriodsArray);

save([destAnalysisFolder '\fileNames.mat'], 'd');
save([destAnalysisFolder '\imageTimeArray.mat'], 'imageTimeArray');
save([destAnalysisFolder '\activePeriods.mat'],'activePeriodsArray');

display(['Beginning image processing.  This may take up to a few hours depending on the number of images.  Maybe grab a coffee.'])
analysisInterval = 60; % sec
ComputeActivityMatt(d, imageTimeArray, activePeriodsArray, analysisInterval, srcDir, destAnalysisFolder);



destAnalysisFolder = [srcDir '\Analysis5'];


if ~exist(destAnalysisFolder, 'dir')
    mkdir(destAnalysisFolder);
end

d=dir([srcDir '\*.' imageFileExtension]);

imageTimeArray = GetImageTimeArrayMatt(d);

disp('Searching active imaging periods');
maxTimeIntervalSec = 30;
minDurationMin = 18;
activePeriodsArray = SearchActiveImagingPeriodsMatt(imageTimeArray, maxTimeIntervalSec, minDurationMin);
disp('Done');

activePeriodsArray = SearchStimulationTimeMatt(srcDir, d, imageTimeArray, activePeriodsArray);

save([destAnalysisFolder '\fileNames.mat'], 'd');
save([destAnalysisFolder '\imageTimeArray.mat'], 'imageTimeArray');
save([destAnalysisFolder '\activePeriods.mat'],'activePeriodsArray');

display(['Beginning image processing.  This may take up to a few hours depending on the number of images.  Maybe grab a coffee.'])
analysisInterval = 5; % sec
ComputeActivityMatt(d, imageTimeArray, activePeriodsArray, analysisInterval, srcDir, destAnalysisFolder);



