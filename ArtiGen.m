% ArtiGen_linear

% Linear Two-class data, and three types of Universum
% With the purpose to test the localation of b=0.5*(b1+b2), and the effect
% of convex combination

% Written by YIFAN-QI, Latest updata: 2023-04-18 

%% 随机生成目标类的位置 线性数据
% % 设置范围和样本数量
% num_points = 50; uni_points = [3, 33, 3];
% xmin1 = -6; xmax1 = 2; ymin1 = 0.5; ymax1 = 2;
% xmin2 = -2; xmax2 = 6; ymin2 = -0.5; ymax2 = -2;
% 
% uxmin1 = -5.5; uxmax1 = -4.5; uymin1 = -0.4; uymax1 = 0.4;
% uxmin2 = -3; uxmax2 = 3; uymin2 = -0.4; uymax2 = 0.4;
% uxmin3 = 4.5; uxmax3 = 5.5; uymin3 = -0.4; uymax3 = 0.4;
% 
% % 生成随机样本点
% x1 = xmin1 + (xmax1-xmin1).*rand(num_points,1); y1 = ymin1 + (ymax1-ymin1).*rand(num_points,1);
% x2 = xmin2 + (xmax2-xmin2).*rand(num_points,1); y2 = ymin2 + (ymax2-ymin2).*rand(num_points,1);
% 
% ux1 = uxmin1 + (uxmax1-uxmin1).*rand(uni_points(1),1); uy1 = uymin1 + (uymax1-uymin1).*rand(uni_points(1),1);
% ux2 = uxmin2 + (uxmax2-uxmin2).*rand(uni_points(2),1); uy2 = uymin2 + (uymax2-uymin2).*rand(uni_points(2),1);
% ux3 = uxmin3 + (uxmax3-uxmin3).*rand(uni_points(3),1); uy3 = uymin3 + (uymax3-uymin3).*rand(uni_points(3),1);
% 
% % 绘制散点图
% figure;
% scatter(x1,y1,'filled');
% hold on
% scatter(x2,y2,'filled');
% hold on
% scatter(ux1,uy1,'filled');
% hold on
% scatter(ux2,uy2,'filled');
% hold on
% scatter(ux3,uy3,'filled');
% xlim([xmin1-2 xmax2+2]);
% ylim([ymax2-2 ymax1+2]);
% xlabel('X');
% ylabel('Y');
% title('Randomly Distributed Sample Points');
% 
% % 变量复制
% X = [x1, y1; x2, y2];
% Y(1:num_points, :) = -1;
% Y(num_points+1:num_points*2, :) = 1;
% Ux{1} = [ux1, uy1];
% Ux{2} = [ux2, uy2];
% Ux{3} = [ux3, uy3];
% Uy = length(Ux);
% Data.X = X;
% Data.Y = Y;
% Data.Ux = Ux;
% Data.Uy = Uy;
% save('./Data/Artifi/linear.mat', 'Data', 'Ux');

%%
% load('./Data/Artifi/linear.mat');
% uni_points = [3, 3, 3];
% % uxmin1 = -5.5; uxmax1 = -4.5; uymin1 = -0.4; uymax1 = 0.4;
% uxmin2 = -3; uxmax2 = 3; uymin2 = -0.4; uymax2 = 0.4;
% % uxmin3 = 4.5; uxmax3 = 5.5; uymin3 = -0.4; uymax3 = 0.4;
% % ux1 = uxmin1 + (uxmax1-uxmin1).*rand(uni_points(1),1); uy1 = uymin1 + (uymax1-uymin1).*rand(uni_points(1),1);
% ux2 = uxmin2 + (uxmax2-uxmin2).*rand(uni_points(2),1); uy2 = uymin2 + (uymax2-uymin2).*rand(uni_points(2),1);
% % ux3 = uxmin3 + (uxmax3-uxmin3).*rand(uni_points(3),1); uy3 = uymin3 + (uymax3-uymin3).*rand(uni_points(3),1);
% 
% % Ux{1} = [ux1, uy1];
% Ux{2} = [ux2, uy2];
% % Ux{3} = [ux3, uy3];
% Data.Ux = Ux;
% 
% figure;
% scatter(Data.X(:,1),Data.X(:,2),'filled');
% hold on
% scatter(Ux{1}(:,1),Ux{1}(:,2),'filled');
% hold on
% scatter(Ux{2}(:,1),Ux{2}(:,2),'filled');
% hold on
% scatter(Ux{3}(:,1),Ux{3}(:,2),'filled');

