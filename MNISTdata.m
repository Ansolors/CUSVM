function [Data, datName] = MNISTdata(trNumeach, XuNo, Case)

% seed = 1;
% Case = 1;
load './Data/UniData/MNIST784.mat'; % MNIST64,MNIST256,MNIST784
[m,n] = size(X);
% X = X/255;
X = mapminmax(X',0,1)';
trPer = 0.9;
trInd = randperm(m, round(trPer*m));
teInd = setdiff(1:m, trInd);
Xtrain = X(trInd, :);
Ytrain = Y(trInd);
Xtest = X(teInd, :);
Ytest = Y(teInd);

XposNo = trNumeach;
XnegNo = trNumeach;
Xpos = Xtrain(Ytrain == 6,:);
Xpos = Xpos(randperm(size(Xpos,1), XposNo), :);
Ypos = ones(size(Xpos,1), 1);
Xneg = Xtrain(Ytrain == 9,:);
Xneg = Xneg(randperm(size(Xneg,1), XnegNo), :);
Yneg = -ones(size(Xneg,1), 1);
Data.X = [Xneg;  Xpos];
Data.Y = [Yneg;  Ypos];

datName = ['MNIST_',num2str(m) , 'x' , num2str(n)]; 

while Case == 0
    return;
end

% XuNo = 2; % 2 4 6 8 10 20 30 40 50 60
% ui = 0;
% for i = 1: 10
%     if i ~= 6 && i ~= 9
%         ui  = ui + 1;
%         Xui = Xtrain(Ytrain == i,:);
%         DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo), :);  % ui = 4 is digit 3; ui = 6 is digit 6
%     end
% end

% XuNo = [2, 2, 2, 400, 2, 2, 2, 2]; % 针对某一个类Universum需要特别多的情况 digit [0， 1， 2， 3， 4， 6， 7， 9]
ui = 0;
if Case == 1
for i = 1: 10
    if i ~= 6 && i ~= 9
        ui  = ui + 1;
        Xui = Xtrain(Ytrain == i,:);
%         if i == 1
%             DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(1)), :);  % digit 0
%         end
%         if i == 2
%             DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(2)), :);  % digit 1
%         end
%         if i == 3
%             DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(3)), :);  % digit 2
%         end
        if i == 4
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(4)), :);  % digit 3
        end
%         if i == 5
%             DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(5)), :);  % digit 4
%         end
        if i == 7
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(6)), :);  % digit 6
        end
%         if i == 8
%             DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(7)), :);  % digit 7
%         end
%         if i == 10
%             DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(8)), :);  % digit 9
%         end
    end
end
end
if Case == 2
for i = 1: 10
    if i ~= 6 && i ~= 9
        ui  = ui + 1;
        Xui = Xtrain(Ytrain == i,:);
        if i == 1
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(1)), :);  % digit 0
        end
        if i == 2
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(2)), :);  % digit 1
        end
        if i == 3
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(3)), :);  % digit 2
        end
        if i == 4
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(4)), :);  % digit 3
        end
        if i == 5
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(5)), :);  % digit 4
        end
        if i == 7
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(6)), :);  % digit 6
        end
        if i == 8
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(7)), :);  % digit 7
        end
        if i == 10
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(8)), :);  % digit 9
        end
    end
end
end
if Case == 3
for i = 1: 10
    if i ~= 6 && i ~= 9
        ui  = ui + 1;
        Xui = Xtrain(Ytrain == i,:);
        if i == 1
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(1)), :);  % digit 0
        end
        if i == 2
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(2)), :);  % digit 1
        end
        if i == 3
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(3)), :);  % digit 2
        end
%         if i == 4
%             DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(4)), :);  % digit 3
%         end
        if i == 5
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(5)), :);  % digit 4
        end
%         if i == 7
%             DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(6)), :);  % digit 6
%         end
        if i == 8
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(7)), :);  % digit 7
        end
        if i == 10
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(8)), :);  % digit 9
        end
    end
end
end

switch Case
    case 1
        %  ---- case 1:  Universum are 3 and 6 -----
        Data.Ux{1} = DataU.Ux{4};
        Data.Ux{2} = DataU.Ux{6};
    case 2
    % ---- case 2:  Universum are all others -----
        Data.Ux = DataU.Ux;
    case 3
    %  ---- case 3:  Universum are others except 3 and 6 -----
        Data.Ux{1} = DataU.Ux{1};
        Data.Ux{2} = DataU.Ux{2};
        Data.Ux{3} = DataU.Ux{3};
        Data.Ux{4} = DataU.Ux{5};
        Data.Ux{5} = DataU.Ux{7};
        Data.Ux{6} = DataU.Ux{8};
