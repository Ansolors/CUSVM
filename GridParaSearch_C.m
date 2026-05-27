function [ Perfm, Para, model ] = GridParaSearch_C( Data, SVMFun, Para, fid )
% This function is used to implement Grid-Search on Parameters.
% This program is used to run datasets in MNIST & KTH & GTSRB. 
% Written by YIFAN-QI, Latest updata: 2023-04-18 

IndctRec1 = [];      IndctRec2 = []; 

%% Data Separation & Generation 

    if Para.DS=="Training+Validation+Testing"
        [trnval_p, tst_p] = crossvalind('HoldOut', Data.Y, Para.tstp,'CLASSES',1);
        [trnval_n, tst_n] = crossvalind('HoldOut', Data.Y, Para.tstp,'CLASSES',-1);
        trnval=logical(trnval_p+trnval_n);    tst=logical(tst_p+tst_n);
        Data.TstX = Data.X(tst,:);      Data.TstY = Data.Y(tst,:);
        Data.X = Data.X(trnval,:);      Data.Y = Data.Y(trnval,:);
    end
    [~,n] = size(Data.X);

%%  Parameters' Selection Range 

    indct = Para.indct;        
    Grid_M1 = Para.GM1;    Grid_M2 = Para.GM2;    Grid_M3 = Para.GM3;   Grid_M4 = Para.GM4; 
    Grid_K1 = Para.GK1;    Grid_K2 = Para.GK2;
    Bst_indct = -1;        Bst_indct2 = 0;        Opt = struct();
    Prcs = 0; 
	
    for i = "◆◆Manual Para Setting Switch◆◆"
%  ┌────────────────────────────────────┐
%  │   -8   │  -7    │    -6   │   -5   │   -4   │   -3    │   -2   │   -1   │
%  │.0039│.0078│.0156│.0313│.0625│.1250│.2500│.5000│
%  ├────────────────────────────────────┤
%  │  +8   │  +7  │   +6   │  +5   │  +4   │  +3   │  +2   │  +1   │
%  │ 256  │ 128  │   64   │   32  │   16   │    8    │    4    │    2   │
%  └────────────────────────────────────┘
        MPS = "OFF"; 
%         MPS = "ON";    Perfm.CVM='MPS';
    if MPS=="ON"
        Opt.p1 = 2^6;   % 1
        Opt.p2 = -.8;   % -2
        Opt.p3 = 2^2;   % 1
        Opt.p4 = 10^2;   % 1
        Opt.kp1 = 2^0;           Opt.kp2 = 2^0;
    end 
    end
    
    for i = "Small Scale Test Switch"
        SST = "OFF"; 
%         SST = "ON"; 
    if SST=="ON" 
        Grid_M1 = 2.^[-5:.2:-3];
        Grid_M2 = 2.^[-4:.2:-2];
        Grid_M3 = 2.^[-4:.2:-2];
        Grid_M4 = 10.^[-3:.5:-1]; 
        Grid_K1 = 0;
    end 
    end
    
%%  Grid-Search on Parameters 
%     bestAC = 0;
for i_m1 = Grid_M1
    if MPS=="ON", break, end
    for i_m2 = Grid_M2
        for i_m3 = Grid_M3
            for i_m4 = Grid_M4
                for i_k1 = Grid_K1
                    for i_k2 = Grid_K2
                        Para.p1 = i_m1;     Para.p2 = i_m2;     Para.p3 = i_m3;  Para.p4 = i_m4;
                        Para.kpar.kp1 = i_k1;              Para.kpar.kp2 = i_k2;
                        
                        
                        "______________■■■ Cross Validation ■■■______________";
                        [Perfm, model] = CrossValidation_C(Data, SVMFun, Para);
                        " ￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣";
                        
                        
                        [ Bst_indct , Bst_indct2 , Opt ] = OptPara_C(Perfm, model, Para, Bst_indct, Bst_indct2, Opt);
                    end % Grid_K2
                end % Grid_K1
            end % Grid_M4
        end % Grid_M3
    end % Grid_M2
end % Grid_M1