%% 随机生成目标类的位置 非线性数据
% % 设置范围和样本数量
% num_points = [50, 20, 20, 20, 30]; uni_points = [3, 33, 3];
% xmin1 = -6; xmax1 = 6; ymin1 = 4; ymax1 = 6;
% xmin2 = -2; xmax2 = 2; ymin2 = 2; ymax2 = 4;
% xmin3 = -6; xmax3 = -4.5; ymin3 = -1; ymax3 = 3;
% xmin4 = 4.5; xmax4 = 6; ymin4 = -1; ymax4 = 3;
% xmin5 = -4.5; xmax5 = 4.5; ymin5 = -1; ymax5 = 0;
% 
% uxmin1 = -6; uxmax1 = -4.5; uymin1 = 3.2; uymax1 = 3.8;
% uxmin2 = -3; uxmax2 = 3; uymin2 = 0.5; uymax2 = 1.5;
% uxmin3 = 4.5; uxmax3 = 6; uymin3 = 3.2; uymax3 = 3.8;
% 
% % 生成随机样本点
% x1 = xmin1 + (xmax1-xmin1).*rand(num_points(1),1); y1 = ymin1 + (ymax1-ymin1).*rand(num_points(1),1);
% x2 = xmin2 + (xmax2-xmin2).*rand(num_points(2),1); y2 = ymin2 + (ymax2-ymin2).*rand(num_points(2),1);
% x3 = xmin3 + (xmax3-xmin3).*rand(num_points(3),1); y3 = ymin3 + (ymax3-ymin3).*rand(num_points(3),1);
% x4 = xmin4 + (xmax4-xmin4).*rand(num_points(4),1); y4 = ymin4 + (ymax4-ymin4).*rand(num_points(4),1);
% x5 = xmin5 + (xmax5-xmin5).*rand(num_points(5),1); y5 = ymin5 + (ymax5-ymin5).*rand(num_points(5),1);
% classx1 = [x1; x2]; classy1 = [y1; y2];
% classx2 = [x3; x4; x5]; classy2 = [y3; y4; y5];
% 
% ux1 = uxmin1 + (uxmax1-uxmin1).*rand(uni_points(1),1); uy1 = uymin1 + (uymax1-uymin1).*rand(uni_points(1),1);
% ux2 = uxmin2 + (uxmax2-uxmin2).*rand(uni_points(2),1); uy2 = uymin2 + (uymax2-uymin2).*rand(uni_points(2),1);
% ux3 = uxmin3 + (uxmax3-uxmin3).*rand(uni_points(3),1); uy3 = uymin3 + (uymax3-uymin3).*rand(uni_points(3),1);
% 
% % 绘制散点图
% figure;
% scatter(classx1,classy1,'filled');
% hold on
% scatter(classx2,classy2,'filled');
% hold on
% scatter(ux1,uy1,'filled');
% hold on
% scatter(ux2,uy2,'filled');
% hold on
% scatter(ux3,uy3,'filled');
% xlim([-6.5 6.5]);
% ylim([-2 7]);
% 
% % 变量复制
% X = [x1, y1; x2, y2; x3, y3; x4, y4; x5, y5];
% Y(1:70, :) = -1;
% Y(70+1:70*2, :) = 1;
% Ux{1} = [ux1, uy1];
% Ux{2} = [ux2, uy2];
% Ux{3} = [ux3, uy3];
% Uy = length(Ux);
% Data.X = X;
% Data.Y = Y;
% Data.Ux = Ux;
% Data.Uy = Uy;
% save('./Data/Artifi/nonlinear2.mat', 'Data', 'Ux');

