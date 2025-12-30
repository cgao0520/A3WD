function [data,label,stb_v]=LoadHayesData()
%{
-- 1. name: distinct for each instance and represented numerically
-- 2. hobby: nominal values ranging between 1 and 3
-- 3. age: nominal values ranging between 1 and 4
-- 4. educational level: nominal values ranging between 1 and 4
-- 5. marital status: nominal values ranging between 1 and 4
-- 6. class: nominal value between 1 and 3
%}
data=[];
label=[];
stb_v=[];
i=1;

fid=fopen('hayes-roth.txt','r');
while ~feof(fid)
   % da = fscanf(fid,'%f',1);
    da=fscanf(fid, '%d,%d,%d,%d,%d,%d', 6);
    data(i,:)=da;
    i=i+1;
end
label=data(:,6);
data=data(:,2:5);
fclose(fid);

label(find(label~=1))=-1;

stb_v=[2];