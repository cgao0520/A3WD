function [POS,BND,NEG,P,B,N]=compute_three_regions(Part,label,alpha,beta)
POS=[];
BND=[];
NEG=[];
P=[];
B=[];
N=[];
p=1;
b=1;
n=1;
for i=1:length(Part)
    equc = cell2mat(Part(i));
    Pr = length(intersect(find(label==1),equc))/length(equc); % compute the probability of each equivalence class
    %Pr
    %if(Pr>0 & Pr<1)
    %    Pr
    %end
    if Pr >= alpha
        P{p} = equc;
        p = p+1;
        POS = [POS,equc];
    elseif Pr <= beta
        N{n} = equc;
        n = n+1;
        NEG = [NEG,equc];
    else
        B{b} = equc;
        b = b+1;
        BND = [BND,equc];
    end
end