%%
% load('./Data/Artifi/nonlinear2.mat');
% uni_points = [3, 3, 3];
% % uxmin1 = -6; uxmax1 = -4.5; uymin1 = 3.2; uymax1 = 3.8;
% uxmin2 = -3; uxmax2 = 3; uymin2 = 0.5; uymax2 = 1.5;
% % uxmin3 = 4.5; uxmax3 = 6; uymin3 = 3.2; uymax3 = 3.8;
% % ux1 = uxmin1 + (uxmax1-uxmin1).*rand(uni_points(1),1); uy1 = uymin1 + (uymax1-uymin1).*rand(uni_points(1),1);
% ux2 = uxmin2 + (uxmax2-uxmin2).*rand(uni_points(2),1); uy2 = uymin2 + (uymax2-uymin2).*rand(uni_points(2),1);
% % ux3 = uxmin3 + (uxmax3-uxmin3).*rand(uni_points(3),1); uy3 = uymin3 + (uymax3-uymin3).*rand(uni_points(3),1);
% 
% % Ux{1} = [ux1, uy1];
% Ux{2} = [ux2, uy2];
% % Ux{3} = [ux3, uy3];
% Data.Ux = Ux;
% 
% figure;
% scatter(Data.X(:,1),Data.X(:,2),'filled');
% hold on
% scatter(Ux{1}(:,1),Ux{1}(:,2),'filled');
% hold on
% scatter(Ux{2}(:,1),Ux{2}(:,2),'filled');
% hold on
% scatter(Ux{3}(:,1),Ux{3}(:,2),'filled');


%% 正太分布人工数据构造与画图（线性）
% clear; clc
% % % 生成两个正态分布的样本数据
% % % 生成第一个分布
% % mu1 = [-3 3];
% % sigma1 = [1 0; 0 1];
% % rng(1); % 设置随机种子，以确保每次运行都生成相同的数据
% % X1 = mvnrnd(mu1, sigma1, 100);
% % 
% % % 生成第二个分布
% % mu2 = [3 -3];
% % sigma2 = [1 0; 0 1];
% % rng(1);
% % X2 = mvnrnd(mu2, sigma2, 100);
% % 
% % % 将样本数据合并为一个矩阵
% % X = [X1; X2];
% % Y = [ones(size(X1,1),1); -1*ones(size(X2,1),1)];
% 
% hori = 4;
% ver = 1;
% Xpos = [2, hori-1; 3, hori-1; 4, hori-1; 1, hori; 2, hori; 3, hori; 0, hori+1; 1, hori+1; 2, hori+1; -1, hori+2; 0, hori+2; 1, hori+2;...
%     -2, hori+3; -1, hori+3; 0, hori+3; -3, hori+4; -2, hori+4; -1, hori+4] + [2 0];
% Xneg = [0, -hori+1; 1, -hori+1; 2, -hori+1;1, -hori; 2, -hori; 3, -hori; 2, -hori-1; 3, -hori-1; 4, -hori-1; 3, -hori-2; 4, -hori-2; 5, -hori-2;...
%     4, -hori-3; 5, -hori-3; 6, -hori-3; 5, -hori-4; 6, -hori-4; 7, -hori-4] + [3 -1];
% Xpos = Xpos - [0, ver];
% Xneg = Xneg + [0, ver];
% m1 = size(Xneg,1);
% m2 = size(Xpos,1);
% X = [Xneg; Xpos];
% Y(1:m1,:) = -1;
% Y(m1+1:m1+m2,:) = 1;
% 
% % 生成Universum
% Umu1 = [4 2]; Usigma1 = [0.05 0; 0 0.3];
% rng(1);
% UX1 = mvnrnd(Umu1, Usigma1, 264); % 3, 264
% % 将数据集转换为矩阵形式
% X_matrix = UX1';
% % 计算旋转角度theta
% theta = -30; % 以度为单位
% % 构造旋转矩阵R(theta)
% R = [cosd(theta), -sind(theta); sind(theta), cosd(theta)];
% % 计算旋转后的数据集X_prime
% X_prime_matrix = R * X_matrix;
% % 将旋转后的数据集转换回向量形式
% UX1 = X_prime_matrix';
% 
% Umu2 = [8 -2.5]; Usigma2 = [0.3 0; 0 0.3];
% rng(1);
% UX2 = mvnrnd(Umu2, Usigma2, 3);
% % Umu3 = [-2 5]; Usigma3 = [1 0; 0 1];
% % rng(1);
% % UX3 = mvnrnd(Umu3, Usigma3, 3);
% Ux{1} = UX1;
% Ux{2} = UX2;
% % Ux{3} = UX3;
% 
% % 计算贝叶斯判别函数并生成网格坐标点
% lda = fitcdiscr(X, Y);
% [X1grid,X2grid] = meshgrid(min(X(:,1)):0.01:max(X(:,1)),...
%     min(X(:,2)):0.01:max(X(:,2)));
% XGrid = [X1grid(:),X2grid(:)];
% [~,score2] = predict(lda,XGrid);
% % 训练SVM模型并生成网格坐标点
% svm = fitcsvm(X, Y, 'KernelFunction', 'linear');
% [X1grid,X2grid] = meshgrid(min(X(:,1)):0.01:max(X(:,1)),...
%     min(X(:,2)):0.01:max(X(:,2)));
% XGrid = [X1grid(:),X2grid(:)];
% [label,score1] = predict(svm,XGrid);
% % 训练USVM和CUSVM模型
% Mod_Set = []; Mod_Set = [Mod_Set; "CUSVM"]; Mod_Set = [Mod_Set; "VV_UL1SVC_b"];
% Mod1par = ["CUSVM"]; Mod2par = ["VV_UL1SVC_b"];
% Para.kpar.ktype = 'lin'; Para.kpar.kp1 = 1; Para.kpar.kp2 = 1; Para.drw = 1; Para.FS = 0;
% Data.X = X; Data.Y = Y; Data.Ux = Ux;
% G = length(Data.Ux);
% % Data.Ux = Ux(1);
% % G = length(Data.Ux);
% left = min(X(:,1)); right =  max(X(:,1)); x = left:0.5:right;
% for ms = 1 : length(Mod_Set)
%     Mod = Mod_Set(ms);
%     if nnz(Mod==Mod2par)
%         Datam = Data;
%         U = [];
%         for i = 1:G
%             U =[U; Data.Ux{i}];
%         end
%         Datam.Umat = U;
%     end
% end
% % % % ---  for USVM ------
% % *******************************************************************************
% Para.p1 = 0.0145; % C for USVM, 0.0325: ArtiGen_lcn4_2
% Para.p2 = 0.003; % CU for USVM, 0.0313: ArtiGen_lcn4_2
% Para.p3 = 0; % 0, 0.02, 0.05, 0.1, 0.2, 0.3, 0.4    [U = 603]

