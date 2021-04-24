
inputs = A_train;

[segment_size,segments] = size(inputs);
batch_size = 1500; % size of mini batch
num_epochs = floor(segments/batch_size);



% 
% disp('--------------------------------------------------')
% fprintf('Number of atoms: %d \n',number_of_atoms);
% fprintf('Number of neurons in hidden layer: %d \n',numHiddenNeurons);
% disp('--------------------------------------------------')
% 
% disp('--------------------------------------------------')
% fprintf('Mini-batch size: %d \n',batch_size);
% fprintf('Number of epochs (iterations): %d \n',num_epochs);
% disp('--------------------------------------------------')

% divide inputs into inputs class 1 and inputs class 2
I1 = find(labels_train==0); % normal (N)
inputs_c1 = inputs(:,I1); % 
[nc1,mc1] = size(inputs_c1); % mc1 represents the number of segments corresponding to class N
%
I2 = find(labels_train==1); % apnea (A)
inputs_c2 = inputs(:,I2); % 
[nc2,mc2] = size(inputs_c2); % mc2 represents the number of segments corresponding to class A
%
I3 = find(labels_train==2); % hypopnea (H)
inputs_c3 = inputs(:,I3); % 
[nc3,mc3] = size(inputs_c3); % mc3 represents the number of segments corresponding to class H

disp('--------------------------------------------------')
fprintf('Number of segments corresponding to class 1 (N): %d \n',mc1);
fprintf('Number of segments corresponding to class 2 (A): %d \n',mc2);
fprintf('Number of segments corresponding to class 3 (H): %d \n',mc3);
disp('--------------------------------------------------')

% create neural network
hiddenLayerSize = 16;
net = patternnet(hiddenLayerSize);

% configure neural network
net.divideParam.trainRatio = 70/100;  % Adjust as desired
net.divideParam.valRatio = 15/100;  % Adjust as desired
net.divideParam.testRatio = 15/100;  % Adjust as desired
net.performFcn = 'mse';
%net.trainParam.epochs = 4;% num_epochs; % Maximum number of epochs to train
net.trainParam.goal = 0.001; % Performance goal
net.trainParam.lr = 0.01; % Learning rate
% net.trainParam.lr_inc = 1.05; % Ratio to increase learning rate
net.trainParam.max_fail = 6 % 5; % Maximum validation failures
net.trainParam.min_grad = 1e-5; % Minimum performance gradient
net.trainParam.show = 1; % Epochs between displays (NaN for no displays)
net.trainParam.showWindow = false; % Show training GUI
% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotconfusion', 'plotroc'};
%%
%train
% Train the Network
t=zeros(3,segments);
for i=1:segments
    if labels_train==0
        t(1,i)=1;
    elseif labels_train==1
        t(2,i)=1;
    else
        t(3,i)=1;
    end
end
net= configure(net,inputs,t);  %remove previous weights and reinitialize with random weights.
[net,tr] = train(net,inputs,t);

%test
y = net(inputs);
e = gsubtract(t,y);
performance = perform(net,t,y)
tind = vec2ind(t);
yind = vec2ind(y);
percentErrors = sum(tind ~= yind)/numel(tind);

plotconfusion(t,y)

 % Recalculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y)
valPerformance = perform(net,valTargets,y)
testPerformance = perform(net,testTargets,y)

 % View the Network

 view(net)

%%
% training neural network
disp('--------------------------------------------------')
disp('training neural network')
disp('--------------------------------------------------')
for iter = 1:num_epochs
	fprintf('Iteration number %d \n',iter);
	ind_of_segments_c1 = rand_sin_repeticion(1,mc1,batch_size/3);
	ind_of_segments_c2 = rand_sin_repeticion(1,mc2,batch_size/3);
    ind_of_segments_c3 = rand_sin_repeticion(1,mc3,batch_size/3);
	inpt_c1 = inputs_c1(:,ind_of_segments_c1);
	inpt_c2 = inputs_c2(:,ind_of_segments_c2);
  	inpt_c3 = inputs_c3(:,ind_of_segments_c3);
	inpt = [inpt_c1 inpt_c2 inpt_c3];
	targt = [[ones(1,batch_size/3); zeros(2,batch_size/3)] ...
        [zeros(1,batch_size/3); ones(1,batch_size/3); zeros(1,batch_size/3)]...
        [zeros(2,batch_size/3); ones(1,batch_size/3)]];
	[net,tr(iter)] = train(net,inpt,targt);
end

disp('--------------------------------------------------')
disp('testing neural network')
disp('--------------------------------------------------')
inpt_tst_c1 = inputs(:,I1(1:100));
inpt_tst_c2 = inputs(:,I2(1:100));
inpt_tst_c3 = inputs(:,I3(1:100));
inpt_tst = [inpt_tst_c1 inpt_tst_c2 inpt_tst_c3];
out_tst = sim(net,inpt_tst);
%t = [[ones(1,100); zeros(2,100)] ...
%        [zeros(1,100); ones(1,100); zeros(1,100)]...
%        [zeros(2,100); ones(1,100)]];
%y = net(inpt_tst)
%perf = perform(net,t,inpt_tst);



% batch learning of the neural network

%inputs1 = [alpha(:,1:10:500) alpha(:,2:10:500)];
%targets1 = [(2*T_1_667(1:10:500)-1) (2*T_1_667(2:10:500)-1)];
%outputs1 = sim(net,inputs1);


