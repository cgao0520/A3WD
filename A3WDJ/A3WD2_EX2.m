% ca is limited action cost

function [c_list,b_list,p_list,bb_list,n_list]=A3WD2_EX2(data,label,stb_v,lambda_mx,ca,c_step,ForC)
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

num_POS = length(POS);
num_BND = length(BND);
num_NEG = length(NEG);

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

c_list=[];
b_list=[];

p_list=[];
bb_list=[];
n_list=[];
pb_list = [];
    
num_POS = length(POS);
num_BND = length(BND);
num_NEG = length(NEG);

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
end

cc = ca;
while cc >= 0
    num_POS = length(POS);
    num_BND = length(BND);
    num_NEG = length(NEG);

    k = cc;
    total_action_cost = 0;
    for i=(n+1):-1:2
        if k <= 0
            break;
        end
        t = h(i,k);
        if t~= 0
            action = cell2mat(big_cell{i-1}(t));
            k = floor(k - action.cost); % ceil has the same result
            total_action_cost = total_action_cost + action.cost;
            s = sprintf('execute action [%d]->[%d] (#%d action):%s,(c,b)=(%.1f,%.1f)\n',action.equc_no,action.to,t,action.transform,action.cost,action.benefit);
            %disp(s);
            pattern=action.transform;
            src_region = pattern(1:3);
            trg_region = pattern(6:8);
            if src_region == 'NEG'
                num_NEG = num_NEG - action.num_obj;
            elseif src_region == 'BND'
                num_BND = num_BND - action.num_obj;
            else
                num_POS = num_POS - action.num_obj;
            end
            if trg_region == 'NEG'
                num_NEG = num_NEG + action.num_obj;
            elseif trg_region == 'BND'
                num_BND = num_BND + action.num_obj;
            else
                num_POS = num_POS + action.num_obj;
            end        
        end
    end

    total_benefit=0;
    if cc~=0
        total_benefit = f(n+1,cc);
    end
    %s = sprintf('The total benefit and action cost are %.2f and %.2f, respectively.\n',total_benefit,total_action_cost);
    s = sprintf('cost=%d, numbers of POS, BND, and NEG are: %d, %d, %d.', cc, num_POS, num_BND, num_NEG);
    disp(s);

    c_list = [c_list,cc];
    b_list = [b_list,total_benefit];

    p_list = [p_list,num_POS];
    n_list = [n_list,num_NEG];
    bb_list = [bb_list,num_BND];
    pb_list = [pb_list, num_POS+num_BND];

    cc = cc - c_step;
end

f = f(2:size(f,1),:);
h = h(2:size(h,1),:);

hold off
plot(c_list,p_list,'k-');
%hold on 
%plot(c_list,bb_list,'b-.');
%hold on
%plot(c_list,n_list,'r-');

hold on 
plot(c_list,pb_list,'b-');

toc