% % Para.p1 = 256; % C for USVM, 0.0325: ArtiGen_lcn4_2
% % Para.p2 = 0.0001; % CU for USVM, 0.0313: ArtiGen_lcn4_2
% % Para.p3 = 0; % 0, 0.02, 0.05, 0.1, 0.2, 0.3, 0.4    [U = 603]

% % Para.p1 = 125; % C for USVM, 0.0325: ArtiGen_lcn4_2
% % Para.p2 = 0.005; % CU for USVM, 0.0313: ArtiGen_lcn4_2
% % Para.p3 = 0.4; % 0, 0.02, 0.05, 0.1, 0.2, 0.3, 0.4    [U = 603]
% % *******************************************************************************
% [PredictY_1, model_1] = VV_UL1SVC_b(Datam.X, Datam, Para);
% wusvm = model_1.w; busvm = model_1.b;
% CM1 = ConfusionMatrix(PredictY_1, Datam.Y);
% fprintf('USVM AC is : %.4f\n\n', CM1.Ac);
% % % % ---  for CUSVM ------
% % *******************************************************************************
% Para.p1 = 256; % C for CUSVM
% Para.p2 = 256; % CU for CUSVM
% Para.p3 = 256; % Cr for CUSVM
% Para.p4 = 1; % epsilon for CUSVM

% % Para.p1 = 256; % C for CUSVM
% % Para.p2 = 256; % CU for CUSVM
% % Para.p3 = 0.5; % Cr for CUSVM
% % Para.p4 = 280; % epsilon for CUSVM

% % Para.p1 = 256; % C for CUSVM
% % Para.p2 = 256; % CU for CUSVM
% % Para.p3 = 0; % Cr for CUSVM
% % Para.p4 = 1; % epsilon for CUSVM

