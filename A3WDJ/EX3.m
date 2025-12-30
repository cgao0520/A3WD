function EX3()

% 1. load Heart Disease Dataset
[data,label,stb_v]=LoadHeartData();%LoadHayesData();%LoadAcuteData();

% 2. set classification cost matrix
lambda_mx=[2,3,6; 12,9,8];

% 3. take experiment on Algorithm 3 for number of objects
hold off
[c_list,b_list,ts]=A3WD3_EX1(data,label,stb_v,lambda_mx,800,1,'f','r-',1.3527);%800
hold on
[c_list,b_list,ts]=A3WD3_EX1(data,label,stb_v,lambda_mx,800,1,'c','b-',1.3527);