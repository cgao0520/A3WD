function EX4()

% 1. load Heart Disease Dataset
[data,label,stb_v]=LoadHayesData();%LoadAcuteData();%LoadHeartData();

% 2. set classification cost matrix
lambda_mx=[2,3,6; 12,9,8];

% 3. take experiment on Algorithm 4 for number of objects
[bene_list,cost_list,rbene_list,ts]=A3WD4_EX1(data,label,stb_v,lambda_mx,800,1);