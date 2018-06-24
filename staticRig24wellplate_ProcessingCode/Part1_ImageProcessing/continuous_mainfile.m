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

display(['ROI selection complete.  Now moving on to image processing step.'])

pause(1)
close all
pause(1)

foldername=uigetdir('Select Directory with images to process');
srcDir=foldername; % change to let user select
imageFileExtension = 'png'; % change to let user input

destAnalysisFolder = [srcDir '\Analysis'];


if ~exist(destAnalysisFolder, 'dir')
    mkdir(destAnalysisFolder);
end

d=dir([srcDir '\*.' imageFileExtension]);

imageTimeArray = GetImageTimeArrayMatt(d);
% 
% disp('Searching active imaging periods');
% maxTimeIntervalSec = 30;
% minDurationMin = 18;
% activePeriodsArray = SearchActiveImagingPeriodsMatt(imageTimeArray, maxTimeIntervalSec, minDurationMin);
% disp('Done');
% 
% activePeriodsArray = SearchStimulationTimeMatt(srcDir, d, imageTimeArray, activePeriodsArray);

save([destAnalysisFolder '\fileNames.mat'], 'd');
save([destAnalysisFolder '\imageTimeArray.mat'], 'imageTimeArray');
%save([destAnalysisFolder '\activePeriods.mat'],'activePeriodsArray');

display(['Beginning image processing. Maybe grab a coffee.'])
analysisInterval1 = 10; % sec
analysisInterval2 = 20; % sec
spi=5; % seconds per image
autosaveframes=1000;
NoiseThres=0.125;
continuous_activityanalysis(d,srcDir,NoiseThres,destAnalysisFolder,analysisInterval1,analysisInterval2,spi,autosaveframes)



