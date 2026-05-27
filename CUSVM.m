function [ PredictY , model ] = CUSVM( ValX , Trn , Para )
% Solving [Feature Selection by Universum Embedding SVC] via QP.  
% PRIMAL: 
% min   (1/m)*em'*xi  + Cu*e2n'*xi + Cr*eG*eta
%  s.t . wx - b1 <= -eps + xi, idn, 
%         wx - b2 >=   eps - xi, idp, 
%         wx - b2 <= -eps + xi, idu1, 
%         wx - b1 >=   eps - xi, idu2, 
%         wx <=  xi, idu3, 
%         wx >= -xi, idu4, 
%         b1 <= b2, 
%         xi >= 0, id. 
%         eta >= 0, id. 
% _______________________________ Input  _______________________________
%      Trn.X  -  m x n matrix, explanatory variables in training data 
%      Trn.Y  -  m x 1 vector, response variables in training data 
%      Trn.Ux  -  (4*n) x n vector, Universum data
%      Trn.Uy  -  (4*n) x 1 matrix, Universum label 
%      ValX   -  mt x n matrix, explanatory variables in Validation data 
%      Para.p1  -  the emperical risk parameter C 
%      Para.p2  -  the Universum parameter Cu 
%      Para.p3  -  the xxx parameter epsilon 
%      Para.kpar  -  kernel para, include type and para value of kernel
% ______________________________ Output  ______________________________
%     PredictY  -  mt x 1 vector, predicted response variables for TestX 
%     model  -  model related info: alpha, b, nSV, time, etc.
% 
% Written by Chunna Li.
% Modefied by Lingwei Huang, lateset update: 2021.11.03. 
% Copyright 2021  Chunna Li & Lingwei Huang. 

%% Input 
    X = Trn.X;      	    Y = Trn.Y;   % ori data
    U = [];  %   All Uni data
    G = length(Trn.Ux);  % The number of types of Uni data
    for i = 1:G
        U = [U; Trn.Ux{i}];
        [u(i),~] = size(Trn.Ux{i});
    end
    [m,n] = size(X);
    mu = sum(u);
    ucum = [0, cumsum(u)];
    
    C = Para.p1;   % PosNeg Classification penalty C
    Cu = Para.p2;   % Uni Classification penalty Cu 
    Cr = Para.p3;    % Uni FS Regularizor Cr 
%     Cr = Cu * Cr; 
    epsln = Para.p4; % epsilon 
%     kpar = Para.kpar; 
    
%% Initilization
    tt = tic; 
    m1 = sum(Y == -1);  %  m1
    m2 = sum(Y == 1);   %  m2       
    
    em1 = ones(m1,1);         
    em2 = ones(m2,1);           
    eG = ones(G,1); 
    
    zn = zeros(n,1); 
    zm1 = zeros(m1,1);
    zm2 = zeros(m2,1);
    zG = zeros(G,1);
    ZGmu = zeros(G,mu);
    Z2Gm = zeros(2*G,m);
    
    Em = eye(m);
    E2G = eye(2*G);

    quadoptions = optimoptions('quadprog','Display','off');
    linoptions = optimoptions('linprog','Display','off');
    
    

