%%TDR Method for Evaluating Flow Data
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

[Aggregated_data,dtv]=aggregating_data(Q,DT);
%This will allow you to select excel file of data and then transform it
%from 5 minute increments to 1 hour increments
%dtv is the date-time vector

%% BARTON Seven Day
L=length(Aggregated_data);


%% Random sampling
sample_months=11;
L_months=4*168*sample_months;
months=L/(4*168);
available_samples=months-sample_months;
rng('shuffle');
sample_start_months=randperm(floor(available_samples),20);

Data_fft_signals=zeros(20,2);
Residual_fft_signals=zeros(20,2);

for m=1:20
    start_location=sample_start_months(m)*168*4;
    sample_aggregated_data=Aggregated_data(start_location:start_location+L_months);
    [Qnew_med,Q1_center]= weekly_differencing_Mediandata(sample_aggregated_data);
    forecastpoints=L_months+1;
    [Sevenday_model]=Model_generation(Qnew_med,Q1_center,forecastpoints);
    [freq,PSD,DPSD,Residuals]=fftest(Sevenday_model,sample_aggregated_data,dtv(start_location:start_location+L_months));
    L12=find(freq==28);
    L24=find(freq==56);
    Data_fft_signals(m,1)=DPSD(L24); %24 hour signal
    Data_fft_signals(m,2)=DPSD(L12); %12 hour signal
    Residual_fft_signals(m,1)=PSD(L24);
    Residual_fft_signals(m,2)=PSD(L12);
end

%%

%Using only eight weeks of data (plus one point for derivative) 
%since this was a discussed parameter, change to whatever length is suitable

%reshape data into a matrix the is 168 columns and rows=#ofweeks, each
%column has all the data for that hour of the data (i.e. all flow
%measurements at sunday 10:00pm are in the same column)

[Qnew_med,Q1_center]= weekly_differencing_Mediandata(Aggregated_data);%Q1_center is the starting point of the week
%Qnew_ave is the average change in flow for each hour matrix of [1x168]

forecastpoints=L;
%Generate model using the starting point and average change in flow
[Sevenday_model]=Model_generation(Qnew_med,Q1_center,forecastpoints);
%%
figure(3)
clf
plot(dtv,Sevenday_model,'red')
hold on
plot(dtv,Aggregated_data,'blue')
grid on

axis tight
title ('Seven-Day Model and Data','FontSize',18')
ylabel ('Flow (mgd)','FontSize',18')
xlabel ('Date','FontSize',18')
legend('Seven-Day Model','Data','FontSize',18')

%% Fast Fourier Transform
%generates Spectral Density Plot of model resdiuals
[freq,PSD,Residuals]=fftest(Sevenday_model,Aggregated_data,dtv);

%%
figure(11)
clf
subplot(4,1,1)
plot(dtv, Aggregated_data,'blue','linewidth',1)
title('Data','fontsize',14)
subplot(4,1,2)
plot(dtv, Sevenday_model,'blue','linewidth',1)
title('Model','fontsize',14)
subplot(4,1,3)
plot(dtv, Sevenday_model,'red', dtv,Aggregated_data,'blue','linewidth',1)
title('Model','fontsize',14)

subplot(4,1,4)
plot(dtv(1:length(Residuals)), Residuals,'blue','linewidth',1)
title('Residuls','fontsize',14)
