% Leak database
%           P: Node pressures on different leak scenarios
%              One column for each node, one row for each leak scenario
%          P0: Leak-free node pressures
%    leakNode: Leak node
%    leakSize: Leak flow-rate
%     sensors: Nodes with pressure sensors
load HanoiDatabase
R = P - P0;
% Dataset partition
train_idx = ismember(leakSize,1:2:49);
test_idx = ismember(leakSize,2:2:50);
% Class labels
ytrain = leakNode(train_idx);
ytest = leakNode(test_idx);
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
model{1,1} = fitcknn(Rtrain,ytrain,'NumNeighbors',5); % using residuals
model{1,2} = fitcknn(Ctrain,ytrain,'NumNeighbors',5); % using cosines
model{2,1} = fitcnb(Rtrain,ytrain);
model{2,2} = fitcnb(Ctrain,ytrain);
model{3,1} = fitctree(Rtrain,ytrain);
model{3,2} = fitctree(Ctrain,ytrain);
model{4,1} = fitcdiscr(Rtrain,ytrain);
model{4,2} = fitcdiscr(Ctrain,ytrain);
% Compute classification error on training data (resubstitution loss)
for i = 1:4
    for j = 1:2
        rloss(i,j) = model{i,j}.resubLoss;
    end
end
resFeatures = rloss(:,1);
cosFeatures = rloss(:,2);
disp('Leak location error on training data:')
disp(table(Method,resFeatures,cosFeatures))
% Compute classification error on testing data
for i = 1:4
    for j = 1:2
        if j == 1
            tloss(i,j) = model{i,j}.loss(Rtest,ytest);
        else
            tloss(i,j) = model{i,j}.loss(Ctest,ytest);
        end
    end
end
resFeatures = tloss(:,1);
cosFeatures = tloss(:,2);
Improvement = (tloss(:,1)-tloss(:,2))./tloss(:,1);
disp('Leak location error on testing data:')
disp(table(Method,resFeatures,cosFeatures,Improvement))