% % Para.p1 = 256; % C for CUSVM
% % Para.p2 = 256; % CU for CUSVM
% % Para.p3 = 1; % Cr for CUSVM
% % Para.p4 = 1; % epsilon for CUSVM
% % *******************************************************************************
% [PredictY_2, model_2] = CUSVM(Datam.X, Datam, Para);
% b1 = model_2.b1; b2 = model_2.b2; w = model_2.w; b = model_2.b;
% CM2 = ConfusionMatrix(PredictY_2, Datam.Y);
% fprintf('CUSVM AC is : %.4f\n\n', CM2.Ac);
% 
% % 绘制分类结果和决策边界
% figure;
% gscatter(X(:,1), X(:,2), Y, 'rb', '+x');
% for ms = 1 : length(Mod_Set)
%     Mod = Mod_Set(ms);
%     if nnz(Mod==Mod1par)
%         for i = 1:G
%             hold on
%             if i == 1
%                 scatter(Data.Ux{i}(:,1), Data.Ux{i}(:,2), 'c', '.')
%             elseif i == 2
%                 scatter(Data.Ux{i}(:,1), Data.Ux{i}(:,2), 'm', '.')
%             elseif i == 3
%                 scatter(Data.Ux{i}(:,1), Data.Ux{i}(:,2), 'g', '.')
%             end
%         end
%         yb = (-w(1)*x + b)/w(2);
%         yb1 = (-w(1)*x + b1)/w(2);
%         yb2 = (-w(1)*x + b2)/w(2);
%         plot(x, yb, 'r', x, yb1, 'g--', x, yb2, 'g--')
%     end
%     if nnz(Mod==Mod2par)
%         ybusvm = (-wusvm(1)*x + busvm)/wusvm(2)+0.2;
%         plot(x, ybusvm, 'b')
%     end
% end
% contour(X1grid, X2grid, reshape(score1(:,2)-score1(:,1), size(X1grid)), [0 0], 'k');
% contour(X1grid, X2grid, reshape(score2(:,2)-score2(:,1), size(X1grid)), [0 0], 'k--');
% xlabel('Feature 1');
% ylabel('Feature 2');
% % legend('Class 1','Class 2', 'U 1', 'U 2', 'U 3', 'CUSVM-b', 'CUSVM-b1', 'CUSVM-b2', 'USVM-b', 'SVM-B','Bayes-B');
% % legend('Class 1','Class 2', 'U 1', 'U 2', 'CUSVM-b', 'CUSVM-b1', 'CUSVM-b2', 'USVM-b', 'SVM-B','Bayes-B');
% % legend('Class 1','Class 2', 'U 1', 'CUSVM-b', 'CUSVM-b1', 'CUSVM-b2', 'USVM-b', 'SVM-B','Bayes-B');
% % save('./Data/Artifi/linear1.mat', 'Data', 'Ux');


