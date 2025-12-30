%Get the Partition from information table X
%Arguments:
%   X: information table
%Return values:
%   P: partition
function [P] = GetPartition(X)
[r,c]=size(X);
if r==0 || c==0
    P{1}=[];
    return;
end
ze=zeros(1,c)-99999.1234321;
XX = X;
k=1;
for i=1:r
    x = XX(i,:);
    if compvec(x,ze) == 0
        Part=[];
        Part=[Part,i];
        XX(i,:)=ze;
        for j=i+1:r
            y = XX(j,:);
            if compvec(x,ze) == 0 && compvec(x,y)==1
                Part=[Part,j];
                XX(j,:)=ze;
            end
        end
        P{k}=Part;
        k=k+1;
    end
end

%Compare two vectors
%Arguments:
%   two vectors
%Return values:
%   val: 1 if they are equal, 0 otherwise
function val = compvec(x,y)
l1 = length(x);
l2 = length(y);
if l1 ~= l2
    val = 0;
    return;
end
for i=1:l1
    if x(i) ~= y(i)
        val = 0;
        return;
    end
end
val = 1;