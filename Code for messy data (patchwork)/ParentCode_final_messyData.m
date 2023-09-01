%%Barton Method for Evaluating Flow Data
% Katie Straus (katie.straus@gmail.com), Lilit Yeghiazarian (yeghialt@ucmail.uc.edu)
% Department of Biomedical, Chemical and Environmental Engineering, University of Cincinnati, Cincinnati, OH, USA 

clear
close all
clc

%%  Import Data (Data must be 5 min intervals to be transformed into hours)
%Loading Data selection (data must be 5 min and transformable to hours
firstfolder=pwd;
%data_directory=uigetdir;
[FileName, PathName]=uigetfile('*.*');

cd(PathName);

[~,~,ext]=fileparts(FileName);

if strcmp(ext,'.xlsx')
    RawData=readtable(strcat(FileName),'ReadVariableNames',false);
    DT=RawData(:,1);
    Q=RawData(:,2);
    DT=DT{:,:};
    Q=Q{:,:};
    
elseif strcmp(ext,'.csv')
%     opts=detectImportOptions(FileName,'FileType','text');
     RawData= readtable(FileName);
     
elseif any(strcmp(ext, { '.txt', '.tsf'}))
    opts=detectImportOptions(FileName,'FileType','text');
    opts.VariableNames={'Date', 'Flow'};
     opts = setvaropts(opts,'Date','InputFormat','uuuu-MM-dd HH:mm:ss');
     [DT, Q]= readvars(FileName,opts);
end
cd(firstfolder);

%% Aggregating data to one hour intervals
%imported data is in 5 minute intervals

%patchwork removes zero sections

[patchwork, Patched_DT]=patchworking(Q,DT);
medFilt=dsp.MedianFilter(10);%median filter with a window of 10, to remove small variations and noise
mf=medFilt(patchwork);%applying median filter

%%
loessmf13=smoothdata(mf,'rloess',156);%rloess is a robust smoothing filter 
%156 five-minute intervals is 13 hours, this is the window the filter uses

%%
[Aggregated_data,dtv]=aggregating_patcheddata(loessmf13,Patched_DT);
%This transforms the data from 5 minute increments to 1 hour increments
%dtv is the date-time vector
    
%% BARTON Seven Day
%reshape data into a matrix that is 168 columns, each column represents one hour of a week
%and rows=#ofweeks, (i.e. all flow measurements at sunday 10:00pm are in the same column)
[Qnew_med,Q1_center]= weekly_median_data(Aggregated_data);
forecastpoints=length(Aggregated_data);

%Generate model using the starting point and average change in flow
[Sevenday_model]=Model_generation_nondiff(Qnew_med,Q1_center,forecastpoints);
%%
figure(4)
clf
plot(dtv(1:length(Sevenday_model)),Sevenday_model,'r','linewidth',1)
hold on
plot(dtv(1:length(Sevenday_model)),Aggregated_data(1:length(Sevenday_model)).','b','linewidth',1)
set(gca,'FontSize',15)

axis tight
title ('Barton and Competiton Mode with Measured Data','FontSize',18')
ylabel ('Flow (mgd)','FontSize',18')
xlabel ('Date','FontSize',18')
legend('Barton Model','Competiton Data','Measured Data','FontSize',18')

%% Fast Fourier Transform
%generates Spectral Density Plot of model resdiuals
[freq,PSD]=fftest(Sevenday_model,Aggregated_data,dtv);

