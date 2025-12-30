function EX2()
% 1. load Heart Disease Dataset
[data,label,stb_v]=LoadHeartData();%LoadHayesData();%LoadAcuteData();%LoadHeartData();

% 2. set classification cost matrix
lambda_mx=[2,3,6; 12,9,8];

% 3. take experiment on Algorithm 2 for number of objects
[c_list,b_list,p_list,bb_list,n_list]=A3WD2_EX2(data,label,stb_v,lambda_mx,300,1,'f');%700