%% Solving  
    HA = zeros(n+2+m+2*G, n+2+m+2*G);
    HA(1:n, 1:n) = eye(n) + 2*Cr*(U'*U)/mu;
    HA(n+1:n+2, n+1:n+2) = 0.5*Cr*[1, 1; 1, 1];
    Hwb = Cr*[1;1]*sum(U)/mu;
    HA(1:n, n+1:n+2) = -Hwb';
    HA(n+1:n+2, 1:n) = -Hwb;
    fA = [zn; 0; 0; C*[em1;em2]/m; 0.5*Cu*[eG;eG]/G];
    dA = -epsln*[ones(m+2*G,1); 0];
    LA = [-inf*ones(n+2,1); zeros(m+2*G,1)];
    dBeq = [eG; eG];
    fB = [zeros(2*mu,1); eG; eG];
    LB = zeros(2*mu + 2*G, 1);
    Eu = zeros(G, mu);
    for i = 1:G
        v{i} = ones(u(i),1)/u(i);
        Eu(i, ucum(i) + 1: ucum(i+1)) = ones(1, u(i));
    end
    Beq = [[Eu; ZGmu], [ZGmu; Eu], zeros(2*G, 2*G)];
    q = v;
    it = 0;
    crit = 10^-5;
    while it < 20
        it = it + 1;
        % % %   ----- When v, q are fixed ---------      
        Uv = [];
        Uq = [];
        for i = 1:G
            Ux{i} = Trn.Ux{i};         
            Uv = [Uv; v{i}'*Ux{i}];
            Uq = [Uq; q{i}'*Ux{i}];
        end
        A1 = [-X.*Y; Uv; -Uq; zn'];
        A2 = [-em1; zm2; zG; eG; 1];
        A3 = [zm1; em2; -eG; zG; -1];
        A45 = [-Em; Z2Gm; [zm1',zm2']];
        A67 = [Z2Gm'; - E2G; [zG', zG'];];
        A = [A1, A2, A3, A45, A67];
        W = quadprog( HA, fA, A, dA, [], [], LA, [], [], quadoptions );
        w = W(1:n);  b1 = W(n+1);  b2 = W(n+2);
        if it == 1
            w0 = w + 10;
        end
            
        % % %   ----- When w is fixed ---------   
        Uw = [];
        for i = 1:G
            Uw(ucum(i) + 1: ucum(i+1), i) = Ux{i}*w;
        end
        Bineq = [[Uw'; ZGmu], [ZGmu; -Uw'], -E2G];
        dBineq = [(-epsln + b2)*eG; (-epsln - b1)*eG];
        V = linprog( fB, Bineq, dBineq, Beq, dBeq, LB, [], [], linoptions );
        vall = V(1:mu);  qall = V(mu+1: 2*mu);
        
        for i = 1:G
            v{i} = vall(ucum(i) + 1: ucum(i+1));
            q{i} = qall(ucum(i) + 1: ucum(i+1));
        end
        
        obw(it) = norm(w - w0);
        % % %   ----- Stopping criterion ---------   
        if norm(w - w0) < crit
            break;
        end
        w0 = w;
        
        obj(it) = 0.5*[w;b1;b2]'*HA(1:n+2,1:n+2)*[w;b1;b2] + C*[em1;em2]'*W(n+2+1:n+2+m)/m + 0.5*Cu*[eG;eG]'*V(2*mu+1:end)/G;
    end


%% Obtain b 

    b = 0.5*(b1+b2);

%% Prediction & Output   
    tr_time = toc(tt); 
    
%     wxb = KerF( ValX , kpar , XU ) * EY * alpha - b; 
    wxb = ValX * w - b; 
    PredictY = sign( wxb );
    
    w(w<10^-6) = 0;
    idw0 = ~w;
%     R = nnz(idw0) / n;              % useless feature Rate

%     if R == 1 % all fea useless
%         idw0 = FSidRevise( idw0, KerF(uni,kpar,XU)*EY*alpha, eps3 ); 
%     end

%     w = XU' * EY * alpha;        w(idw0) = 0; % useless feature
    model.w = w; 
    model.b = b;
    model.b1 = b1;
    model.b2 = b2;
    model.v = v;
    model.q = q;
    model.obw = obw;
    model.obj = obj;
    model.w_ind = ~idw0; % id of useful feature 
    model.spsN = nnz(idw0); % Sparse Number, useless feas # 
    model.nFea = n; 
    model.spsR = model.spsN / n *100; % Sparse Ratio, useless feas % 
    
    model.tr_time = tr_time;
%     model.n_SV = nnz(alpha);
    model.n_SV = 10; % ???
    
    if Para.drw == 1
        drw.ds = wxb;
        drw.ss1 = drw.ds - 1;
        drw.ss2 = drw.ds + 1;
        model.drw = drw;
        model.twin = 0;
    end
    
    
end