%     if Para.PFT == "ON" % Para Fine-Tuning 
% %         Grid_M1 = Opt.p1; 
%         if Opt.p1==2^8, Grid_M1 = [Opt.p1/2 , Opt.p1]; 
%         elseif Opt.p1==2^-8, Grid_M1 = [Opt.p1 , Opt.p1*2]; 
%         else, Grid_M1 = [Opt.p1/2 , Opt.p1 , Opt.p1*2]; 
%         end
% %         Grid_M2 = Opt.p2; 
%         b = 2;    lb = -6;    ub = 10; 
% %         b = 10;    lb = -1;    ub = 3; 
%         if Opt.p2==b^ub, Grid_M2 = [Opt.p2/b , Opt.p2]; 
%         elseif Opt.p2==b^lb, Grid_M2 = [Opt.p2 , Opt.p2*b]; 
%         else, Grid_M2 = [Opt.p2/b , Opt.p2 , Opt.p2*b]; 
%         end
%         
%         if Opt.p3==b^ub, Grid_M3 = [Opt.p3/b , Opt.p3]; 
%         elseif Opt.p3==b^lb, Grid_M3 = [Opt.p3 , Opt.p3*b]; 
%         else, Grid_M3 = [Opt.p3/b , Opt.p3 , Opt.p3*b]; 
%         end
%         
%         pwr4 = log10(Opt.p4); 
%         if pwr4==3, Grid_M4 = 10.^[pwr4-1 : .1 : pwr4]; 
%         elseif pwr4==-3, Grid_M4 = 10.^[pwr4 : .1 : pwr4+1]; 
%         else, Grid_M4 = 10.^[pwr4-1 : .1 : pwr4+1]; 
%         end
%         fprintf('Parameter Fine Tuning is Starting (%d)... \n',...
%             length(Grid_M1)*length(Grid_M2)*length(Grid_M3)*length(Grid_M4));
%     for i_m1 = Grid_M1 
%     for i_m2 = Grid_M2 
%     for i_m3 = Grid_M3 
%     for i_m4 = Grid_M4 
%         for i_k1 = Grid_K1 
%         for i_k2 = Grid_K2 
%             Para.p1 = i_m1;     Para.p2 = i_m2;     Para.p3 = i_m3;    Para.p4 = i_m4; 
%             Para.kpar.kp1 = i_k1;              Para.kpar.kp2 = i_k2; 
%             [Perfm,model] = CrossValidation_C(Data,SVMFun,Para);
%             [ Bst_indct , Bst_indct2 , Opt ] = OptPara_C (Perfm, model, Para, Bst_indct, Bst_indct2, Opt);
%         end % GK2 
%         end % GK1
% %         IndctRec1 = [IndctRec1,Perfm.Ac]; 
%     end % GM4
%     end % GM3
% %     IndctRec2 = [IndctRec2;IndctRec1];    IndctRec1 = [];
%     end % GM2
%     end % GM1
% %         hd = surf(log10(Grid_M3),log2(Grid_M2),IndctRec2, 'FaceAlpha',0.8);
%         fprintf('%s:%.4f, p1:%.4f, p2:%.4f, p3:%.4f, p4:%.4f, kp1:%.4f, kp2:%.1f\n',...
%             indct, Bst_indct, Opt.p1, Opt.p2, Opt.p3, Opt.p4, Opt.kp1, Opt.kp2); 
%     end % if ON 
    

%%  Optimal Parameters Record 

%     fprintf('Grid Parameter Seaching is over: \n');
    Para.p1 = Opt.p1;      Para.p2 = Opt.p2;      Para.p3 = Opt.p3;     Para.p4 = Opt.p4;
    Para.kpar.kp1 = Opt.kp1;               Para.kpar.kp2 = Opt.kp2;
    [Para.P(Para.re, 1), Para.P(Para.re, 2), Para.P(Para.re, 3), Para.P(Para.re, 4), ...
        Para.P(Para.re, 5), Para.P(Para.re, 6)] = deal(Para.p1, Para.p2, Para.p3, Para.p4, Para.kpar.kp1, Para.kpar.kp2);

%     fprintf('---------------------------- Optimal Parameters ----------------------------\n');
%     fprintf('p1:%.4f    p2:%.4f    p3:%.4f    p4:%.4f    kp1:%.4f    kp2:%.2f',Opt.p1,Opt.p2,Opt.p3,Opt.p4,Opt.kp1,Opt.kp2);
%     fprintf('\n------------------------------------------------------------------------------------\n\n');

%%  C-Times CrossValidation Performance 

    rpt = Para.IndctRpt; % [repeat]-times CV, takes the mean
%     fprintf('Times %d CrossValidation Experments with Opt-Paras are Starting... \n', rpt);
%     fprintf('---------------------------- %d×%s Performance ----------------------------\n', rpt, Perfm.CVM);
    [Acs,GMs,Times,Sens,Spes,N_SVs,spsNs,spsRs] = deal( zeros(rpt,1) ); 
    widS = zeros(n,1); 