%     ui = 0;
%         for i = 1: 10
%             if i ~= 6 && i ~= 9 && i ~= 4 && i ~= 7 && i ~= 2 && i ~= 8
%                 ui  = ui + 1;
%                 Xui = Xtrain(Ytrain == i,:);
%                 Data.Ux{ui} = Xui(randperm(size(Xui,1), XuNo), :);  % ui = 4 is digit 3; ui = 6 is digit 6, 
%             end
%         end
end
Data.Uy = 1:length(Data.Ux);



% G = length(Data.Ux);
% U = [];
% for i = 1:G
%    U =[U; Data.Ux{i}];
% end
% Data.Umat = U;


% Prcs 0.11, AC:100.0000, p1:0.0039, p2:16.0000, p3:256.0000, p4:1.0000, kp1:0.0156, kp2:0.0
% Prcs 0.22, AC:100.0000, p1:0.0039, p2:16.0000, p3:256.0000, p4:1.0000, kp1:0.0156, kp2:0.0
% Prcs 0.33, AC:100.0000, p1:0.0625, p2:0.0039, p3:256.0000, p4:1.0000, kp1:0.0156, kp2:0.0
% Para.kpar.ktype = 'rbf';
% Para.kpar.kp1 = 0.0156;
% Para.drw = 1;
% Para.FS = 0 ;
% Para.p1 = 0.0039;   % C for CUSVM: ArtiGen_lcn4_2
% Para.p2 = 16; % CU for CUSVM: ArtiGen_lcn4_2
% Para.p3 =256;    % Cr for CUSVM: ArtiGen_lcn4_2
% Para.p4 = 1; % epsilon  for CUSVM: ArtiGen_lcn4_2
% [ PredictY, modelCUSVM ] = CUSVM(Xtest , Data , Para);
% 
% AccCUSVM  = sum(PredictY==Ytest)/length(PredictY);
% [ PredictY, modelUSVM ] = VV_UL1SVC_b(Xtest , Data , Para);
% AccUSVM  = sum(PredictY==Ytest)/length(PredictY);


% Prcs 0.11, AC:100.0000, p1:0.0039, p2:256.0000, p3:1.0000, p4:0.1000, kp1:0.0000, kp2:0.0
% Prcs 0.22, AC:100.0000, p1:0.0156, p2:0.2500, p3:0.0039, p4:1.0000, kp1:0.0000, kp2:0.0
% Prcs 0.33, AC:100.0000, p1:0.0625, p2:256.0000, p3:256.0000, p4:0.1000, kp1:0.0000, kp2:0.0
% Prcs 0.44, AC:100.0000, p1:0.2500, p2:256.0000, p3:16.0000, p4:1.0000, kp1:0.0000, kp2:0.0
% Prcs 0.56, AC:100.0000, p1:0.2500, p2:256.0000, p3:16.0000, p4:1.0000, kp1:0.0000, kp2:0.0
% Prcs 0.67, AC:100.0000, p1:4.0000, p2:256.0000, p3:64.0000, p4:0.1000, kp1:0.0000, kp2:0.0
% Prcs 0.78, AC:100.0000, p1:16.0000, p2:16.0000, p3:0.0625, p4:0.1000, kp1:0.0000, kp2:0.0
% Prcs 0.89, AC:100.0000, p1:64.0000, p2:256.0000, p3:0.2500, p4:0.1000, kp1:0.0000, kp2:0.0
% Prcs 1.00, AC:100.0000, p1:256.0000, p2:64.0000, p3:64.0000, p4:1.0000, kp1:0.0000, kp2:0.0

% Para.kpar.ktype = 'lin';
% Para.kpar.kp1 = 1;
% Para.kpar.kp2 = 1;
% Para.drw = 1;
% Para.FS = 0 ;
% Para.p1 = 0.0039;   % C for CUSVM: ArtiGen_lcn4_2
% Para.p2 = 256; % CU for CUSVM: ArtiGen_lcn4_2
% Para.p3 =256;    % Cr for CUSVM: ArtiGen_lcn4_2
% Para.p4 = 1; % epsilon  for CUSVM: ArtiGen_lcn4_2
% [ PredictY, modelCUSVM ] = CUSVM(Xtest , Data , Para);
% 
% AccCUSVM  = sum(PredictY==Ytest)/length(PredictY);
% [ PredictY, modelUSVM ] = VV_UL1SVC_b(Xtest , Data , Para);
% AccUSVM  = sum(PredictY==Ytest)/length(PredictY);


