function [Aggregated_data,dtv]=aggregating_patcheddata(RawData,DT)
% Transform excel datetime format to discernable dates and times and truncate to the first and last Sunday 

InitialLength=length(RawData);
% find the first sunday at 6pm 
for d=1:2016
    
    first_Day(d)=weekday(DT(d));
    first_H(d)=hour(DT(d));
    first_m(d)=minute(DT(d));

    if first_Day(d)==1 & first_H(d)==18 & first_m(d)==0
        break  ;  
    end
    
end
%
% finding last sunday of 5:55pm
for y=1:2016
    
    Last_Day(y)=weekday(DT(InitialLength-y));
    Last_H(y)=hour(DT(InitialLength-y));
    Last_m(y)=minute(DT(InitialLength-y));

    if Last_Day(y)==1 & Last_H(y)==17 & Last_m(y)==55
    break;   
    end
    
end
%  Truncating data to the first and last Sunday (6pm and 5:55pm respectively)

% truncating to first sunday 6pm
nDate=DT(d:InitialLength,:);%date-time vector starting at Sunday 6pm
newLength=length(nDate);

%truncating to last sunday 5:55pm
DDate=nDate(1:newLength-y+1,1);
%truncating raw data fro first sunday 6pm to last sunday 6pm (1 more than
%time vector becuase of the differencing that will be done later on)
RawData=RawData(d:InitialLength,:);
newLength=length(RawData);
RawData=RawData(1:newLength-y,:);

a=length(RawData(:,1));

%Aggregating 5 min interval points to hours by averaging

X=1;
Y=12;
FinalLength=floor(a/12)+1;
%
%the one is added so that the difference equals some multiple of 168 for 168 hours in one week
Aggregated_data=zeros(FinalLength,1);   

% 
for p=1:length(Aggregated_data)
    if p==length(Aggregated_data)
        Aggregated_data(p)=Aggregated_data(1);
    else
        Aggregated_data(p)=mean(RawData(X:Y)); %mean aggregation of five min intervals
        X=Y+1;
        Y=Y+12;
    end
end
%%
% assigning datetime vector
b=0:FinalLength-1;
b=b.';
b=1+b*12;

dtv=DDate(b);
 

end