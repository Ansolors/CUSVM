% This program is used to run datasets in MNIST & KTH & GTSRB. 
% Written by YIFAN-QI, Latest updata: 2023-04-18 

clear;

% ___________________◆◆◆Model Switch◆◆◆___________________
    Mod_Set = []; 
%     Mod_Set = [Mod_Set; "SVM"]; % SVM
%     Mod_Set = [Mod_Set; "LSSVC"]; % LSSVM
%     Mod_Set = [Mod_Set; "CUSVM"]; % linear CUSVM
    Mod_Set = [Mod_Set; "CUSVMn"]; % nonlinear CUSVM
%     Mod_Set = [Mod_Set; "VV_UL1SVC_b"]; % USVM

%     Mod_Set = [Mod_Set; "OUSVM"]; %    
%     Mod_Set = [Mod_Set; "L1_HSVC";]; % L1 Hinge SVC 
%     Mod_Set = [Mod_Set; "L2S_L1_HSVC"]; %

b=0; c=2; 
n=0; dnc=[10]; dnfc=[2]; % Arti

for ms = 1 : length(Mod_Set)
    Mod = Mod_Set(ms);

    for i = "Ⅰ  Random Seed Switch"
        seed = 2;  % 固定随机种子 seed = randi(300)
    end
 
% ____________________ Model Parameters ____________________
    Base = 2; bd = 8; % 标准选参范围：Base = 2; bd = 8;
    Power = -bd : bd;
    Para.SVM = "OFF";
    [GM1, GM2, GM3, GM4] = deal(0);  Para.PFT = "OFF"; % ParaFineTuning 
    Mod1par = ["GEPSVC";"L1_HSVC";"LIBSVC";"LR_GD";...
        "LSSVC";"SHSVC";"TWSVC";"FinfSVC";"LIBL_L1_sHSVC";"LIBL_L1_LR"]; 
    Mod2pars = ["VV_UL1SVC_b"];
    if nnz(Mod==Mod1par) 
        GM1 = Base.^Power; 
    elseif nnz(Mod==Mod2pars) 
%         [GM1, GM2] = deal( Base.^Power );
        GM1 = Base.^[-8:4:8]; GM2 = Base.^[-4:4:4]; % 自调参数 GM1 = 256; GM2 = 2.^[-4:1:4]
        GM3 = [0, 0.05, 0.2, 0.4]; % 0, 0.02, 0.05, 0.1, 0.2, 0.3, 0.4
    elseif nnz(Mod==["FSUE_LP"])
        [GM1, GM2] = deal( Base.^[-8:1:8] );
        GM3 = 10.^[ -1 : 4 ];  
%         Para.PFT = "ON";
    elseif nnz(Mod==["CUSVM";"CUSVMn"])
%         [GM1, GM2] = deal( Base.^Power ); % 标准选参范围：Base.^[-8:1:8]
%         GM3 = 2.^Power; % 标准选参范围：Base.^[-8:1:8]
%         GM4 = 1;
        GM1 = Base.^[-8:4:8]; GM2 = Base.^[-8:4:8]; GM3 = Base.^[-8:4:8]; GM4 = [0, 0.05, 0.2, 0.4]; % 非线性模型的自调参数
%         GM1 = 256; GM2 = 256; GM3 = 256; GM4 = 1; % 线性模型的自调参数
%         Para.PFT = "ON"; % 是否再精确调节参数
    elseif nnz(Mod==["SVM"])
        Para.SVM = "ON";
        GM1 = Base.^Power;
    end 
    Para.Mod = Mod; 
    SVMFun = str2func(Mod); 
    Para.GM1 = GM1; Para.GM2 = GM2; Para.GM3 = GM3; 
    Para.GM4 = GM4;
    
    for i = "Special Module Trigger"
    Para.FS = 0;    Para.UNI = 0;    
    FS_Mod = [" "];
    UNI_Mod = ["CUSVM";"CUSVMn"; "VV_UL1SVC_b"];
    if nnz(Mod==FS_Mod), Para.FS = 1; end % Feature Selection
    if nnz(Mod==UNI_Mod), Para.UNI = 1; end % Universum
    end
    
    