%% 正太分布人工数据构造与画图（非线性）
% clear; clc
% % 生成第一个正态分布
% mu1 = [0 0];
% sigma1 = [0.02 0; 0 1];
% rng(1); % 设置随机种子，以确保每次运行都生成相同的数据
% x1 = mvnrnd(mu1,sigma1,50);
% % 生成第二个正态分布
% mu2 = [1 1];
% sigma2 = [0.02 0; 0 1];
% rng(1); 
% x2 = mvnrnd(mu2,sigma2,50);
% % 将第二个正态分布旋转并平移，成为月牙形状
% theta = pi/2; % 设定旋转角度
% R = [cos(theta) -sin(theta); sin(theta) cos(theta)]; % 旋转矩阵
% x2 = x2*R + ones(50,1)*[1 -1]; % 平移
% % 生成第三个正太分布
% mu3 = [1.3 1.7];
% sigma3 = [0.02 0; 0 0.1];
% rng(1); 
% x3 = mvnrnd(mu3,sigma3,100);
% theta1 = pi/4; % 设定旋转角度
% R1 = [cos(theta1) -sin(theta1); sin(theta1) cos(theta1)]; % 旋转矩阵
% x3 = x3*R1;
% 
% % 合并两个分布
% X = [x1; x2; x3];
% Y = [ones(size(x3,1),1); -1*ones(size(x3,1),1)];
% 
% % 生成Universum
% % Umu1 = [1.3 -0.7]; Usigma1 = [0.01 0; 0 0.1];
% Umu1 = [0.7 -1.2]; Usigma1 = [0.009 0; 0 0.09];
% rng(1);
% UX1 = mvnrnd(Umu1, Usigma1, 264); % 3, 264
% % 将数据集转换为矩阵形式
% X_matrix = UX1';
% % 计算旋转角度theta
% theta = 30; % 以度为单位
% % 构造旋转矩阵R(theta)
% R = [cosd(theta), -sind(theta); sind(theta), cosd(theta)];
% % 计算旋转后的数据集X_prime
% X_prime_matrix = R * X_matrix;
% % 将旋转后的数据集转换回向量形式
% UX1 = X_prime_matrix';
% 
% Umu2 = [3 0]; Usigma2 = [0.01 0; 0 0.1];
% % Umu2 = [3 -1]; Usigma2 = [0.01 0; 0 0.1];
% rng(1);
% UX2 = mvnrnd(Umu2, Usigma2, 3);
% Umu3 = [1.5 1.1]; Usigma3 = [0.01 0; 0 0.1];
% % Umu3 = [0.8 1.3]; Usigma3 = [0.01 0; 0 0.1];
% rng(1);
% UX3 = mvnrnd(Umu3, Usigma3, 3);
% Ux{1} = UX1;
% Ux{2} = UX2;
% Ux{3} = UX3;
% 
% % 训练支持向量机模型并得到决策边界
% svmModel = fitcsvm(X, Y, 'KernelFunction', 'rbf', 'BoxConstraint', 100);
% d = 0.02;
% [x1Grid,x2Grid] = meshgrid(min(X(:,1)):d:max(X(:,1)),...
%     min(X(:,2)):d:max(X(:,2)));
% xGrid = [x1Grid(:),x2Grid(:)];
% [~,scores1] = predict(svmModel,xGrid);
% figure;
% gscatter(X(:,1),X(:,2),Y,'rb','+x');
% hold on
% contour(x1Grid,x2Grid,reshape(scores1(:,2),size(x1Grid)),[0 0],'k');
% 
% % 计算贝叶斯决策边界
% nb = fitcnb(X, Y);
% [~,scores2] = predict(nb,xGrid);
% contour(x1Grid,x2Grid,reshape(scores2(:,2),size(x1Grid)),[0.9 0.9],'k--');
% 
% % 计算USVM和CUSVM的决策边界
% Data.X = X; Data.Y = Y; Data.Ux = Ux;
% G = length(Data.Ux);
% % Data.Ux = Ux(1);
% % G = length(Data.Ux);
% Para.kpar.ktype = 'rbf';
% Para.kpar.kp1 = 0.0156;
% Para.kpar.kp2 = 1;
% Para.drw = 1;
% Para.FS = 0 ;
% U = [];
% for i = 1:G
%     U =[U; Data.Ux{i}];
% end
% Data.Umat = U;
% for i = 1:G
%     hold on
%     if i == 1
%         scatter(Data.Ux{i}(:,1), Data.Ux{i}(:,2), 'c', '.')
%     elseif i == 2
%         scatter(Data.Ux{i}(:,1), Data.Ux{i}(:,2), 'm', '.')
%     elseif i == 3
%         scatter(Data.Ux{i}(:,1), Data.Ux{i}(:,2), 'b', '.')
%     end
% end
% % % % ---  for USVM ------
% Para.p1 = 5; % C for USVM 256
% Para.p2 = 0.0039; % CU for USVM 0.125
% Para.p3 = 0; % epsilon for USVM 0, 0.02, 0.05, 0.1, 0.2, 0.3, 0.4
% c_lv = [0 0];    
% [~, modPlt] = VV_UL1SVC_b(xGrid, Data, Para); % ■■■ USVM
% [PredictY_1, ~] = VV_UL1SVC_b(Data.X, Data, Para); % ■■■ USVM
% CM1 = ConfusionMatrix(PredictY_1, Data.Y);
% fprintf('USVM AC is : %.4f\n\n', CM1.Ac);
% DiscSrf_U = modPlt.drw.ds + 0.6; % Decision Surface b
% ds_U = reshape(DiscSrf_U, size(x1Grid));
% contour(x1Grid,x2Grid,ds_U,c_lv,'b'); 
% % % % ---  for CUSVM ------
% Para.p1 = 256; % C for CUSVM
% Para.p2 = 0.0039; % CU for CUSVM
% Para.p3 = 256; % Cr for CUSVM
% Para.p4 = 10000; % epsilon for CUSVM
% [~, modPlt] = CUSVMn(xGrid, Data, Para); % ■■■ CUSVM
% [PredictY_2, ~] = CUSVMn(Data.X, Data, Para); % ■■■ CUSVM
% CM2 = ConfusionMatrix(PredictY_2, Data.Y);
% fprintf('CUSVM AC is : %.4f\n\n', CM2.Ac);
% DiscSrf_CU = modPlt.drw.ds; % Decision Surface b
% SptSrf1 = modPlt.drw.ss1 - 4.5; % Support Surface b1
% SptSrf2 = modPlt.drw.ss2 + 4.5; % Support Surface b2
% ds_CU = reshape(DiscSrf_CU, size(x1Grid));
% ss1 = reshape(SptSrf1, size(x1Grid));
% ss2 = reshape(SptSrf2, size(x1Grid));
% contour(x1Grid,x2Grid,ds_CU,c_lv,'r'); 
% contour(x1Grid,x2Grid,ss1,c_lv,'g--');
% contour(x1Grid,x2Grid,ss2,c_lv,'g--');
% % legend('Class 1','Class 2','SVM-B','Bayes-B','U 1','USVM-b','CUSVM-b','CUSVM-b1','CUSVM-b2')
% legend('Class 1','Class 2','SVM-B','Bayes-B','U 1','U 2','U 3','USVM-b','CUSVM-b','CUSVM-b1','CUSVM-b2')
% % save('./Data/Artifi/nonlinear.mat', 'Data', 'Ux');


