% ca is limited action cost

function [rc_list,rb_list]=A3WDARAND(data,label,stb_v,lambda_mx,cam,num)
tic


Source = 3; %BND or NEG
Target = 4; %POS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute thresholds: alpha, beta, and gamma.
[alpha,beta,gamma] = compute_ab(lambda_mx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute partition of the given data based on thresholds
Part = GetPartition(data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute three regions based on partition
[POS,BND,NEG,P,B,N] = compute_three_regions(Part,label,alpha,beta);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate Source and Target sets
SRC = GenerateSet(Source, P, B, N);
TRG = GenerateSet(Target, P, B, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate cost and benefit for every equivlance class
w=[1,1,1];
big_cell = compute_cost_benefitRS(data,label,stb_v,lambda_mx,SRC,TRG,w);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Implementation of algorithm 2
n = length(big_cell); % n is the number of actionable equivalence classes

rc_list=[];
rb_list=[];
nn=1;

while nn<=num

ca=int32(rand*cam);
x_list=randperm(n);
bene=0;
k=ca;

for i=1:n
    no = x_list(i);
    j=int32(1+rand*(length(big_cell{no})-1));
    action = cell2mat(big_cell{no}(j));
    if action.cost <= k
        bene = bene + action.benefit;
        k = k - action.cost;
        if k == 0
            break;
        end
    end
end

rc_list = [rc_list,ca];
rb_list = [rb_list,bene];
nn = nn+1;
end
hold on
plot(rc_list,rb_list,'b.');

toc