%% Kernel Options 
% _______◆◆◆Kernel Type Switch◆◆◆_______
%     ktype = "lin"; 
%     ktype = "poly";
%     ktype = "pre";
    ktype = "rbf";
%     ktype = "sig";

% ________ Kernel Parameters ________
    [GK1,GK2] = deal(0); 
    if ktype=="poly"
        GK1 = Base .^ [ 0, 1, log2(3), 2, log2(5) ]; 
        GK2 = 1; 
    elseif ktype=="rbf"
        GK1 = Base .^ [ -6 : 6: 6 ]; 
%         GK1 = 0.0156; % 自调参数
    elseif ktype=="sig"
        GK1 = Base .^ [ 0, 1, log2(3), 2, log2(5) ]; 
        GK2 = 0; 
    end 
    Para.kpar.ktype = ktype;
    Para.GK1 = GK1;    Para.GK2 = GK2; 
    
    
%% Other Options
    for i = "Ⅱ  UnderSampling Switch"
        UndSpl = "OFF";    usr = 1; % UnderSampling Ratio = 1/usr
%         UndSpl = "ON";    usr = 10;    
    end

    for i = "Ⅲ  Data Pre-processing Switch", DatPrep = "No_Prep";
%         DatPrep = "mapminmax_0_1";
%         DatPrep = "mapminmax_-1_1";
%         DatPrep = "zscore";
%         DatPrep = "zscore_pro"; % mean±
    end

    for i = "Ⅳ  ◆◆◆Data Separation Switch◆◆◆"
%         Para.DS = "Training+Validation"; Para.tstp = 0; % TeST Perct 
        Para.DS = "Training+Validation+Testing"; Para.tstp = 0.5; % 0.5 
    end

    for i = "Ⅴ  Major Indicator Relevant", Para.indctmin = "OFF"; 
                    Para.indct = "AC";
%                     Para.indct = "GM";
%                     Para.indctmin = "ON"; % Minor indicator switch 
                    OPLogi = ">="; % [>=] later pars; [>] former pars 
                    Para.OPLogi = str2func(OPLogi);
                    Para.IndctRpt = 10; % Repeat Exprmts 2 gen final indcts
    end

    for i = "Ⅵ  ◆◆◆CV-Method Switch◆◆◆"
        Para.cvp1 = 0;    Para.cvp2 = 0;
        Para.CVM = "Kfold";  Para.cvp1 = 5;
%         Para.CVM = "Kfold";  Para.cvp1 = 10;
%         Para.CVM = "HoldOut";  Para.cvp1 = .25;
%         Para.CVM = "LeaveMOut"; Para.cvp1 = 1;
%         Para.CVM = "Resubstitution"; Para.cvp1 = .7; Para.cvp2 = .7;
%  ___BaseOnClass Switch___
%         Para.BOC = "OFF";
        Para.BOC = "ON";
%  ___MiniElementNum Switch___
%         Para.MEN = "OFF";
        Para.MEN = "ON";
    end

    for Rec = [  ]
    fprintf('___________Experiment Information Recording___________ \n');
    fprintf('Random Seed: rng(%d) \n', seed);
    fprintf('Model Name: %s \n', Mod);
    fprintf('Model Hyper-Parameters: \n');
    fprintf('  p1(#%d) = [%s] \n', length(GM1), num2str(GM1,'%10.2e, '));
    fprintf('  p2(#%d) = [%s] \n', length(GM2), num2str(GM2,'%10.2e, '));
    fprintf('  p3(#%d) = [%s] \n', length(GM3), num2str(GM3,'%10.2e, '));
    fprintf('Kernel Type: %s \n', ktype);
    fprintf('Kernel Hyper-Parameters: \n');
    fprintf('  kp1(#%d) = [%s] \n', length(GK1), num2str(GK1,'%10.2e, '));
    fprintf('  kp2(#%d) = [%s] \n', length(GK2), num2str(GK2,'%10.2e, '));
    fprintf('Hyper-Parameter Groups Number: %d, ', ...
        length(GM1)*length(GM2)*length(GM3)*length(GK1)*length(GK2));
    fprintf('Parameter Fine Tuning: %s \n', Para.PFT);
    fprintf('UnderSampling: %s, Ratio = 1/%d \n', UndSpl, usr);
    fprintf('Data Pre-processing: %s \n', DatPrep);
    fprintf('Data Separation: %s (Test=%.1f) \n', Para.DS, Para.tstp);
    fprintf('Major Indicator: %s, Indicator Repeat: %d×CV \n', Para.indct, Para.IndctRpt);
    fprintf('Minor Indicator: %s, OptParaLogi: %s \n', Para.indctmin, OPLogi);
    fprintf('Cross Validation Method: %s(cvp1=%d,cvp2=%g), BaseOnClass: %s, MiniElementNum: %s \n', ...
        Para.CVM, Para.cvp1, Para.cvp2, Para.BOC, Para.MEN);
    fprintf('￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣\n\n');
    end


