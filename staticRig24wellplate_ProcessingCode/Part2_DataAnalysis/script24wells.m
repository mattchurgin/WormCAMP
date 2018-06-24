% Load ROI information and activity
% Create cumulative activity and calculate lifespan and healthspan estimate
clear all
close all

load ROIs1
t=timept;
t=round(t*2)/2;

load lightresponse
amax=al;
bmax=bl;
amean=am;
bmean=bm;

save combined amax bmax amean bmean t

load ROIs1
load combined
mcolor(1,:)=[.2 .3 .8];
mcolor(2,:)=[0.9 0.2 0.1];
mcolor(3,:)=[0.6 0.2 0.6];
mcolor(4,:)=[0.8 0.45 0.05];

% linearly interpolate missing values
for j=1:length(roi)
    acell{j}=amean(:,roi{j});
    bcell{j}=bmean(:,roi{j});
    
    timePoints=1:size(acell{j},1);
    % find time points where imaging failed
    temp=find(mean(acell{j},2)==0);
    availableTimePoints=setxor(timePoints,temp);
    for i=1:length(temp)
        try
        earlyOktemp=find(availableTimePoints<temp(i));
        lateOktemp=find(availableTimePoints>temp(i));
        earlyOk=availableTimePoints(earlyOktemp(end));
        lateOk=availableTimePoints(lateOktemp(1));
        
        acell{j}(temp(i),:)=mean(acell{j}([earlyOk lateOk],:));
        
        temp2=find(mean(acell{j},2)==0);
        availableTimePoints=setxor(timePoints,temp2);
        catch
        end
    end
end

% create cumulative distribution function for each trace

for j=1:length(roi)
    CDFsum{j}=zeros(4,length(t));
    for i=1:length(roi{j})
        for z=1:length(t)
            CDFsum{j}(i,z)=nansum(acell{j}(1:z,i));
        end
        CDFsum{j}(i,:)=CDFsum{j}(i,:)/CDFsum{j}(i,end);
    end
end

metricp=99;
metrich=85;
figure
plot(t,mean(CDFsum{1},1),'Color',mcolor(1,:),'LineWidth',3)
hold on
plot(t,mean(CDFsum{4},1),'Color',mcolor(2,:),'LineWidth',3)
plot(t,mean(CDFsum{2},1),'Color',mcolor(4,:),'LineWidth',3)
plot(t,nanmean(CDFsum{3},1),'Color',mcolor(3,:),'LineWidth',3)
xlabel('Time (Days)')
ylabel('Cumulative Activity')
axis([0 40 0 1])
box off
legend('N2','\it{daf-16}','\it{tax-4}','\it{daf-2}')
legend boxoff
set(gca,'FontSize',15)

for j=1:length(roi)
    for i=1:length(roi{j})
        [t1 t2]=find(CDFsum{j}(i,:)>metricp/100);
        [t3 t4]=find(CDFsum{j}(i,:)>metrich/100);
        try
            AggLS{j}(i)=t(t2(1));
            AggHS{j}(i)=t(t4(1));
        catch
        end
    end    
end

figure
errorbar(1,mean(AggLS{1}),std(AggLS{1}),'o','Color',mcolor(1,:),'LineWidth',3,'MarkerSize',15)
hold on
errorbar(2,mean(AggLS{4}),std(AggLS{4}),'x','Color',mcolor(2,:),'LineWidth',3,'MarkerSize',15)
errorbar(3,mean(AggLS{2}),std(AggLS{2}),'s','Color',mcolor(4,:),'LineWidth',3,'MarkerSize',15)
errorbar(4,mean(AggLS{3}),std(AggLS{3}),'*','Color',mcolor(3,:),'LineWidth',3,'MarkerSize',15)
plot(1.25+randn(6,1)/10,AggLS{1},'o','Color',mcolor(1,:),'LineWidth',3)
hold on
plot(2.25+randn(6,1)/10,AggLS{4},'x','Color',mcolor(2,:),'LineWidth',3)
plot(3.25+randn(6,1)/10,AggLS{2},'s','Color',mcolor(4,:),'LineWidth',3)
plot(4.25+randn(6,1)/10,AggLS{3},'*','Color',mcolor(3,:),'LineWidth',3)
%plot(4+rand(6,1)/3,AggLS{3},'o','Color',molor(3,:),'LineWidth',3)
legend('N2','\it{daf-16}','\it{tax-4}','\it{daf-2}')
legend boxoff
box off
ylabel('T_{99} (Days)') 
set(gca,'XTick','')
set(gca,'FontSize',15)
axis([0.5 4.75 0 30])


figure
errorbar(1,mean(AggHS{1}),std(AggHS{1}),'o','Color',mcolor(1,:),'LineWidth',3,'MarkerSize',15)
hold on
errorbar(2,mean(AggHS{4}),std(AggHS{4}),'x','Color',mcolor(2,:),'LineWidth',3,'MarkerSize',15)
errorbar(3,mean(AggHS{2}),std(AggHS{2}),'s','Color',mcolor(4,:),'LineWidth',3,'MarkerSize',15)
errorbar(4,mean(AggHS{3}),std(AggHS{3}),'*','Color',mcolor(3,:),'LineWidth',3,'MarkerSize',15)
plot(1.25+randn(6,1)/10,AggHS{1},'o','Color',mcolor(1,:),'LineWidth',3)
hold on
plot(2.25+randn(6,1)/10,AggHS{4},'x','Color',mcolor(2,:),'LineWidth',3)
plot(3.25+randn(6,1)/10,AggHS{2},'s','Color',mcolor(4,:),'LineWidth',3)
plot(4.25+randn(6,1)/10,AggHS{3},'*','Color',mcolor(3,:),'LineWidth',3)
legend('N2','\it{daf-16}','\it{tax-4}','\it{daf-2}')
legend boxoff
box off
ylabel('T_{85} (Days)') 
set(gca,'XTick','')
set(gca,'FontSize',15)
axis([0.5 4.75 0 30])

