% analyze

clear all
close all

roi{1}=[1 8 15 22 5 12];
roi{2}=[2 9 16 23 6 19];
roi{3}=[3 10 17 24 13 20];
roi{4}=[4 11 18 7 14 21];
[filenames pnames]=uigetfile('*.mat','MultiSelect', 'on','Select the .mat files');

% get genotype ROIs and experiment info

%a=inputdlg('Please enter the number of genotypes');
%numGenotypes=str2num(a{1});

%for i=1:numGenotypes
    %     temp=inputdlg(['Please enter the well numbers for genotype # ' num2str(i)]) ;
    %     roi{i}=str2num(temp{1});
    
    %     temp2=inputdlg(['Please enter a name for genotype # ' num2str(i)]);
    %     roinames{i}=temp2{1};
%end

%b=inputdlg('Please enter experiment start day');
expstartday=1;
save inits
%%
clear all
close all
load inits
% make time vector

timept(1)=expstartday;
% for i=1:length(filenames)
%     templ=length(filenames{i});
%     
%     % cut off the "pdata" in the beginning and ".mat" at the end
%     % in order to get just the number
%     filenum(i)=str2num(filenames{i}(6:(templ-4)));
%     
%     if i>1
%         timeelapsed=(filenum(i)-filenum(i-1))/1050;
%         timept(i)=timept(i-1)+12*timeelapsed;
%     end
% end

timept(1)=expstartday;
load imageTimeArray
dayv=imageTimeArray(:,3);
hourv=imageTimeArray(:,4);
for i=1:length(filenames)
    templ=length([filenames{i}]);
    
    % cut off the "pdata" in the beginning and ".mat" at the end
    % in order to get just the number
    filenum(i)=str2num([filenames{i}(6:(templ-4))]);
    
    if i>1
        timeelapsed=(dayv(filenum(i))-dayv(filenum(i-1)));
        if timeelapsed>=0
            timept(i)=timept(i-1)+timeelapsed;
        else
            timept(i)=timept(i-1)+dayv(filenum(i))+31-dayv(filenum(i-1));
        end
    end
end
for i=1:length(filenames)
    templ=length([filenames{i}]);
    filenum(i)=str2num([filenames{i}(6:(templ-4))]);
    timept(i)=timept(i)+hourv(filenum(i))/24;
end


framestouse=100;
lastbeforelight=180;
firstafterlight=188;

framestouse=100;
%lastbeforelight=180;
%firstafterlight=184;

for i=1:length(filenames)
    try
    load([pnames '/' filenames{i}])
    pdata(pdata<0)=NaN;
    ll=length(pdata);
    lastbeforelight=round(ll/2)-1;
    firstafterlight=round(ll/2)+1;
    
    for j=1:240
        bl(i,j)=nanmean(pdata((lastbeforelight-framestouse):lastbeforelight,j));
        al(i,j)=nanmean(pdata((firstafterlight):(firstafterlight+framestouse),j));
        
        bm(i,j)=prctile(pdata(1:lastbeforelight,j),95);
        am(i,j)=prctile(pdata(firstafterlight:end,j),95);
        %am(i,j)=max(pdata(firstafterlight:end,j));
    end
    catch
    end
end
figure;
imagesc(am)

numGenotypes=length(roi);
save lightresponse1 bl al am bm
save ROIs1 numGenotypes roi expstartday timept %roinames