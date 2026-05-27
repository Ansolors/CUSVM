function [Data, datName] = GTSRBdata_1(trNumeach, XuNo, Case)

% seed = 1;
% Case = 1;
load './Data/GTSRB/GTSRB_vector_1.mat'; % 德国交通标志数据集 U = 22, 25
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
Xpos = Xtrain(Ytrain == 18,:);
Xpos = Xpos(randperm(size(Xpos,1), XposNo), :);
Ypos = ones(size(Xpos,1), 1);
Xneg = Xtrain(Ytrain == 26,:);
Xneg = Xneg(randperm(size(Xneg,1), XnegNo), :);
Yneg = -ones(size(Xneg,1), 1);
Data.X = [Xneg;  Xpos];
Data.Y = [Yneg;  Ypos];

datName = ['GTSRB_1_',num2str(m) , 'x' , num2str(n)]; 

while Case == 0
    return;
end

% ui = 0;
for i = [11, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
    if i ~= 18 && i ~= 26
%         ui  = ui + 1;
        Xui = Xtrain(Ytrain == i, :);
        if i == 11
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(1)), :);  % traffic sign 11
        end
        if i == 18
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(2)), :);  % traffic sign 18
        end
        if i == 19
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(3)), :);  % traffic sign 19
        end
        if i == 20
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(4)), :);  % traffic sign 20
        end
        if i == 21
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(5)), :);  % traffic sign 21
        end
        if i == 22
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(6)), :);  % traffic sign 22
        end
        if i == 23
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(7)), :);  % traffic sign 23
        end
        if i == 24
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(8)), :);  % traffic sign 24
        end
        if i == 25
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(9)), :);  % traffic sign 25
        end
        if i == 26
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(10)), :);  % traffic sign 26
        end
        if i == 27
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(11)), :);  % traffic sign 27
        end
        if i == 28
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(12)), :);  % traffic sign 28
        end
        if i == 29
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(13)), :);  % traffic sign 29
        end
        if i == 30
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(14)), :);  % traffic sign 30
        end
        if i == 31
            DataU.Ux{i} = Xui(randperm(size(Xui,1), XuNo(15)), :);  % traffic sign 31
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
        idx = ~cellfun('isempty', DataU.Ux);
        Data.Ux = DataU.Ux(idx);
    case 3
    %  ---- case 3:  Universum are others except 4 and 5 -----
        Data.Ux{1} = DataU.Ux{2};
        Data.Ux{2} = DataU.Ux{3};
end
Data.Uy = 1:length(Data.Ux);

%% 显示缩放图像

% load './Data/GTSRB/GTSRB_matrix.mat';    
% im = double(X_train(:,:,200))/255;
% figure(1) 
% imshow(im)
% figure(2) 
% imshow(X_test(:,:,1))
% figure(3)
% imagesc(X_train(:,:,200))

%% 数据划分

% 分组 1 ：[11, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31] 形状 1；颜色 1（15个）GTSRB_vector_1
% 分组 2 ：[0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 15, 16, 17] 形状 2；颜色 1（13个）GTSRB_vector_2
% 分组 3 ：[33, 34, 35, 36, 37, 38, 39, 40] 形状 2；颜色 2（8个）GTSRB_vector_3
% 分组 4 ：[6, 32, 41, 42] 形状 2；颜色 3（4个）GTSRB_vector_4

% for data = 1
%     dPth(1)={'./Data/GTSRB/GTSRB_vector.mat'}; % -1:1 = 7680 & 19478 * Feature 10
% end
% for dat = 1
%     load( dPth{dat} );
%     [m, n] = size(X_Train);
% end
% train_x = []; train_y = []; test_x = []; test_y = [];

%% 层次抽样 在数据的每一类中，按一定比例抽取数据，构成训练集，剩下的作为测试集
% scala = 0.03;  % 每一类中，训练集抽取的比例

% for label = [6, 32, 41, 42]
% %     cate = find(Y == label);
% %     half = int32(length(cate) * scala);
% %     train = cate(randperm(length(cate), half)); % 当前类下，抽取的训练集的所在行
% %     test = setdiff(cate, train); % 当前类下，剩余的也就是测试集的所在行
%     train = find(Y_train == label);
%     train_x = [train_x; X_Train(train, :)];
%     train_y = [train_y; Y_train(train)];
% %     test_x = [test_x; data(test, 1:end-1)];
% %     test_y = [test_y; labels(test)];
% end
% X = train_x; Y = train_y;
% 
% % save('./Data/GTSRB/GTSRB_vector_1.mat', 'X', 'Y');
% % save('./Data/GTSRB/GTSRB_vector_2.mat', 'X', 'Y');
% % save('./Data/GTSRB/GTSRB_vector_3.mat', 'X', 'Y');
% save('./Data/GTSRB/GTSRB_vector_4.mat', 'X', 'Y');






