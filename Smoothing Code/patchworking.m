function [patchwork, Patched_DT]=patchworking(Q,DT)

z=find(Q==0);%finding all zeros in data
row=1;
col=1;
mat(row,col)=z(1);
%making a matrix of whih cells have zeros and where each column is a new
%section of zeros in the data
for r=2:length(z)
    if z(r)<=z(r-1)+2016
        row=row+1;
        mat(row,col)=z(r);
    else
        col=col+1;%starting a new column for a new section of zeros
        row=1;
         mat(row,col)=z(r);
    end 
end

V=mat(1,:);
s=size(mat);
for q=1:s(2)
    lastzero=nnz(mat(:,q));
    Qcell=mat(lastzero,q);
    V(2,q)=Qcell;
end

B=diff(V);
weeks=ceil(B/2016);
J=V(1,:);
J(2,:)=J(1,:)+weeks(1,:).*2016;
f=reshape(J,[length(J)*2,1]);

p=1;
n=1;
for x=1:length(f)

       remove(p)=f(n);
    n=n+1 ; 
    p=p+1;  
        if n>=length(f)
            remove(p)=f(end);
            break
       end
    if f(n)>=f(n+1)
        n=n+2;
        remove(p)=f(n);
    else
        remove(p)=f(n);
    end
        p=p+1;
        n=n+1;     


end

S=reshape(remove, [2, length(remove)/2]);
y=diff(S);
P=ceil(y/2016);
sections(1,:)=S(1,:);
sections(2,:)=sections(1,:)+P.*2016;

sections(1,:)=sections(1,:)-1;

patchwork=Q(1:sections(1));
Patched_DT=DT(1:sections(1));

for t=2:length(sections)
    addition=sections(1,t)-sections(2,t-1)+1;
    patchwork(end+1:end+addition)=Q(sections(2,t-1):sections(1,t));
    Patched_DT(end+1:end+addition)=DT(sections(2,t-1):sections(1,t));
    if t==length(sections)
        addition=length(Q(sections(2,t):end));
        patchwork(end+1:end+addition)=Q(sections(2,t):end);
        Patched_DT(end+1:end+addition)=DT(sections(2,t):end);
    end
    
end

end
