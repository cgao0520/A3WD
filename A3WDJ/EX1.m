function EX1()

% 1. load Heart Disease Dataset
[data,label,stb_v]=LoadHeartData();%LoadHayesData();%LoadAcuteData();%LoadHeartData();

% 2. set classification cost matrix
lambda_mx=[2,3,6; 12,9,8];

% 3. take experiment on Algorithm 1
hold off
[c_list,b_list]=A3WD2_EX1(data,label,stb_v,lambda_mx,1000,1,'f','r-');
hold on
[c_list,b_list]=A3WD2_EX1(data,label,stb_v,lambda_mx,1000,1,'c','g-');

% 4. take experiment of random-select-action
hold on
[rc_list,rb_list]=A3WDARAND(data,label,stb_v,lambda_mx,1300,500);