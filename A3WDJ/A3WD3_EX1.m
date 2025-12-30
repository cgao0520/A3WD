%A3WDAG2-EX1 is an experiments on Algorithm 1
%This experiment compares the performances between Algorithm 1 and
%random-selection method
%Parameters:
% data,label, and stb_v: data, label, and stable attributes
% lambda_mx: classification cost matrix
% blm: the maximum desired benefit
% c_step: step for drawing the line (used in inferring the corresponding benefit)
% ForC: use floor or ceil, 'f' use floor, otherwise ceil
% style: the style to draw line

function [c_list,b_list,ts]=A3WD3_EX1(data,label,stb_v,lambda_mx,blm,c_step,ForC,style,scale)
tic

if nargin == 8
    scale=1;
end

[C, B] = A3WD_MAXCB(data,label,stb_v,lambda_mx,scale);

ca = ceil(C); % always use ceil()

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
big_cell = compute_cost_benefitRS(data,label,stb_v,lambda_mx,SRC,TRG,w,scale);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Implementation of algorithm 2
n = length(big_cell); % n is the number of actionable equivalence classes

c_list=[];
b_list=[];

f = zeros(n+1,ca); % f is a benefit table
h = zeros(n+1,ca); % h is an action table

for k=1:(ca)
    for i=2:(n+1) % the first line of benefit_table is fixed to 0.

        b = 0;
        t = f(i-1,k);
        p = 0;
        
        for j=1:length(big_cell{i-1})
            action = cell2mat(big_cell{i-1}(j));
            if action.cost <= k
                benefit_f = 0;
                if k ~= action.cost
                    if ForC=='f'
                        temp = floor(k-action.cost);
                    else
                        temp = ceil(k-action.cost);
                    end
                    
                    if temp == 0
                        benefit_f = 0;
                    else
                        benefit_f = f(i-1, temp);
                    end
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
    if f(i,k) >= blm
        break;
    end
end

cc = k;
while cc >= 0
    k = cc;
    total_action_cost = 0;
    for i=(n+1):-1:2
        if k <= 0
            break;
        end
        t = h(i,k);
        if t ~= 0
            action = cell2mat(big_cell{i-1}(t));
            
            %if ForC=='f'
            %    k = floor(k - action.cost);
            %else
                k = ceil(k - action.cost);
            %end
            
            total_action_cost = total_action_cost + action.cost;
            s = sprintf('execute action [%d]->[%d] (#%d action):%s,(c,b)=(%.1f,%.1f)\n',action.equc_no,action.to,t,action.transform,action.cost,action.benefit);
            %disp(s);
        end
    end

    total_benefit=0;
    if cc~=0
        total_benefit = f(n+1,cc);
    end
    s = sprintf('The total benefit and action cost are %.2f and %.2f, respectively.\n',total_benefit,total_action_cost);
    disp(s);
    
    c_list = [c_list,total_action_cost];
    b_list = [b_list,total_benefit];

    cc = cc - c_step;
end

f = f(2:size(f,1),:);
h = h(2:size(h,1),:);

%hold off
plot(b_list,c_list,style);

ts = toc