%     Para.flip_lv = 10; % used 4 label noise control
    for ir = 1 : rpt 
        [Perfm, model] = CrossValidation_C(Data, SVMFun, Para); % ■■■
        Acs(ir) = Perfm.Ac;                GMs(ir) = Perfm.GM;
        Sens(ir) = Perfm.Sen;            Spes(ir) = Perfm.Spe;
        Times(ir) = Perfm.tr_time;    N_SVs(ir) = Perfm.n_SV; 
        if Para.FS==1 
            spsNs(ir)=Perfm.spsN;      spsRs(ir)=Perfm.spsR; 
            widS = widS + model.wids; 
        end  
    end 
    if indct=="AC", tmp = Acs; elseif indct=="GM", tmp = GMs; end 
    m_all = num2cell(mean([Acs,GMs,Sens,Spes,Times,N_SVs])); % 均值
    [mAc,mGM,mSen,mSpe,mTime,mN_SV] = m_all{:}; 
    s_all = num2cell(std([Acs,GMs,Sens,Spes,Times,N_SVs])); % 标准差
    [sAc,sGM,sSen,sSpe,sTime,sN_SV] = s_all{:}; 
%     fprintf('%d×%s: [', rpt, indct);        fprintf('%.4f ',tmp);       fprintf(']');
%     fprintf('\nmAcc:%.4f | sAcc:%.4f     mGM:%.4f | sGM:%.4f\n', mAc, sAc, mGM, sGM );
%     fprintf('mSen:%.4f | sSen:%.4f     mSpe:%.4f | sSep:%.4f\n', mSen, sSen, mSpe, sSpe );
%     fprintf('mTime:%.6f(%.6f)\tmN_SV:%.2f(%.2f)', mTime, sTime, mN_SV, sN_SV );
    if Para.FS==1 
        mspsN=mean(spsNs); sspsN=std(spsNs); mspsR=mean(spsRs); sspsR=std(spsRs); 
        fprintf('\nmspsN:%.1f(in%d) | sspsN:%.2f\tmspsR:%.4f | sspsR:%.2f', mspsN, n, sspsN, mspsR, sspsR ); 
    end
%     fprintf('\n------------------------------------------------------------------------------------\n\n');
    [Para.EI_train(Para.re, 1), Para.EI_train(Para.re, 2), Para.EI_train(Para.re, 3), Para.EI_train(Para.re, 4), ...
        Para.EI_train(Para.re, 5), Para.EI_train(Para.re, 6), Para.EI_train(Para.re, 7), Para.EI_train(Para.re, 8), ...
        Para.EI_train(Para.re, 9), Para.EI_train(Para.re, 10), Para.EI_train(Para.re, 11), Para.EI_train(Para.re, 12)] ...
        = deal(mAc, sAc, mGM, sGM, mSen, sSen, mSpe, sSpe, mTime, sTime, mN_SV, sN_SV);
    Para.EI_train_AC(Para.re, :) = Acs;
    

%%  Test/Total Performance 
    
    if Para.DS=="Training+Validation+Testing" % ___ Test Performance
        rpt = Para.IndctRpt; % [repeat]-times CV, takes the mean
        for ir = 1 : rpt
            [PredY, Model] = SVMFun( Data.TstX , Data , Para ); % ■■■
            CM = ConfusionMatrix( PredY, Data.TstY );    tt = 'Test';
            [tAc(ir), tGM(ir), tSen(ir), tSpe(ir)] = deal(CM.Ac, CM.GM, CM.Sen, CM.Spe);
            tTime(ir) = Model.tr_time;    tN_SV(ir) = Model.n_SV;
        end
    elseif Para.DS=="Training+Validation"         % ___ Total Performance 
        [PredY, Model] = SVMFun( Data.X , Data , Para ); 
        CM = ConfusionMatrix( PredY, Data.Y );    tt = 'Total'; 
    end
%     [~, ind] = ismember(max(tAc)', tAc', 'rows'); % ■
    [~, ind] = ismember(min(tAc)', tAc', 'rows'); % ■
%     fprintf('%s Data Experment with Opt-Paras is Starting... \n', tt);
%     fprintf('---------------------------- %s Performance ----------------------------\n\n', tt);
%     fprintf('tAcc:%.4f  |  tGM:%.4f  |  tSen:%.4f  |  tSpe:%.4f\n', tAc(ind), tGM(ind), tSen(ind), tSpe(ind));
%     fprintf('tTime:%.6f  |  tN_SV:%d', tTime(ind), tN_SV(ind));
    if Para.FS==1,fprintf('  |  tsprsN:%d(in%d)  |  tspsR:%.2f', Model.spsN, n, Model.spsR);end
