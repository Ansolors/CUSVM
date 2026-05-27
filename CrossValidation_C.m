function [Perfm , model] = CrossValidation_C( Data , SVMFun , Para )
% This function is used for implement CrossValidation on the input 
% Data [Data] based on model [SVMFun] and Parameters [Para]. 
% The main processes include Cross-Validation-Index Division 
% and Valaluation Indices Collection. 
% -- Only suitable for binary classification right now. --
% 
% Written by Lingwei Huang, lateset update: 2021.11.12. 
% Copyright 2019-2021  Lingwei Huang. 

%% Data Input
    X = Data.X;        Y = Data.Y;        [~,n]=size(X); 
    if Para.UNI==1, Trn.Ux=Data.Ux; Trn.Umat=Data.Umat; Trn.Uy=Data.Uy; end
	clear Data

%% Cross-Validation-Index Division

	CVM = Para.CVM;    BOC = Para.BOC;    MEN = Para.MEN; 
                
    if CVM=="Kfold" 
        K = Para.cvp1; % # of disjoint subsets, [5] default 
        if BOC=="ON"
                if MEN=="ON"
                    men_p = floor(sum(Y==1)/K); 
                    men_n = floor(sum(Y==-1)/K); 
                    ind_p = crossvalind('Kfold',Y,K,'CLASSES',1,'MIN', men_p); 
                    ind_n = crossvalind('Kfold',Y,K,'CLASSES',-1,'MIN', men_n); 
                elseif MEN=="OFF"
                    ind_p = crossvalind('Kfold',Y,K,'CLASSES',1); 
                    ind_n = crossvalind('Kfold',Y,K,'CLASSES',-1); 
                end
                ind = ind_p + ind_n ;
            elseif BOC=="OFF"
                if MEN=="ON"
                    men = floor(length(Y)/K); 
                    ind = crossvalind('Kfold',Y,K,'MIN',men); 
                elseif MEN=="OFF"
                    ind = crossvalind( 'Kfold' , Y , K ); % default 
                end
        end 
    end % end Kfold
    
    if CVM=="HoldOut" 
        P = Para.cvp1; % the proportion of the Valaluation set, [0.5] default
        if BOC=="ON"
            [ ind_trn_p , ind_val_p ] = crossvalind( 'HoldOut' , Y , P ,'CLASSES',1);
            [ ind_trn_n , ind_val_n ] = crossvalind( 'HoldOut' , Y , P ,'CLASSES',-1);
            ind_trn = logical(ind_trn_p + ind_trn_n);
            ind_val = logical(ind_val_p + ind_val_n);
        else 
            [ ind_trn , ind_val ] = crossvalind( 'HoldOut' , Y , P );
        end
    end % end HoldOut
    
    if CVM=="LeaveMOut" 
        M = Para.cvp1; % # of the Valaluation set, [1] default
        [ ind_trn , ind_val ] = crossvalind( 'LeaveMOut' , Y , M );
    elseif CVM=="Resubstitution" 
        P = Para.cvp1; % the proportion of the Valaluation set, [1] default 
        Q = Para.cvp2; % the proportion of the training set, [1] default 
        [ ind_trn , ind_val ] = crossvalind( 'Resubstitution' , Y , [P,Q] );
    end 

%% Cross-Validation Main Process

    if CVM=="Kfold" 
        [Perfm.n_SV, Perfm.tr_time, PredYs, ValYs] = deal( [] ); 
        if Para.FS==1, wids=zeros(n,1);end
        for i = 1 : K
            ind_val = (ind == i);         ind_trn = ~ind_val; 
            Trn.X = X(ind_trn,:);         Trn.Y = Y(ind_trn,:); 
            Val.X = X(ind_val,:);         Val.Y = Y(ind_val,:); 
            if Para.flip_lv ~= 0 % used 4 label noise control
                Trn.Y = FlipLabel( Trn.Y , Para.flip_lv );
                Val.Y = FlipLabel( Val.Y , Para.flip_lv );
            end
            if Para.SVM == "ON"
                [PredY, model] = SVMFun(Val.X, Trn, Para);
                Perfm.tr_time = [Perfm.tr_time, model.time];
                PredYs = [PredYs;PredY];            ValYs = [ValYs;Val.Y];
            else
                "_____¡ö¡ö¡ö Modeling and Predicting ¡ö¡ö¡ö_____";
                [PredY, model] = SVMFun(Val.X, Trn, Para);
                "£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ";
                Perfm.n_SV = [Perfm.n_SV, model.n_SV];
                Perfm.tr_time = [Perfm.tr_time, model.tr_time];
                PredYs = [PredYs;PredY];            ValYs = [ValYs;Val.Y];
                if Para.FS==1, wids=wids+model.w_ind; end
            end
        end 
        if Para.FS==1,model.wids = wids;end
    end
    
    if CVM=="HoldOut"  
        Trn.X = X(ind_trn,:);   	Trn.Y = Y(ind_trn,:);
        Val.X = X(ind_val,:);      	 Val.Y = Y(ind_val,:);  
        "_____¡ö¡ö¡ö Modeling and Predicting ¡ö¡ö¡ö_____";
        [PredY,model] = SVMFun( Val.X , Trn , Para );
        "£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ£þ";
        PredYs = PredY;             ValYs = Val.Y;
    end 
    
    CM = ConfusionMatrix( PredYs, ValYs );
    
%% Valuation Indices Collection
if Para.SVM == "ON"
    Perfm.Ac = CM.Ac;
    Perfm.Er = CM.Er;
    Perfm.Sen = CM.Sen;
    Perfm.Spe = CM.Spe;
    Perfm.GM = CM.GM;
    if CVM=="Kfold"
        Perfm.n_SV = 0;
        Perfm.tr_time = mean(Perfm.tr_time);
    elseif CVM=="HoldOut"
        Perfm.n_SV = 0;
        Perfm.tr_time = model.tr_time;
    end
    Perfm.CVM = CVM;
else
    Perfm.Ac = CM.Ac;
    Perfm.Er = CM.Er;
    Perfm.Sen = CM.Sen;
    Perfm.Spe = CM.Spe;
    Perfm.GM = CM.GM;
    if CVM=="Kfold"
        Perfm.n_SV = mean(Perfm.n_SV);
        Perfm.tr_time = mean(Perfm.tr_time);
    elseif CVM=="HoldOut"
        Perfm.n_SV = model.n_SV;
        Perfm.tr_time = model.tr_time;
    end
    if Para.FS == 1
        Perfm.spsN = model.spsN;
        Perfm.nFea = model.nFea;
        Perfm.spsR = model.spsR;
    end
    Perfm.CVM = CVM;
end


end % Func end






