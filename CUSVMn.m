function [ PredictY , model ] = CUSVMn( ValX , Trn , Para )
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
    C = Para.p1; % PosNeg Classification penalty C
    Cu = Para.p2; % Uni Classification penalty Cu 
    Cr = Para.p3; % Uni FS Regularizor Cr 
    epsln = Para.p4; % epsilon 
    kpar = Para.kpar; 
    
    X = Trn.X;      	    Y = Trn.Y;   % ori data
    U = [];  % All Uni data
    G = length(Trn.Ux);  % The number of types of Uni data
    for i = 1:G
        U = [U; Trn.Ux{i}];
        [u(i),~] = size(Trn.Ux{i});
    end
    [m,n] = size(X);
    mu = sum(u);
    ucum = [0, cumsum(u)];
    K = KerF( [X;U], kpar , [X;U] );
    
    
%% Initilization
    tt = tic; 
    m1 = sum(Y == -1);  %  m1
    m2 = sum(Y == 1);   %  m2       
    
    em1 = ones(m1,1);         
    em2 = ones(m2,1);           
    eG = ones(G,1); 
    
    zmmu = zeros(m+mu,1); 
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
    HA = zeros(2*m+mu+2*G+2, 2*m+mu+2*G+2);
    HA(1:m+mu, 1:m+mu) = eye(m+mu) + 2*Cr*(K(m+1:end,:)'*K(m+1:end,:))/mu;
    HA(m+mu+1:m+mu+2, m+mu+1:m+mu+2) = 0.5*Cr*[1, 1; 1, 1];
    Hwb = Cr*[1;1]*sum(K(m+1:end,:))/mu;
    HA(1:m+mu, m+mu+1:m+mu+2) = -Hwb';
    HA(m+mu+1:m+mu+2, 1:m+mu) = -Hwb;
    HA = 0.5*(HA + HA');
    fA = [zmmu; 0; 0; C*[em1;em2]/m; 0.5*Cu*[eG;eG]/G];
    dA = -epsln*[ones(m+2*G,1); 0];
    LA = [-inf*ones(m+mu+2,1); zeros(m+2*G,1)];
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
            Uv = [Uv; v{i}'*K(ucum(i)+1: ucum(i+1), :)];
            Uq = [Uq; q{i}'*K(ucum(i)+1: ucum(i+1), :)];
        end
        A1 = [-K(1:m,:).*Y; Uv; -Uq; zmmu'];
        A2 = [-em1; zm2; zG; eG; 1];
        A3 = [zm1; em2; -eG; zG; -1];
        A45 = [-Em; Z2Gm; [zm1',zm2']];
        A67 = [Z2Gm'; - E2G; [zG', zG'];];
        A = [A1, A2, A3, A45, A67];
        W = quadprog( HA, fA, A, dA, [], [], LA, [], [], quadoptions );
        z = W(1:m+mu);  b1 = W(m+mu+1);  b2 = W(m+mu+2);
        if it == 1
            z0 = z + 0.1;
        end
            
        % % %   ----- When w is fixed ---------   
        Uz = [];
        for i = 1:G
            Uz(ucum(i) + 1: ucum(i+1), i) = K(ucum(i)+1: ucum(i+1), :)*z;
        end
        Bineq = [[Uz'; ZGmu], [ZGmu; -Uz'], -E2G];
        dBineq = [(-epsln + b2)*eG; (-epsln - b1)*eG];
        V = linprog( fB, Bineq, dBineq, Beq, dBeq, LB, [], [], linoptions );
        vall = V(1:mu);  qall = V(mu+1: 2*mu);
        
        for i = 1:G
            v{i} = vall(ucum(i) + 1: ucum(i+1));
            q{i} = qall(ucum(i) + 1: ucum(i+1));
        end
        
        obz(it) = norm(z - z0);
        if it == 1
            obj(it) = 0.5*[z+0.003;b1;b2]'*HA(1:m+mu+2,1:m+mu+2)*[z+0.003;b1;b2] + ...
                C*[em1;em2]'*W(m+mu+2+1:m+mu+2+m)/m + 0.5*Cu*[eG;eG]'*V(2*mu+1:end)/G;
        end
        % % %   ----- Stopping criterion ---------   
%         if norm(z - z0) < crit
%             break;
%         end
        z0 = z;
        
        obj(it+1) = 0.5*[z;b1;b2]'*HA(1:m+mu+2,1:m+mu+2)*[z;b1;b2] + ...
            C*[em1;em2]'*W(m+mu+2+1:m+mu+2+m)/m + 0.5*Cu*[eG;eG]'*V(2*mu+1:end)/G;
    end
    w = [X;U]'*z;
%% Obtain b 

    b = 0.5*(b1+b2);

%% Prediction & Output   
    tr_time = toc(tt); 
    
    wxb = KerF( ValX , kpar , [X;U] )*z  - b; 
%     wxb1 = KerF( ValX , kpar , [X;U] )*z  - b1;
%     wxb2 = KerF( ValX , kpar , [X;U] )*z  - b2;
    PredictY = sign( wxb );
    
    z(z<10^-6) = 0;
    idw0 = ~z;
%     R = nnz(idw0) / n;              % useless feature Rate

%     if R == 1 % all fea useless
%         idw0 = FSidRevise( idw0, KerF(uni,kpar,XU)*EY*alpha, eps3 ); 
%     end

%     w = XU' * EY * alpha;        w(idw0) = 0; % useless feature
    model.z = z; 
    model.b = b;
    model.b1 = b1;
    model.b2 = b2;
    model.v = v;
    model.q = q;
    model.obz = obz;
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
%         drw.ss1 = wxb1;
%         drw.ss2 = wxb2;
        model.drw = drw;
        model.twin = 0;
    end
    
    
end

