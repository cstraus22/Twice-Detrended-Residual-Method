function [Aggregated_data,dtv]=aggregating_data(loessmf13,Patched_DT)
% Transform excel datetime format to discernable dates and times and truncate to the first and last Sunday 
% [Filename, Pathname]=uigetfile('.xlsx');%USe for APP
% RawData=xlsread(strcat(Pathname,Filename),'');

InitialLength=length(loessmf13);

%DT=datetime(RawData(:,1),'ConvertFrom','excel');

% find the first sunday at 6pm 
for d=1:2016
    
    first_Day(d)=weekday(Patched_DT(d));
    first_H(d)=hour(Patched_DT(d));
    first_m(d)=minute(Patched_DT(d));

    if first_Day(d)==1 & first_H(d)==18 & first_m(d)==0
        break  ;  
    end
    
end

% finding last sunday of 5:55pm
for y=1:2016
    
    Last_Day(y)=weekday(Patched_DT(InitialLength-y));
    Last_H(y)=hour(Patched_DT(InitialLength-y));
    Last_m(y)=minute(Patched_DT(InitialLength-y));

    if Last_Day(y)==1 & Last_H(y)==17 & Last_m(y)==55
    break;   
    end
    
end
%  Truncating data to the first and last Sunday (6pm and 5:55pm respectively)

% truncating to first sunday 6pm
nDate=Patched_DT(d:InitialLength,:);%date-time vector starting at Sunday 6pm
newLength=length(nDate);

%truncating to last sunday 5:55pm
DDate=nDate(1:newLength-y+1,1);
%truncating raw data
R1=loessmf13(d:InitialLength,:);
newLength=length(R1);
R2=R1(1:newLength-y,:);

a=length(R2(:,1));

%%
%Aggregating 5 min interval points to hours by averaging

X=1;
Y=12;
FinalLength=(a/12)+1;%the one is added so that the difference equals some multiple of 168 for 168 hours in one week
Aggregated_data=zeros(FinalLength,1);   

 %%
for p=1:length(Aggregated_data)
    if p==length(Aggregated_data)
        Aggregated_data(p)=Aggregated_data(1);
    else
        Aggregated_data(p)=mean(R2(X:Y)); %mean aggregation of five min intervals
        X=Y+1;
        Y=Y+12;
    end
end

% assigning datetime vector
b=0:FinalLength-1;
b=b.';
b=1+b*12;

dtv=DDate(b);
 

end