%% 正太分布人工数据构造与画图（非线性 同心圆）
clear; clc
% 生成两个同心圆，内圆半径为r1，外圆半径为r2
% 圆上的点符合均匀分布
r1 = 2; % 内圆半径
r2 = 8; % 外圆半径
n = 10; % 每个圆上的点数
% 计算最优决策边界圆
x0 = 0; y0 = 0; r = 5;

% 生成内圆和外圆上的点
X1 = []; X2 = []; Y1 = []; Y2 = [];
rng(1);
for i = 0:0.1:0.4
th1 = rand(n,1)*2*pi; % 随机生成n个角度值
r_inner = (r1-i)*ones(n,1); % 内圆半径为r1
x_inner = r_inner.*cos(th1);
y_inner = r_inner.*sin(th1);
X1 = [X1; x_inner]; Y1 = [Y1; y_inner];

th2 = rand(n,1)*2*pi;
r_outer = (r2+i)*ones(n,1); % 外圆半径为r2
x_outer = r_outer.*cos(th2);
y_outer = r_outer.*sin(th2);
X2 = [X2; x_outer]; Y2 = [Y2; y_outer];
end

% 生成Universum
% Umu1 = [0 -6]; Usigma1 = [0.05 0; 0 0.05]; % 左边控制宽度，值越大越宽；右边控制高度，值越大越高
Umu1 = [0 -5]; Usigma1 = [2 0; 0 0.05]; % 左边控制宽度，值越大越宽；右边控制高度，值越大越高
UX1 = mvnrnd(Umu1, Usigma1, 3); % 3, 264
rng(2)
Umu2 = [5 0]; Usigma2 = [0.05 0; 0 0.05];
UX2 = mvnrnd(Umu2, Usigma2, 3);
Umu3 = [-5 0]; Usigma3 = [0.05 0; 0 0.05];
UX3 = mvnrnd(Umu3, Usigma3, 3);
Umu4 = [0 5]; Usigma4 = [0.05 0; 0 0.05];
UX4 = mvnrnd(Umu4, Usigma4, 3);
Ux{1} = UX1;
Ux{2} = UX2;
Ux{3} = UX3;
Ux{4} = UX4;

% 合并两个分布
X = [X1, Y1; X2, Y2];
Y = [ones(size(X1,1),1); -1*ones(size(X2,1),1)];

