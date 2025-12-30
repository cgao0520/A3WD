
function [data,label,stb_v]=LoadAcuteData()
data=[];
label=[];
stb_v=[];
i=1;

%{
-- Attribute lines: 
For example, '35,9	no	no	yes	yes	yes	yes	no' 
Where: 
'35,9'	Temperature of patient 
'no'	Occurrence of nausea 
'no'	Lumbar pain 
'yes'	Urine pushing (continuous need for urination) 
'yes'	Micturition pains 
'yes'	Burning of urethra, itch, swelling of urethra outlet 
'yes'	decision: Inflammation of urinary bladder 
'no'	decision: Nephritis of renal pelvis origin


Attribute Information:

a1	Temperature of patient { 35C-42C }	
a2	Occurrence of nausea { yes, no }	
a3	Lumbar pain { yes, no }	
a4	Urine pushing (continuous need for urination) { yes, no }	
a5	Micturition pains { yes, no }	
a6	Burning of urethra, itch, swelling of urethra outlet { yes, no }	
d1	decision: Inflammation of urinary bladder { yes, no }	
d2	decision: Nephritis of renal pelvis origin { yes, no }
%}

fid=fopen('acute.txt','r');
while ~feof(fid)
   % da = fscanf(fid,'%f',1);
    da=fscanf(fid, '%f,%d,%d,%d,%d,%d,%d,%d', 8);
    data(i,:)=da;
    i=i+1;
end
label=data(:,7:8);
data=data(:,1:6);
fclose(fid);


%1. group temperature, according to: % age group source:https://www.heart.org/idc/groups/heart-public/@wcm/@sop/@smd/documents/downloadable/ucm_449846.pdf
data(find(data(:,1)<36.6),1)=1; % group 1: low fever
data(find(data(:,1)>=36.6 & data(:,1)<=37.3),1)=2; % group 2: normal
data(find(data(:,1)>37.3),1)=3; % group 3: fever

lab=[];
for i=1:size(label,1)
    lab(i)=label(i,1)||label(i,2);
    if lab(i)==0
        lab(i)=1;  % healthy
    else
        lab(i)=-1; % has one or two inflammations
    end
end
label=lab;


