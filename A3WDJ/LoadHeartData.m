% age group source:https://www.heart.org/idc/groups/heart-public/@wcm/@sop/@smd/documents/downloadable/ucm_449846.pdf

function [data,label,stb_v]=LoadHeartData()
data=[];
label=[];
i=1;
fid=fopen('heart_c.txt','r');

%{
Only 14 attributes used: 
(1). #3 age: age in years 
2. #4 sex: sex (1 = male; 0 = female)
3. #9 cp: chest pain type 
-- Value 1: typical angina 
-- Value 2: atypical angina 
-- Value 3: non-anginal pain 
-- Value 4: asymptomatic 
(4). #10 trestbps: resting blood pressure (in mm Hg on admission to the hospital) 
(5). #12 chol: serum cholestoral in mg/dl 
6. #16 fbs: (fasting blood sugar > 120 mg/dl) (1 = true; 0 = false) 
7. #19 restecg: resting electrocardiographic results 
-- Value 0: normal 
-- Value 1: having ST-T wave abnormality (T wave inversions and/or ST elevation or depression of > 0.05 mV) 
-- Value 2: showing probable or definite left ventricular hypertrophy by Estes' criteria 
(8). #32 thalach: maximum heart rate achieved 
9. #38 exang: exercise induced angina (1 = yes; 0 = no) 
(10). #40 oldpeak = ST depression induced by exercise relative to rest 
11. #41 slope: the slope of the peak exercise ST segment 
-- Value 1: upsloping 
-- Value 2: flat 
-- Value 3: downsloping 
12. #44 ca: number of major vessels (0-3) colored by flourosopy 
13. #51 thal: 3 = normal; 6 = fixed defect; 7 = reversable defect
14. #58 num: diagnosis of heart disease (angiographic disease status) 
-- Value 0: < 50% diameter narrowing 
-- Value 1: > 50% diameter narrowing 
%}

while ~feof(fid)
    da=fscanf(fid, '%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%d', 14);
    data(i,:)=da;
    i=i+1;
end
label=data(:,14);
data=data(:,1:13);
fclose(fid);

%All missing values are filled with most often appeared values.
for i=1:size(data,2)
    if length(find(data(:,i)==-999.0)) > 0
        v=unique(data(:,i));
        n=0;
        va=-999;
        for j=1:length(v)
            t=length(find(data(:,i)==v(j)));
            if n<t
                n=t;
                va=v(j);
            end
        end
        data(find(data(:,i)==-999.0),i)=va;
    end
end

%1. group age, according to: % age group source:https://www.heart.org/idc/groups/heart-public/@wcm/@sop/@smd/documents/downloadable/ucm_449846.pdf
%%{
data(find(data(:,1)<20),1)=1; % group 1: (0,20]
data(find(data(:,1)>=20 & data(:,1)<=39),1)=2; % group 2: [20,39]
data(find(data(:,1)>=40 & data(:,1)<=59),1)=3; % group 3: [40,59]
data(find(data(:,1)>=60 & data(:,1)<=79),1)=4; % group 4: [60,79]
data(find(data(:,1)>=80),1)=5; % group 5: [80,+inf)
%%}
%{
data(find(data(:,1)<20),1)=1; % group 1: (0,20]
data(find(data(:,1)>=20 & data(:,1)<=60),1)=4; % group 4: [60,79]
data(find(data(:,1)>=60),1)=5; % group 5: [80,+inf)
%}

%2. group cholesterol, according to: https://www.goredforwomen.org/know-your-risk/factors-that-increase-your-risk-for-heart-disease/cholesterol-heart-disease/
data(find(data(:,5)<200),5)=1;   % group 1: lower risk
data(find(data(:,5)>=200 & data(:,5)<=239),5)=2;  % group 2: considered borderline high
data(find(data(:,5)>=240),5)=3;   % group 3: High blood cholesterol. A person with this level has more than twice the risk of heart disease.

%3. group (adult) blood pressure, according to: "Understanding blood pressure readings". American Heart Association. 11 January 2011. Retrieved 30 March 2011.
%{
data(find(data(:,4)<90),4)=1;  % group 1: hypotension
data(find(data(:,4)>=90 & data(:,4)<=119),4)=2;  % group 2: desired
data(find(data(:,4)>=120 & data(:,4)<=139),4)=3;  % group 3: Prehypertension
data(find(data(:,4)>=140 & data(:,4)<=159),4)=4;  % group 4: Stage 1 hypertension
data(find(data(:,4)>=160 & data(:,4)<=179),4)=5;  % group 5: Stage 2 hypertension
data(find(data(:,4)>=180),4)=6;  % group 6: Hypertensive urgency
%}
data(find(data(:,4)<90),4)=1;  % group 1: hypotension
data(find(data(:,4)>=90 & data(:,4)<=139),4)=2;  % group 3: Prehypertension
data(find(data(:,4)>=140),4)=3;  % group 6: Hypertensive urgency


%4. group Maximum heart rate, according to: (1) http://www.heart.org/HEARTORG/HealthyLiving/PhysicalActivity/FitnessBasics/Target-Heart-Rates_UCM_434341_Article.jsp#.V-3UyhT5fOw
% and (2) the age grouping, i.e., group the values in first link by every
% 20 years. That is each maximum heart rate group has 20 values.
%{
data(find(data(:,8)<150),8)=1;  % group 1, commonly elders
data(find(data(:,8)>=150 & data(:,8)<=169),8)=2;  % group 2
data(find(data(:,8)>=170 & data(:,8)<=189),8)=3;  % group 3
data(find(data(:,8)>=190 & data(:,8)<=209),8)=4;  % group 4
data(find(data(:,8)>=210),8)=5;  % group 5, commonly  kids (age <= 10)
%}
data(find(data(:,8)<150),8)=1;  % group 1, commonly elders
data(find(data(:,8)>=150 & data(:,8)<=209),8)=2;  % group 3
data(find(data(:,8)>=210),8)=3;  % group 5, commonly  kids (age <= 10)


%5. oldpeak (exercise induced ST depression), according to (1): https://en.wikipedia.org/wiki/ST_depression
% and (2)
data(find(data(:,10)<=1),10)=1; % group 1, ST segment depression is not significant
data(find(data(:,10)>1),10)=2; % group 2, ST segment depression is significant

%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% attribute 10 and 11 should be considered together as one


%set label to 2 classes
label(find(label~=0))=-1; % 1,2,3 to -1
label(find(label~=-1))=1; % 0 to 1: Healthy

stb_v=[1,2,12];
