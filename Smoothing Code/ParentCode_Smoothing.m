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
    RawData=xlsread(strcat(PathName,FileName),'');
    Dc=RawData(:,1);
    DT=datetime(Dc,'ConvertFrom','excel');
    Q=RawData(:,2);
    
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

%patchwork removes zero sections

[patchwork,Patched_DT]=patchworking(Q,DT);
medFilt=dsp.MedianFilter(10);%median filter with a window of 10, to remove small variations and noise
mf=medFilt(patchwork);%applying median filter

loessmf12=smoothdata(mf,'rloess',144);%rloess is a robust smoothing filter 
%144 five-minute intervals is 12 hours, this is the window the filter uses
%%

[Aggregated_data,dtv]=aggregating_data(loessmf12,Patched_DT);
%This will allow you to select excel file of data and then transform it
%from 5 minute increments to 1 hour increments
%dtv is the date-time vector

%% BARTON Seven Day
L=length(Aggregated_data);

%Using only eight weeks of data (plus one point for derivative) 
%since this was a discussed parameter, change to whatever length is suitable

%reshape data into a matrix the is 168 columns and rows=#ofweeks, each
%column has all the data for that hour of the data (i.e. all flow
%measurements at sunday 10:00pm are in the same column)

[Qnew_med,Q1_center]= weekly_median_data(Aggregated_data);%Q1_center is the starting point of the week
%Qnew_ave is the average change in flow for each hour matrix of [1x168]

forecastpoints=L;
%Generate model using the starting point and average change in flow
[Sevenday_model]=Model_generation_nondiff(Qnew_med,Q1_center,forecastpoints);
%%
figure(3)
clf
plot(dtv(1:end-1),Sevenday_model)
hold on
plot(dtv(1:end-1),Aggregated_data(1:end-1))
axis tight
title ('Seven-Day Model and Data','FontSize',18')
ylabel ('Flow (mgd)','FontSize',18')
xlabel ('Date','FontSize',18')
legend('Seven-Day Model','Data','FontSize',18')

%% Fast Fourier Transform
%generates Spectral Density Plot of model resdiuals
[freq,PSD,Residuals]=fftest(Sevenday_model,Aggregated_data,dtv);
