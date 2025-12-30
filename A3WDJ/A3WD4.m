% bl is least benefit to be obtain

function [bene,cost,ts]=A3WD4(data,label,stb_v,lambda_mx,bl,scale)
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
big_cell = compute_cost_benefitRS(data,label,stb_v,lambda_mx,SRC,TRG,w,scale);


%computeBeneCost(big_cell,bl);

%return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Implementation of algorithm 4
n = length(big_cell); % n is the number of actionable equivalence classes
g = zeros(n+1,bl); % g is a cost table
h = zeros(n+1,bl); % h is an action table
l = zeros(n+1,bl); % l is a benefit table

g(1,:)=inf;

for i=2:(n+1) % the first line of benefit_table is fixed to 0.

    for k=1:bl

        c = g(i-1,k);        % cost
        b = l(i-1,k);          % benefit
        %t = g(i-1,k);
        p = 0;
        %q = 0;
        
        for j=1:length(big_cell{i-1})
            action = cell2mat(big_cell{i-1}(j));
            if action.benefit <= k
                if action.benefit < k
                    cost_g = g(i-1,ceil(k-action.benefit));
                    bene_l = l(i-1,ceil(k-action.benefit));
                else
                    cost_g = 0;
                    bene_l = 0;
                end
                cc = cost_g + action.cost;
                bb = bene_l + action.benefit;
            else
                cc = action.cost;
                bb = action.benefit;
            end
            
            if (cc < c) | (cc == c & bb > b)
                c = cc;
                b = bb;
                p = j;
            end
        end
        g(i,k) = c;
        h(i,k) = p;
        l(i,k) = b;
    end
end


k = bl;
total_action_cost = 0;
for i=(n+1):-1:2
    if k <= 0
        break;
    end
    t = h(i,k);
    if t~= 0
        action = cell2mat(big_cell{i-1}(t));
        k = ceil(k - action.benefit);
        total_action_cost = total_action_cost + action.cost;
        s = sprintf('execute action [%d]->[%d] (#%d action):%s,(c,b)=(%.1f,%.1f)\n',action.equc_no,action.to,t,action.transform,action.cost,action.benefit);
        %disp(s);
    end
end

total_benefit=0;
if bl~=0
    total_benefit = l(n+1,bl);
end

s = sprintf('The total benefit and action cost are %.2f and %.2f, respectively.\n',total_benefit,total_action_cost);
%disp(s);

bene = total_benefit;
cost = total_action_cost;

%{
g = g(2:size(g,1),:);
h = h(2:size(h,1),:);
l = l(2:size(l,1),:);
%}

ts = toc;