%% Automatic Recording Setting

"___■■■ Auto Record Switch ■■■___";
%                 AutoRec = "OFF";
                AutoRec = "ON";
" ￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣";
    fid = -11;  % file id
    if AutoRec == "ON"
    % ________________ Folder Path ________________ 
        DirPth = sprintf('./AutoResult/%s/%s/',Mod, ktype);
        if ~exist(DirPth,'dir'), mkdir(DirPth); end
    % ________________ Time & Note ________________ 
        TIME = datestr(now,'yyyy-mm-dd_HH-MM-SS'); 
        NOTE = ['rng',num2str(seed),'test']; % ■ rng & NOTE ■
    % ________________ File Path ________________ 
        FilePth = sprintf('%s%s_%s_%s.txt', ...
            DirPth , NOTE , Mod , TIME ); 
        fid = fopen(FilePth, 'wt');                                             %   fclose(fid)
        
        if Para.FS == 1 % Feature Selection AutoSave .mat 
            matName = [erase(FilePth,".txt") , '.mat']; 
            FS={};      save(matName, 'FS'), clear FS
            Para.matName = matName;
        end 

        for i = "Recording"
        fprintf(fid,'___________Experiment Information Recording___________ \n'); 
        fprintf(fid,'Launch Time: %s \n', TIME);
        fprintf(fid,'Random Seed: rng(%d) \n', seed);
        fprintf(fid,'Model Name: %s \n', Mod);
        fprintf(fid,'Model Hyper-Parameters: \n');
        fprintf(fid,'  p1(#%d) = [%s] \n', length(GM1), num2str(GM1,'%10.2e, '));
        fprintf(fid,'  p2(#%d) = [%s] \n', length(GM2), num2str(GM2,'%10.2e, '));
        fprintf(fid,'  p3(#%d) = [%s] \n', length(GM3), num2str(GM3,'%10.2e, '));
        fprintf(fid,'Kernel Type: %s \n', ktype);
        fprintf(fid,'Kernel Hyper-Parameters: \n'); 
        fprintf(fid,'  kp1(#%d) = [%s] \n', length(GK1), num2str(GK1,'%10.2e, ')); 
        fprintf(fid,'  kp2(#%d) = [%s] \n', length(GK2), num2str(GK2,'%10.2e, ')); 
        fprintf(fid,'Hyper-Parameter Groups Number: %d, ', ...
            length(GM1)*length(GM2)*length(GM3)*length(GK1)*length(GK2));
        fprintf(fid,'Parameter Fine Tuning: %s \n', Para.PFT);
        fprintf(fid,'UnderSampling: %s, Ratio = 1/%d \n', UndSpl, usr);
        fprintf(fid,'Data Pre-processing: %s \n', DatPrep);
        fprintf(fid,'Data Separation: %s (Test=%.1f) \n', Para.DS, Para.tstp);
        fprintf(fid,'Major Indicator: %s, Indicator Repeat: %d×CV \n', Para.indct, Para.IndctRpt);
        fprintf(fid,'Minor Indicator: %s, OptParaLogi: %s \n', Para.indctmin, OPLogi);
        fprintf(fid,'Cross Validation Method: %s(cvp1=%d,cvp2=%g), BaseOnClass: %s, MiniElementNum: %s \n', ...
            Para.CVM, Para.cvp1, Para.cvp2, Para.BOC, Para.MEN);
        fprintf(fid,'￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣\n\n');
        end
        
    end  % end AutoRec


