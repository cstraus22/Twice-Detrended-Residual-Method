function [Sevenday_Model]=Model_generation(Qnew_med,Q1_center,forecastpoints)

L=forecastpoints;%number of points to forecast
Sevenday_Model=zeros(1,L);
Sevenday_Model(1)=Q1_center;%assigning the starting point

j=(L-1)/168;

s=1;
f=24;
%detrend each day so the start and end of the day is the same
for n=1:7%7 days in one week
 DailyDetrend_Qnew_med(s:f)= detrend(Qnew_med(s:f));%detrending 24 hours so that changes in the day always return to the start
 s=s+24;f=f+24;
end

Qnew_ave_rep=repmat(DailyDetrend_Qnew_med,1,j);%repeats the average changes in flow for length of data

for c=1:L-1
Sevenday_Model(c+1)=Sevenday_Model(c)+Qnew_ave_rep(c);%generating model by adding consecutive derivatives
end

end