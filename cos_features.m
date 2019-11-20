

% Leak database of Hanoi network
%           P: Node pressures on different leak scenarios
%              One column for each node, one row for each leak scenario
%          P0: Leak-free node pressures
%    leakNode: Leak node
%    leakSize: Leak flow-rate
%     sensors: Nodes with pressure sensors
%           D: Topological distance matrix
load HanoiDatabase

% Dataset partition
train_idx = ismember(leakSize,1:2:49);
test_idx = ismember(leakSize,2:2:50);
% Class labels
ytrain = leakNode(train_idx);
ytest = leakNode(test_idx);

I = []; rng('default')
for SNR = [Inf,80:-20:0]
    disp(['Testing SNR = ',num2str(SNR),' dB...'])
    s_noise = 10^(-SNR/20)*std(P(:));
    P = P + s_noise*randn(size(P));
    R = P - P0;
    % Pressures
    Ptrain = P(train_idx,sensors);
    Ptest = P(test_idx,sensors);
    % Residuals
    Rtrain = R(train_idx,sensors);
    Rtest = R(test_idx,sensors);
    % Direction cosines
    Ctrain = direction(Rtrain);
    Ctest = direction(Rtest);
    % Classification models
    Method = {'k-Nearest Neighbors';
        'Naïve Bayes';
        'Decision Tree';
        'Linear discriminant'};
    model{1,1} = fitcknn(Rtrain,ytrain,'NumNeighbors',5);
    model{1,2} = fitcknn(Ctrain,ytrain,'NumNeighbors',5);
    model{2,1} = fitcnb(Rtrain,ytrain);
    model{2,2} = fitcnb(Ctrain,ytrain);
    model{3,1} = fitctree(Rtrain,ytrain);
    model{3,2} = fitctree(Ctrain,ytrain);
    model{4,1} = fitcdiscr(Rtrain,ytrain);
    model{4,2} = fitcdiscr(Ctrain,ytrain);
    % Classification error on training data (resubstitution loss)
    for i = 1:4
        err(i,1) = model{i,1}.resubLoss;
        err(i,2) = model{i,2}.resubLoss;
    end
    loss_Residuals = err(:,1);
    loss_Cosines = err(:,2);
    disp('Leak location error on training data:')
    disp(table(Method,loss_Residuals,loss_Cosines))
    % Classification error on testing data
    for i = 1:4
        yhat = model{i,1}.predict(Rtest);
        err(i,1) = 1 - accuracy(ytest,yhat);
        ATD(i,1) = atd(ytest,yhat,D);
        yhat = model{i,2}.predict(Ctest);
        err(i,2) = 1 - accuracy(ytest,yhat);
        ATD(i,2) = atd(ytest,yhat,D);
    end
    loss_Residuals = err(:,1);
    loss_Cosines = err(:,2);
    Improvement = (err(:,1)-err(:,2))./err(:,1);
    disp('Leak location error on testing data:')
    disp(table(Method,loss_Residuals,loss_Cosines))
    ATD_Residuals = ATD(:,1);
    ATD_Cosines = ATD(:,2);
    disp('Average topological distance on testing data:')
    disp(table(Method,ATD_Residuals,ATD_Cosines))
    I = [I,Improvement];
end
disp('Percentage improvement with cosenoidal features:')
disp(table(Method,I(:,1),I(:,2),I(:,3),I(:,4),I(:,5),I(:,6),...
    'VariableNames',{'Method',...
    'Inf','80 dB','60 dB','40 dB','20 dB','0 dB'}));