%     fprintf('\n------------------------------------------------------------------------------------\n\n');
    [Para.EI_test(Para.re, 1), Para.EI_test(Para.re, 2), Para.EI_test(Para.re, 3), Para.EI_test(Para.re, 4), ...
        Para.EI_test(Para.re, 5), Para.EI_test(Para.re, 6)] = deal(tAc(ind), tGM(ind), tSen(ind), tSpe(ind), tTime(ind), tN_SV(ind));

    
%%  Auto Write In 

    if fid ~= -11 
        fprintf(fid,'---------------------------- Optimal Parameters ----------------------------\n');
        fprintf(fid,'p1:%.4f    p2:%.4f    p3:%.4f    p4:%.4f    kp1:%.4f    kp2:%.2f',...
                Opt.p1, Opt.p2, Opt.p3, Opt.p4, Opt.kp1, Opt.kp2 );  
        fprintf(fid,'\n------------------------------------------------------------------------------------\n');
% C-Times CrossValidation Performance
        fprintf(fid,'---------------------------- %d×%s Performance ----------------------------\n', rpt, Perfm.CVM);
        fprintf(fid,'%d×%s: [', rpt, indct);        fprintf(fid,'%.4f ',tmp);       fprintf(fid,']');
        fprintf(fid,'\nmAcc:%.4f | sAcc:%.4f      mGM:%.4f | sGM:%.4f\n', mAc, sAc, mGM, sGM );
        fprintf(fid,'mSen:%.4f | sSen:%.4f      mSpe:%.4f | sSpe:%.4f\n', mSen, sSen, mSpe, sSpe );
        fprintf(fid,'mTime:%.6f(%.6f)\tmN_SV:%.2f(%.2f)', mTime, sTime, mN_SV, sN_SV );
        if Para.FS==1 
            fprintf(fid,'\nmspsN:%.1f(in%d) | sspsN:%.2f\tmspsR:%.4f | sspsR:%.2f',mspsN,n,sspsN,mspsR,sspsR);end 
        fprintf(fid,'\n------------------------------------------------------------------------------------\n');
% Test / Total Performance 
        fprintf(fid,'---------------------------- %s Performance ----------------------------\n', tt);
        fprintf(fid,'tAcc:%.4f  |  tGM:%.4f  |  tSen:%.4f  |  tSpe:%.4f\n', tAc, tGM, tSen, tSpe);
        fprintf(fid,'tTime:%.6f  |  tN_SV:%d', tTime, tN_SV);
        if Para.FS==1,fprintf(fid,'  |  tsprsN:%d(in%d)  |  tspsR:%.2f', Model.spsN, n, Model.spsR);end
        fprintf(fid,'\n------------------------------------------------------------------------------------\n\n');
% Feature Selection AutoSave .mat Module 
        if Para.FS==1 
            matName=Para.matName; datName=Para.datName;	dat=Para.dat;
            tw=Model.w; twid=Model.w_ind; tspsN=Model.spsN; tspsR=Model.spsR;
            load(matName, 'FS')
            FS{dat,1} = [num2str(dat),'-',datName];
            FS{dat,2} = sprintf('cvAc: %.2f',mAc);
            FS{dat,3} = sprintf('tAc: %.2f',tAc);
            FS{dat,4} = 'cvwidR';                                  FS{dat,6} = 'tw'; 
            FS{dat,5} = widS/rpt/ceil(Para.cvp1);      FS{dat,7} = tw; 
            FS{dat,8} = 'twid'; FS{dat,10} = 'tspsN';  FS{dat,12} = 'tspsR';
            FS{dat,9} = twid;   FS{dat,11} = tspsN;    FS{dat,13} = tspsR;
            save(matName, 'FS', '-append')
        end % end FS
    end % end fid

end % end Func 


%     % ________________ Opt Para Collection ________________
%     if indct=="AC", Latest_indct = Perfm.Ac;
%     elseif indct=="GM", Latest_indct = Perfm.GM; end
%     if Latest_indct >= Best_indct % [>]former pars; 5[>=]later pars
%         Best_indct = Latest_indct;
%         Opt.p1 = Para.p1;      Opt.p2 = Para.p2;      Opt.p3 = Para.p3;
%         Opt.kp1 = Para.kpar.kp1;               Opt.kp2 = Para.kpar.kp2;
%     end %￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣

