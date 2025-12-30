% ca is limited action cost

%function [f,h,big_cell,POS,BND,NEG,P,B,N]=A3WDRS(data,label,stb_v,lambda_mx,ca)
function A3WDRS(data,label,stb_v,lambda_mx,ca)
tic


Source = 3;
Target = 4;

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
f = zeros(n+1,ca); % f is a benefit table
h = zeros(n+1,ca); % h is an action table

for i=2:(n+1) % the first line of benefit_table is fixed to 0.
    for k=1:(ca)

        b = 0;
        t = f(i-1,k);
        p = 0;
        
        for j=1:length(big_cell{i-1})
            action = cell2mat(big_cell{i-1}(j));
            if action.cost <= k
                benefit_f = 0;
                if k ~= action.cost
                    benefit_f = f(i-1, floor(k-action.cost));
                end
                b = benefit_f+action.benefit;
            else
                b = 0;
            end
            
            if b > t
                t = b;
                p = j;
            end
        end
        f(i,k) = t;
        h(i,k) = p;
    end
end

k = ca;
total_action_cost = 0;
for i=(n+1):-1:2
    if k <= 0
        break;
    end
    t = h(i,k);
    if t~= 0
        action = cell2mat(big_cell{i-1}(t));
        k = k - action.cost;
        total_action_cost = total_action_cost + action.cost;
        s = sprintf('execute action [%d]->[%d] (#%d action):%s,(c,b)=(%.1f,%.1f)\n',action.equc_no,action.to,t,action.transform,action.cost,action.benefit);
        disp(s);
    end
end

total_benefit = f(n+1,ca);
s = sprintf('The total benefit and action cost are %.2f and %.2f, respectively.\n',total_benefit,total_action_cost);
disp(s);

f = f(2:size(f,1),:);
h = h(2:size(h,1),:);
toc