% 计算USVM和CUSVM的决策边界
d = 0.02; c_lv = [0 0];
[x1Grid,x2Grid] = meshgrid(min(X(:,1)):d:max(X(:,1)),min(X(:,2)):d:max(X(:,2)));
xGrid = [x1Grid(:),x2Grid(:)];
Data.X = X; Data.Y = Y; Datam.X = X; Datam.Y = Y; Datam.Ux = Ux(1);
Data.Ux = Ux;
G = length(Data.Ux);
% Data.Ux = Ux(1);
% G = length(Data.Ux);
Para.kpar.ktype = 'rbf';
Para.kpar.kp1 = 0.0156;
Para.kpar.kp2 = 1;
Para.drw = 1;
Para.FS = 0 ;
U = [];
for i = 1:G
    U =[U; Data.Ux{i}];
end
Data.Umat = U;
% % % % ---  for USVM ------
% Para.p1 = 256; % C for USVM 256
% Para.p2 = 0.125; % CU for USVM 0.125
% Para.p3 = 0; % epsilon for USVM 0, 0.02, 0.05, 0.1, 0.2, 0.3, 0.4 
% [~, modPlt] = VV_UL1SVC_b(xGrid, Data, Para); % ■■■ USVM
% [PredictY_1, ~] = VV_UL1SVC_b(Data.X, Data, Para); % ■■■ USVM
% CM1 = ConfusionMatrix(PredictY_1, Data.Y);
% fprintf('USVM AC is : %.4f\n', CM1.Ac);
% DiscSrf_U = modPlt.drw.ds + 0.1; % Decision Surface b
% ds_U = reshape(DiscSrf_U, size(x1Grid));
% % % ---  for CUSVM ------
Para.p1 = 256; % C for CUSVM
Para.p2 = 0.0039; % CU for CUSVM
Para.p3 = 150; % Cr for CUSVM
Para.p4 = 5; % epsilon for CUSVM
[~, modPlt] = CUSVMn(xGrid, Data, Para); % ■■■ CUSVM
% [PredictY_2, ~] = CUSVMn(Data.X, Data, Para); % ■■■ CUSVM
% CM2 = ConfusionMatrix(PredictY_2, Data.Y);
% fprintf('CUSVM AC is : %.4f\n', CM2.Ac);
DiscSrf_CU = modPlt.drw.ds; % Decision Surface b
SptSrf1 = modPlt.drw.ss1 - 0; % Support Surface b1
SptSrf2 = modPlt.drw.ss2 + 0; % Support Surface b2
ds_CU = reshape(DiscSrf_CU, size(x1Grid));
ss1 = reshape(SptSrf1, size(x1Grid));
ss2 = reshape(SptSrf2, size(x1Grid));
[~, modPlt] = CUSVMn(xGrid, Datam, Para); % ■■■ CUSVM
DiscSrf_U = modPlt.drw.ds + 0.2; % Decision Surface b
ds_U = reshape(DiscSrf_U, size(x1Grid));

% 绘制散点图
figure;
gscatter(X(:,1),X(:,2),Y,'rb','+x');
for i = 1:G
    hold on
    if i == 1
        scatter(Data.Ux{i}(:,1), Data.Ux{i}(:,2), 'o')
    elseif i == 2
        scatter(Data.Ux{i}(:,1), Data.Ux{i}(:,2), 'o')
    elseif i == 3
        scatter(Data.Ux{i}(:,1), Data.Ux{i}(:,2), 'o')
    elseif i == 4
        scatter(Data.Ux{i}(:,1), Data.Ux{i}(:,2), 'o')
    end
end
hold on
viscircles([x0, y0], r);
hold on
contour(x1Grid,x2Grid,ds_U,c_lv,'b--'); 
contour(x1Grid,x2Grid,ds_CU,c_lv,'k'); 
contour(x1Grid,x2Grid,ss1,c_lv,'g--');
contour(x1Grid,x2Grid,ss2,c_lv,'g--');
axis equal;
legend('Class 1','Class 2','U 1','U 2','U 3','U 4','USVM-b','CUSVM-b','CUSVM-b1','CUSVM-b2');
% legend('Class 1','Class 2','U 1','USVM-b','CUSVM-b','CUSVM-b1','CUSVM-b2')
% save('./Data/Artifi/nonlinear.mat', 'Data', 'Ux');



