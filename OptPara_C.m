function [Bst_indct, Bst_indct2, Opt] = OptPara_C(Perfm,model,Para,Bst_indct,Bst_indct2,Opt)
% The principles of choosing [Opt]imal [Para]meters in [C]lassification.
% 
% Input: 
%     Perfm - Performance at Para, contains many indicators
%     model - model at Para, contains many indicators
%     Para - Current parameters 
%     Best_indct - Former best major indicator 
%     Best_indct2 - Former best minor indicator 
% Output: 
%     Best_indct - New best major indicator 
%     Best_indct2 - New best minor indicator 
%     Opt - New optimal parameters under certain conditions 
% 
% Written by Lingwei Huang, lateset update: 2021.11.16. 
% Copyright 2021  Lingwei Huangâ„?. 

%% Major Indicator Declaration & Initialization 
    if Para.indct=="AC"
        Crt_indct = Perfm.Ac;
    elseif Para.indct=="GM"
        Crt_indct = Perfm.GM;
    end % Current Indicator
    OPLg = Para.OPLogi; % Optimal Para Logical operation, [>=] or [>]
%     tol = 1; % tolerant unit(%), determines whether to accept/discard pars
%     mmr = 2; % major/minor rate, measures the importance of indicators

%% Minor Indicator [spsR] in Feature Selection 
% % added minor indicator spsR (sparse Rate, % of useless features)
    if Para.indctmin == "ON" && Para.FS==1
        tol = 1; % tolerant unit(%), determines whether to accept/discard pars
        mmr = 2; % major/minor rate, measures the importance of indicators
        Rindct = (Crt_indct - Bst_indct) / abs(Bst_indct) * 100;
        DspsR =   model.spsR - Bst_indct2;
        if OPLg(Crt_indct , Bst_indct) 
            if ~(Rindct<tol && DspsR<-tol*mmr) 
                % ~(AC increase little, spsR decrease much, discard) 
                Bst_indct = Crt_indct;
                Bst_indct2 = model.spsR;
                Opt.p1 = Para.p1;       Opt.p2 = Para.p2;       Opt.p3 = Para.p3;      Opt.p4 = Para.p4;
                Opt.kp1 = Para.kpar.kp1;            Opt.kp2 = Para.kpar.kp2;
            end
        else % Current_indct < Best_indct
            if (Rindct>-tol && DspsR>tol*mmr) 
                % (AC decrease little, spsR increase much, accept) 
                Bst_indct = Crt_indct;
                Bst_indct2 = model.spsR;
                Opt.p1 = Para.p1;       Opt.p2 = Para.p2;       Opt.p3 = Para.p3;   Opt.p4 = Para.p4;
                Opt.kp1 = Para.kpar.kp1;            Opt.kp2 = Para.kpar.kp2;
            end
        end
        return % neglect later codes and return to outer func 
    end

%% Standard Para Collection Module (Major Indicator only)

    if Para.UNI==1 && Para.FS==1 % FS%UNI, need Cu<Cr 
        if Crt_indct > Bst_indct 
            Bst_indct = Crt_indct;
            Opt.p1 = Para.p1;       Opt.p2 = Para.p2;       Opt.p3 = Para.p3;    Opt.p4 = Para.p4;
            Opt.kp1 = Para.kpar.kp1;            Opt.kp2 = Para.kpar.kp2;
        elseif Crt_indct == Bst_indct  &&  ... 
                Para.p1/Para.p2 <= Opt.p1/Opt.p2 % Cu/Cr later <= former
            Bst_indct = Crt_indct; 
            Opt.p1 = Para.p1;       Opt.p2 = Para.p2;       Opt.p3 = Para.p3;   Opt.p4 = Para.p4;
            Opt.kp1 = Para.kpar.kp1;            Opt.kp2 = Para.kpar.kp2;
        end
    elseif OPLg(Crt_indct , Bst_indct) % ___â–? Classic Para Collection â– ___
        Bst_indct = Crt_indct;
        Opt.p1 = Para.p1;       Opt.p2 = Para.p2;       Opt.p3 = Para.p3;   Opt.p4 = Para.p4;
        Opt.kp1 = Para.kpar.kp1;            Opt.kp2 = Para.kpar.kp2;
    end
            
    
end


%_____________________ Classic Para Collection _____________________
%     if OPLogi(Crt_indct , Bst_indct) 
%         Bst_indct = Crt_indct;
%         Opt.p1 = Para.p1;       Opt.p2 = Para.p2;       Opt.p3 = Para.p3;
%         Opt.kp1 = Para.kpar.kp1;            Opt.kp2 = Para.kpar.kp2;
%     end

