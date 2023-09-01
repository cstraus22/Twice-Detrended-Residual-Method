function [freq,PSD1,DPSD1,Residuals]=fftest(Sevenday_model,Aggregated_data,dtv)
N=length(Aggregated_data)-1;
Aggregated_data=Aggregated_data.';

%DATA=DATA.';
Residuals=Aggregated_data(1:N)-Sevenday_model(1:N);

% figure(6)
% clf
% plot(dtv(1:N),Residuals,'r')
% hold on
% plot (dtv(1:N),Aggregated_data(1:N),'b')
% hold off
% title ('Data and Residuals LM-LD-027 monitor and competition ','FontSize',18)
% legend ('Residual' ,'Data','FontSize',18)
% ylabel ('Flow (mgd)','FontSize',18)
% xlabel ('Date','FontSize',18)

%%
%look for patterns in a single week, so time unit is 1 week
Fs=672;%sampling frequency: 672 samples in a single time unit (672 hours/month)
T=1/Fs; %period of sampling frequency

fhat=fft(Residuals(1:N));%fourier transform (includes complex numbers)
PSD2=abs(fhat/N);%two sided power spectrum
PSD1=PSD2(1:N/2+1);
PSD1(2:end-1)=2*PSD1(2:end-1);%one side of power spectrum

freq=Fs*(0:floor(N/2))/N;%sampling frequency is the same as the data length

%% Overlap
Dfhat=fft(Aggregated_data(1:N));%fourier transform (includes complex numbers)
DPSD2=abs(Dfhat/N);%two sided power spectrum
DPSD1=DPSD2(1:N/2+1);
DPSD1(2:end-1)=2*DPSD1(2:end-1);%one side of power spectrum

%%
%a signal at 28 represents daily (since 1 week=7 days and 7 days*4=28)
% % %a signal at 56 is a 12 hour signal
% figure(7)
% clf
% plot(freq,PSD1,'b','linewidth',1)
% set(gca,'FontSize',15)
% title ('Barton Residuals','FontSize',18')
% xlabel('Frequency (cycles per month)','FontSize',18')
% ylabel('Power','FontSize',18')
% %%
% figure(8)
% clf
% plot(freq, DPSD1,'b','linewidth',1)
% set(gca,'FontSize',15)
% title ('Data FFT','FontSize',18')
% xlabel('Frequency (cycles per month)','FontSize',18')
% ylabel('Power','FontSize',18')

%%
% 
% mfhat=fft(Sevenday_model(1:N));%fourier transform (includes complex numbers)
% mPSD2=abs(mfhat/N);%two sided power spectrum
% mPSD1=mPSD2(1:N/2+1);
% mPSD1(2:end-1)=2*mPSD1(2:end-1);%
% 
% figure(9)
% clf
% a=subplot(3,1,1)
% plot(freq,mPSD1,'b','linewidth',1.5)
% set(gca,'FontSize',15)
% title ('Barton Model','FontSize',18')
% xlabel('Frequency (cycles per month)','FontSize',12)
% ylabel('Power','FontSize',18')
% grid on

% b=subplot(3,1,2)
% plot(freq,DPSD1,'b','linewidth',1.5)
% set(gca,'FontSize',15)
% title ('Data','FontSize',18)
% xlabel('Frequency (cycles per month)','FontSize',12)
% ylabel('Power','FontSize',18')
% grid on
% 
% c=subplot(3,1,3)
% plot(freq,PSD1,'b','linewidth',1.5)
% set(gca,'FontSize',15)
% title ('Barton Resdiuals','FontSize',18)
% xlabel('Frequency (cycles per month)','FontSize',12)
% ylabel('Power','FontSize',18')
% grid on
% 
% linkaxes([a,b,c])
end