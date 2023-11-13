function [Qnew_med,Q1_center]= weekly_differencing_Mediandata(Aggregated_data)
%differencing of data
L=length(Aggregated_data);
QDerivative=diff(Aggregated_data);%differencing=approximate derivative

%Transform data into a matrix with 168 columns for each one hour increment
%in a week
Row=(L-1)/168; %number of rows=number of weeks
Q=reshape(QDerivative,168,Row);
Q=detrend(Q);%detrends the columns of Q; columns currently represent the weeks
Q=Q.';%transpose so the columnns represent the hours (for mean/median function)

Meter=reshape(Aggregated_data(1:(L-1)),168,Row);%Non-differenced data, this will be used to get the average starting point of Sunday 6:00pm
Meter=Meter.';

Qnew_med=zeros(1,168);

%calculate median

for g=1:168
    Qnew_med(g)=median(Q(:,g)); %median of each hour   
end

%expected value of position 1; Sunday 6:00pm
%calculation average starting position

%Q1_center=min(Meter(:,1));%switched to lowest measurement, assumption is that this is the true water use in dry weather flow

Q1_m=mean(Meter(:,1));
Q1_std=std(Meter(:,1));
z=Q1_m+3*Q1_std;

Q1_aver=Meter(Meter(:,1)<=z);
Q1_center=mean(Q1_aver);




end