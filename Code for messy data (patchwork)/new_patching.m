
z=find(Q==0);
g=z;
patched(1:g(1))=Q(1:g(1));
Patched_DT(1:g(1))=DT(1:g(1));

for m=1:length(g)
    remove=g(1)+2016;
    L=length(patched);
    patched(end+1:end+(length(Q)-remove+1))=Q(remove:end);
    Patched_DT(end+1:end+(length(Q)-remove+1))=DT(remove:end);
    g=find(patched==0);
    K=isempty(g);
    if K==1
      break;  
    end
end





% locations_of_nonones=find(g~=1);
%lengthof_zero_sections(1)=locations_of_nonones(1);
% lengthof_zero_sections(2:length(locations_of_nonzeros))=diff(locations_of_nonones);
% 
% 
% nonzero_sectionlength=[length(locations_of_nonones),1];
% nonzero_sectionlength(1)=g(locations_of_nonones(1));
% weeks_to_remove(1)=ceil(nonzero_sectionlength(1)/2016);
% 
% 
% for w=2:length(locations_of_nonones)
%     
%     nonzero_sectionlength(w)=g(locations_of_nonones(w));
%     weeks_to_remove(w)=ceiling(lengthof_zero_sections(w)/2016);
% end
% r=1;
% c=1;
% 
% for R=2:length(locations_of_nonones)
%     if (weeks_to_remove(R-1)*2016)>= nonzero_sectionlength(R)
%       mat(r,c)  
%     end
% end