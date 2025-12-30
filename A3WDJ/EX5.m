function [bl_list, ts_list] = EX5()
tic

ts_list = [];

style = {'rd-','r^-','rs-','ro-'};

scale = [1,2,3,4];
blm = 800;

% 1. Load data
[data,label,stb_v]=LoadHeartData();%LoadHayesData();%LoadAcuteData();%LoadHeartData();

% 2. set classification cost matrix
lambda_mx=[2,3,6; 12,9,8];

% 3. execute algorithm 3 and 4
ts4 = [];
hold off
for i = 1:length(scale)
    scl = scale(i)%;
    ts3 = [];
    bl_list = [];
    for bl = 0:20:blm
        bl
        % algorithm 3
        [cost,bene,ts] = A3WD3(data,label,stb_v,lambda_mx,bl,'f',scl);
        ts3 = [ts3, ts];
        % algorithm 4
        if scl==1
            [bene,cost,ts]=A3WD4(data,label,stb_v,lambda_mx,bl,scl);
            ts4 = [ts4, ts];
        end

        bl_list = [bl_list, bl];
    end
    hold on
    plot(bl_list, ts3, style{i});
    ts_list = [ts_list, ts3];
end
hold on
plot(bl_list, ts4, 'b*-');
ts_list = [ts4, ts_list];
toc