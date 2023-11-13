function [Sevenday_Model]=Model_generation_nondiff(Qnew_med,Q1_center,forecastpoints)

L=forecastpoints;%number of points to forecast
j=(L-1)/168;

s=1;
f=24;
%detrend each day so the start and end of the day is the same
for n=1:7%7 days in one week
 DailyDetrend_Qnew_med(s:f)= detrend(Qnew_med(s:f));%detrending 24 hours so that changes in the day always return to the start
 s=s+24;f=f+24;
end

Sevenday_modelw1=DailyDetrend_Qnew_med+Q1_center;
Sevenday_Model=repmat(Sevenday_modelw1,1,j);%repeats the average changes in flow for length of data

end