%% Data Selection & Main Process
rep = 50; EI_train = zeros(rep, 12); Para.EI_train = EI_train;
EI_test = zeros(rep, 6); Para.EI_test = EI_test;
EI_train_AC = zeros(rep, 10); Para.EI_train_AC = EI_train_AC;
All_Para = zeros(rep, 6); Para.P = All_Para;
for re = 1:rep
    Para.re = re;
    Case = 0; XuNo = 0;
    trNumeach = 200; % 如果是二分类问题，那就是trNumeach个正类，trNumeach个负类 [50, 100, 200, 500, 1000]
        for dat = 1
%             [Data,datName] = ArtiGen_lcn4_2_tex; % Artificial data
%             [Data, datName] = MNISTdata(trNumeach, XuNo, Case); % MNIST image data
%             [Data, datName] = KTHdata(trNumeach, XuNo, Case); % KTH image data
            [Data, datName] = GTSRBdata_1(trNumeach, XuNo, Case); % GTSRB image data
%             [Data, datName] = GTSRBdata_2(trNumeach, XuNo, Case); % GTSRB image data
%             [Data, datName] = GTSRBdata_3(trNumeach, XuNo, Case); % GTSRB image data
%             [Data, datName] = GTSRBdata_4(trNumeach, XuNo, Case); % GTSRB image data
%             [Data, datName] = UCIdata(trNumeach); % UCI data
            X = Data.X;    Y = Data.Y;
            clear Xp Xn Yp Yn
            
            if AutoRec == "ON"
            fprintf(fid,'\ni=%d Runing Data:%s\n',dat, datName); end
            fprintf('Random Seed = %d & Method: %s & Kernel: %s & ', seed, Mod, ktype );
            fprintf('Data(i = %d): %s & Repetition %d\n', dat, datName, Para.re);
            if re == rep
                fprintf('************************************************************************************************************************************\n\n');
            end
            Para.datName = datName;  Para.dat = dat;
            
            
            if UndSpl=="ON" % UnderSampling Module
                mp = floor(sum(Y==1)/usr);  mn = floor(sum(Y==-1)/usr);
                id_p = crossvalind('Kfold',Y,usr,'CLASSES',1,'MIN', mp);
                id_n = crossvalind('Kfold',Y,usr,'CLASSES',-1,'MIN', mn);
                id = id_p + id_n ;
                X = X(id==1,:);        Y = Y(id==1);
            end
            
            if DatPrep=="mapminmax_0_1" % Pre-processing Module
                X = mapminmax(X',0,1)';
            elseif DatPrep=="mapminmax_-1_1"
                X = mapminmax(X',-1,1)';
            elseif DatPrep=="zscore"
                [X,~,~] = zscore(X);
            elseif DatPrep=="zscore_pro"
                [X,~,~] = zscore_pro(X,Y);
            end
            
            for i = "Label Noise Switch", Para.flip_lv = 0;
                %             flip_lv = 5;
                %             Y = FlipLabel( Y , flip_lv );
                %             Para.flip_lv = 10; % noise level \in [0,0.5)
            end
            
            for i = "Data Reorder" % [Neg;Pos]
                ip = Y==1;     in = Y==-1;
                Xp=X(ip,:);     Xn=X(in,:);      X=[Xn;Xp];
                Yp=Y(ip);        Yn=Y(in);        Y=[Yn;Yp];
            end
            
            Data.X = X;    Data.Y = Y;     clear Xp Xn Yp Yn X Y
            Para.drw = 1; % 开启画图
            
            if Mod ~= "SVM" && Mod ~= "LSSVC"
            U = [];
            G = length(Data.Ux);
            for i = 1:G
                U =[U; Data.Ux{i}];
            end
            Data.Umat = U;            
            end
            
            
            "__________________◆◆◆Grid Search Process◆◆◆__________________";
            [Perfm, Para, Model] = GridParaSearch_C(Data, SVMFun, Para, fid);
            "￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣";
            
            
        end
%     end
end
    EI_train = Para.EI_train; EI_train_AC = Para.EI_train_AC; EI_test = Para.EI_test; All_Para = Para.P;
    Best_EI_train = []; Best_EI_train_AC = []; Best_EI_test = []; Best_Para = [];
%     [~, ind] = ismember(max(EI_train(:, 1)), EI_train(:, 1), 'rows');
%     [~, indd] = ismember(max(EI_test(:, 1)), EI_test(:, 1), 'rows');
    [~, ind] = ismember(min(EI_train(:, 1)), EI_train(:, 1), 'rows');
    [~, indd] = ismember(min(EI_test(:, 1)), EI_test(:, 1), 'rows');
    A = EI_train(ind, :); B = EI_train_AC(ind, :); C = EI_test(indd, :); tt = 'Test'; D = All_Para(ind, :);
    Best_EI_train = [Best_EI_train; A]; Best_EI_train_AC = [Best_EI_train_AC; B]; Best_EI_test = [Best_EI_test; C]; Best_Para = [Best_Para; D];
    if Para.indct == "AC", tmp = B; elseif Para.indct == "GM", tmp = B; end

    fprintf('Grid Parameter Seaching is over: \n');
    fprintf('---------------------------------------- Optimal Parameters ----------------------------------------\n');
    fprintf('p1:%.4f    p2:%.4f    p3:%.4f    p4:%.4f    kp1:%.4f    kp2:%.2f', D(1), D(2), D(3), D(4), D(5), D(6));
    fprintf('\n---------------------------------------------------------------------------------------------------\n\n');

    fprintf('Times %d CrossValidation Experments with Opt-Paras are Starting......\n', Para.IndctRpt);
    fprintf('---------------------------------------- %d×%s Performance ----------------------------------------\n', Para.IndctRpt, Perfm.CVM);
    fprintf('%d×%s: [', Para.IndctRpt, Para.indct);        fprintf('%.4f ', tmp);       fprintf(']');
    fprintf('\nmAcc:%.4f | sAcc:%.4f    mGM:%.4f | sGM:%.4f\n', A(1), A(2), A(3), A(4));
    fprintf('mSen:%.4f | sSen:%.4f    mSpe:%.4f | sSpe:%.4f\n', A(5), A(6), A(7), A(8));
    fprintf('mTime:%.6f(%.6f)    mN_SV:%.2f(%.2f)\n', A(9), A(10), A(11), A(12));
    fprintf('---------------------------------------------------------------------------------------------------\n\n');

    fprintf('%s Data Experment with Opt-Paras is Starting......\n', tt);
    fprintf('---------------------------------------- %s Performance ----------------------------------------\n', tt);
    fprintf('tAcc:%.4f  |  tGM:%.4f  |  tSen:%.4f  |  tSpe:%.4f\n', C(1), C(2), C(3), C(4));
    fprintf('tTime:%.6f  |  tN_SV:%d', C(5), C(6));
    fprintf('\n---------------------------------------------------------------------------------------------------\n\n');
    ValPth = sprintf('./AutoResult/%s/%s & %s & trNum_%d/Case %d/[%s]', Mod, datName, 'NumResult', trNumeach, Case, join(string(XuNo), ', '));
    mkdir(ValPth); result = strcat(ValPth, '/', 'Matrix.mat');
    save(result, 'EI_train', 'EI_train_AC', 'EI_test', 'All_Para', 'Best_EI_train', 'Best_EI_train_AC', 'Best_EI_test', 'Best_Para');

    if AutoRec == "ON", fclose(fid); end
    fprintf(' ExpAutoRuning is over !\n\n');
    fprintf('************************************************************************************************************************************\n\n');
    % status = fclose('all');
    
    
%% Plot Decisive Surface in 2-D Data
    if n == 2 % 2D plot
        close,
        handle = Plot2d_DecSurf(Data,SVMFun,Para);
    end
    % 画图去白边代码：set(gca, 'LooseInset', get(gca, 'TightInset'));
end



