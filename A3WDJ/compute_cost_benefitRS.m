%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate cost and benefit cell for each equivalence class
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cost_bene_cell=compute_cost_benefitRS(data,label,stb_v,lambda_mx,SRC,TRG,w,scale)

if nargin == 7
    scale=1;
end

cost_bene_cell = [];

kk = 1;
for i=1:length(SRC)
    k=1;
    equc_cell=[];
    src_equc = cell2mat(SRC(i));
    x = src_equc.equc(1);
    for j=1:length(TRG)
        targ_equc = cell2mat(TRG(j));
        y = targ_equc.equc(1);
        bflag = actionable(data(x,:),data(y,:),stb_v);
        if bflag % yes,it is actionable
            cost = compute_action_cost(data(x,:),length(src_equc.equc),data(y,:),stb_v,scale);
            bene = compute_action_benefit(cost,lambda_mx,label,src_equc,targ_equc,w);
            if bene > 0
                trans=sprintf('%s->%s', src_equc.region, targ_equc.region);
                action = struct('equc_no',x,'to',y,'num_obj',length(src_equc.equc),'cost', cost, 'benefit', bene, 'transform',trans);
                equc_cell{k} = action;
                k = k+1;
            end
        end
    end
    if length(equc_cell) > 0
        cost_bene_cell{kk} = equc_cell;
        kk = kk+1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Check whether an action is actionable
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res = actionable(x,y,stb_v)
res = 0;
%{
len = length(stb_v);
for i=1:len
    if x(stb_v(i)) ~= y(stb_v(i))
        res = 0;
        return;
    end
end
%}
if length(stb_v)==0 | x(stb_v) == y(stb_v)
    res = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Compute an action's benefit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bene = compute_action_benefit(action_cost,lambda_mx,label,src_equc,targ_equc,w)
bene=-inf;

PP = find(label==1);
a = length(intersect(src_equc.equc,PP));
b = length(src_equc.equc) * length(intersect(targ_equc.equc,PP))/length(targ_equc.equc);
c = length(src_equc.equc);

if src_equc.region=='NEG' & targ_equc.region=='POS' % NEG->POS, V->W
    ww = w(1);
    wv = w(3);
    lmd_wp = lambda_mx(1,1);
    lmd_wn = lambda_mx(2,1);
    lmd_vp = lambda_mx(1,3);
    lmd_vn = lambda_mx(2,3);
elseif src_equc.region=='BND' & targ_equc.region=='POS' % BND->POS
    ww = w(1);
    wv = w(2);
    lmd_wp = lambda_mx(1,1);
    lmd_wn = lambda_mx(2,1);
    lmd_vp = lambda_mx(1,2);
    lmd_vn = lambda_mx(2,2);    
elseif src_equc.region=='NEG' & targ_equc.region=='BND' % NEG->BND
    ww = w(2);
    wv = w(3);
    lmd_wp = lambda_mx(1,2);
    lmd_wn = lambda_mx(2,2);
    lmd_vp = lambda_mx(1,3);
    lmd_vn = lambda_mx(2,3);    
elseif src_equc.region=='POS' & targ_equc.region=='POS' % POS->POS
    ww = w(1);
    wv = w(1);
    lmd_wp = lambda_mx(1,1);
    lmd_wn = lambda_mx(2,1);
    lmd_vp = lambda_mx(1,1);
    lmd_vn = lambda_mx(2,1);    
elseif src_equc.region=='BND' & targ_equc.region=='BND' % BND->BND
    ww = w(2);
    wv = w(2);
    lmd_wp = lambda_mx(1,2);
    lmd_wn = lambda_mx(2,2);
    lmd_vp = lambda_mx(1,2);
    lmd_vn = lambda_mx(2,2);    
elseif src_equc.region=='NEG' & targ_equc.region=='NEG' % NEG->NEG
    ww = w(3);
    wv = w(3);
    lmd_wp = lambda_mx(1,3);
    lmd_wn = lambda_mx(2,3);
    lmd_vp = lambda_mx(1,3);
    lmd_vn = lambda_mx(2,3);
elseif src_equc.region=='POS' & targ_equc.region=='BND' % POS->BND
    ww = w(2);
    wv = w(1);
    lmd_wp = lambda_mx(1,2);
    lmd_wn = lambda_mx(2,2);
    lmd_vp = lambda_mx(1,1);
    lmd_vn = lambda_mx(2,1);
elseif src_equc.region=='POS' & targ_equc.region=='NEG' % POS->NEG
    ww = w(3);
    wv = w(1);
    lmd_wp = lambda_mx(1,3);
    lmd_wn = lambda_mx(2,3);
    lmd_vp = lambda_mx(1,1);
    lmd_vn = lambda_mx(2,1);
elseif src_equc.region=='BND' & targ_equc.region=='NEG' % BND->NEG
    ww = w(3);
    wv = w(2);
    lmd_wp = lambda_mx(1,3);
    lmd_wn = lambda_mx(2,3);
    lmd_vp = lambda_mx(1,2);
    lmd_vn = lambda_mx(2,2);
end

bene = ww*(-b*lmd_wp-(c-b)*lmd_wn)+wv*(a*lmd_vp+(c-a)*lmd_vn);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Compute an action's cost
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cost = compute_action_cost(x,num_of_object,y,stb_v,scale)
cost = 0;

for i=1:length(x)
    if length(find(stb_v == i)) > 0 %the ith attribute is stable
        continue;
    else
        cost = cost + abs(x(i)-y(i));
    end
end
cost = cost*num_of_object*scale;%*1.3527;

