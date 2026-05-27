function [Data, datName] = KTHdata(trNumeach, XuNo, Case)

% seed = 1;
% Case = 1;
load './Data/KTH/KTH4s_vector_resize.mat'; % 人类行为动作数据集；KTH4s_vector；KTH5s_vector
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
Xpos = Xtrain(Ytrain == 1,:); % 对哪两个动作进行分类。（Class=1,6 + Universum=4,5）或者（Class=2,4 + Universum=5,6）
Xpos = Xpos(randperm(size(Xpos,1), XposNo), :);
Ypos = ones(size(Xpos,1), 1);
Xneg = Xtrain(Ytrain == 6,:); % 对哪两个动作进行分类。（Class=1,6 + Universum=4,5）或者（Class=2,4 + Universum=5,6）
Xneg = Xneg(randperm(size(Xneg,1), XnegNo), :);
Yneg = -ones(size(Xneg,1), 1);
Data.X = [Xneg;  Xpos];
Data.Y = [Yneg;  Ypos];

datName = ['KTH_',num2str(m) , 'x' , num2str(n)];

while Case == 0
    return;
end

ui = 0;
if Case == 1
for i = 1: 6
    if i ~= 1 && i ~= 6
%         ui  = ui + 1;
        Xui = Xtrain(Ytrain == i,:);
%         if i == 1
%             DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(1)), :);  % action 1
%         end
%         if i == 2
%             DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(2)), :);  % digit 2
%         end
%         if i == 3
%             DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(3)), :);  % digit 3
%         end
        if i == 4
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(4)), :);  % digit 4
        end
        if i == 5
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(5)), :);  % digit 5
        end
%         if i == 6
%             DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(6)), :);  % digit 6
%         end
    end
end
end
if Case == 2
for i = 1: 6
    if i ~= 1 && i ~= 6
        ui  = ui + 1;
        Xui = Xtrain(Ytrain == i,:);
        if i == 1
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(1)), :);  % digit 1
        end
        if i == 2
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(2)), :);  % digit 2
        end
        if i == 3
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(3)), :);  % digit 3
        end
        if i == 4
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(4)), :);  % digit 4
        end
        if i == 5
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(5)), :);  % digit 5
        end
        if i == 6
            DataU.Ux{ui} = Xui(randperm(size(Xui,1), XuNo(6)), :);  % digit 6
        end
    end
end
end
if Case == 3
for i = 1: 6
    if i ~= 1 && i ~= 6
%         ui  = ui + 1;
        Xui = Xtrain(Ytrain == i,:);
        if i == 1
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(1)), :);  % digit 1
        end
        if i == 2
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(2)), :);  % digit 2
        end
        if i == 3
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(3)), :);  % digit 3
        end
%         if i == 4
%             DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(4)), :);  % digit 4
%         end
%         if i == 5
%             DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(5)), :);  % digit 5
%         end
        if i == 6
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(6)), :);  % digit 6
        end
    end
end
end

switch Case
    case 1
        %  ---- case 1:  Universum are 4 and 5 -----
        Data.Ux{1} = DataU.Ux{4};
        Data.Ux{2} = DataU.Ux{5};
    case 2
    % ---- case 2:  Universum are all others -----
        Data.Ux = DataU.Ux;
    case 3
    %  ---- case 3:  Universum are others except 4 and 5 -----
        Data.Ux{1} = DataU.Ux{2};
        Data.Ux{2} = DataU.Ux{3};
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


%% 对图像进行缩放
% for i = 1
% % 人类行为动作数据集；KTH4s_vector；KTH5s_vector；KTH4s_matrix；KTH5s_matrix
% Data(1) = {'./Data/KTH/KTH4s_matrix.mat'}; % 120*160*3184 / 19200
% % Data(2) = {'./Data/KTH/KTH5s_matrix.mat'}; % 120*160*2613 / 19200
% end
% 
% for i = 1
%     fprintf('Linear Runing %d-th DataPath:%s\n',i,Data{i});
%     load([Data{i}]);
%     [~,~,k] = size(X);
%     for it = 1:k
%         X_new(:,:,it) = imresize(X(:,:,it), 0.2); % 0.2/0.5/0.6
%     end
%     clear X
%     X = X_new;
%     save('./Data/KTH/KTH4s_matrix_resize.mat', 'X', 'Y')
% end

%% 图像转向量，向量转图像
% for i = 1
% Data(1) = {'./Data/KTH/KTH4s_matrix_resize.mat'}; 
% % Data(2) = {'./Data/KTH/KTH5s_matrix_resize.mat'};
% end
% 
% for i = 1
%     fprintf('Linear Runing %d-th DataPath:%s\n',i,Data{i});
%     load([Data{i}]);
%     X = zhuanhua_img2vec(X);
% %     X = zhuanhua_vec2img(X);
% 
%     save('./Data/KTH/KTH4s_vector_resize', 'X', 'Y')
% end

%% 显示缩放图像
% load './Data/KTH/KTH4s_matrix.mat';
% figure(1) 
% imshow(X(:,:,10)) % universum
% figure(2)
% imshow(X(:,:,521)) % KTH4s；KTH5s 501; 411 (Class KTH4s;
% figure(3)
% imshow(X(:,:,991)) % 972; 806 (Class KTH4s;
% figure(4)
% imshow(X(:,:,1678)) % 1557; 1287
% figure(5)
% imshow(X(:,:,2100)) % 2047; 1686
% figure(6)
% imshow(X(:,:,3094)) % 2480; 2040 universum





