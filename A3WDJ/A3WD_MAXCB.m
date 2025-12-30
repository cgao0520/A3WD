% Compute the minimum total cost (i.e., maximum benefit) solution without any contraint.
% Two weights parameters w1 and w2 are defined within the program.
% Source, Target: PBN, three bits, e.g., Source=3=0b011, means Source=BND union NEG; Target=4=0b100, means Target=POS.

function [C, B] = A3WD_MAXCB(data,label,stb_v,lambda_mx,scale)
tic

if nargin == 4
    scale=1;
end

Source = 3; %BND or NEG
Target = 4; %POS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute thresholds: alpha, beta, and gamma.
[alpha,beta,gamma] = compute_ab(lambda_mx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute partition of the given data based on thresholds
Part=GetPartition(data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute three regions based on partition
[POS,BND,NEG,P,B,N]=compute_three_regions(Part,label,alpha,beta);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate Source and Target sets
SRC = GenerateSet(Source, P, B, N);
TRG = GenerateSet(Target, P, B, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate cost and benefit for every equivlance class
w=[1,1,1];
big_cell=compute_cost_benefitRS(data,label,stb_v,lambda_mx,SRC,TRG,w,scale);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Implementation of algorithm 1
total_benefit = 0;
total_action_cost = 0;
for i=1:length(big_cell)
    max_bene = 0;
    act_cost = 0;
    action_no = -1;
    for j=1:length(big_cell{i})
        action = cell2mat(big_cell{i}(j));
        if action.benefit > max_bene | action.benefit == max_bene & action.cost<act_cost
            max_bene = action.benefit;
            act_cost = action.cost;
            action_no = j;
        end
    end
    s = sprintf('execute action [%d]->[%d] (#%d action):%s,(c,b)=(%.1f,%.1f)\n',action.equc_no,action.to,action_no,action.transform,action.cost,action.benefit);
    %disp(s);
    total_benefit = total_benefit + max_bene;
    total_action_cost = total_action_cost + act_cost;
end

C = total_action_cost;
B = total_benefit;
s = sprintf('The total benefit and action cost are %.2f and %.2f, respectively.\n',total_benefit,total_action_cost);
disp(s);

toc

