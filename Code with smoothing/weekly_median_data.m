function [Qnew_med,Q1_center]= weekly_median_data(Aggregated_data)

L=length(Aggregated_data);

%Transform data into a matrix with 168 columns for each one hour increment
%in a week
Row=(L-1)/168; %number of rows=number of weeks
Q=reshape(Aggregated_data(1:L-1),168,Row);
Q=detrend(Q);%detrends the columns of Q, which is each week
Q=Q.';%transpose so the columnns represent the hours (for mean/median function)

Meter=reshape(Aggregated_data(1:(L-1)),168,Row);%Non-differenced data, this will be used to get the average starting point of Sunday 6:00pm
Meter=Meter.';

Qnew_med=zeros(1,168);%empty matrix

%calculate median

for g=1:168
    Qnew_med(g)=median(Q(:,g)); %median of each hour, more accurate than the mean due to skewing by outliers 
end

%Q1_center=median(Meter(:,1));%Median is not skewed by the rain as much as the mean


% Qave=median(Q);
% Qst=std(Q);
% 
% upperbound=Qave+2*Qst;
% lowerbound=Qave-2*Qst;
% 
% 
% for g=1:168
%     
%     CD=Q(:,g);
%     CD=CD(CD<=upperbound(g));
%     CD=CD(CD>=lowerbound(g));
%     Qnew_med(g)=median(CD); %New mean of derivatives without outliers included
%     
% end

Q1_m=mean(Meter(:,1));
Q1_std=std(Meter(:,1));
z=Q1_m+Q1_std;

Q1_aver=Meter(Meter(:,1)<=z);
Q1_center=mean(Q1_aver);

end