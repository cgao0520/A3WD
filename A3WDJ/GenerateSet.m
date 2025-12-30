%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Generate Source and Target
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RES = GenerateSet(flags, P, B, N)
RES = [];

if flags == 1 % NEG
    for i=1:length(N)
        RES{i} = struct('region','NEG','equc',cell2mat(N(i)));
    end
elseif flags == 2 % BND
    for i=1:length(B)
        RES{i} = struct('region','BND','equc',cell2mat(B(i)));
    end
elseif flags == 3 % BND and NEG
    for i=1:length(B)
        RES{i} = struct('region','BND','equc',cell2mat(B(i)));
    end
	ind=length(RES)+1;
	for i=1:length(N)
		RES{ind}=struct('region','NEG','equc',cell2mat(N(i)));
		ind = ind + 1;
	end
elseif flags == 4 % POS
	for i=1:length(P)
        RES{i} = struct('region','POS','equc',cell2mat(P(i)));
    end
elseif flags == 5 % POS and NEG
    for i=1:length(P)
        RES{i} = struct('region','POS','equc',cell2mat(P(i)));
    end
	ind=length(RES)+1;
	for i=1:length(N)
		RES{ind}=struct('region','NEG','equc',cell2mat(N(i)));
		ind = ind + 1;
	end
elseif flags == 6 % POS and BND
	for i=1:length(P)
        RES{i} = struct('region','POS','equc',cell2mat(P(i)));
    end
	ind=length(RES)+1;
	for i=1:length(B)
		RES{ind} = struct('region','BND','equc',cell2mat(B(i)));
		ind = ind + 1;
	end
elseif flags == 7 % POS and BND and NEG
    for i=1:length(P)
        RES{i} = struct('region','POS','equc',cell2mat(P(i)));
    end	
    
	ind=length(RES)+1;
	for i=1:length(B)
		RES{ind} = struct('region','BND','equc',cell2mat(B(i)));
		ind = ind + 1;
    end
    
    ind=length(RES)+1;
	for i=1:length(N)
		RES{ind} = struct('region','NEG','equc',cell2mat(N(i)));
		ind = ind + 1;
    end
end

