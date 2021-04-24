load('disc_dict_128_150')


%,'Phi_D','A_train','labels_train','data_train','sparsity','r')

[segment_size,segments] = size(A_train);
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
%I = find(labels_train); % indices corresponding to class 1
inputs_c1 = A_train(:,labels_train==0); % inputs class 1
mc1 = sum(labels_train==0); % mc1 represents the number of segments corresponding to class 1
inputs_c2 = A_train(:,labels_train==1); % inputs class 1
mc2 = sum(labels_train==1); % mc2 represents the number of segments corresponding to class 1
inputs_c3 = A_train(:,labels_train==2); % inputs class 1
mc3 = sum(labels_train==2); % mc3 represents the number of segments corresponding to class 1

disp('--------------------------------------------------')
fprintf('Number of segments corresponding to class 1: %d \n',mc1);
fprintf('Number of segments corresponding to class 2: %d \n',mc2);
fprintf('Number of segments corresponding to class 3: %d \n',mc3);
disp('--------------------------------------------------')

% create neural network
hiddenLayerSize = 16;
net = patternnet(hiddenLayerSize);

% configure neural network
net.divideParam.trainRatio = 100/100;  % Adjust as desired
net.divideParam.valRatio = 0/100;  % Adjust as desired
net.divideParam.testRatio = 0/100;  % Adjust as desired
net.trainParam.epochs = 4;% num_epochs; % Maximum number of epochs to train
net.trainParam.goal = 0.001; % Performance goal
net.trainParam.lr = 0.01; % Learning rate
% net.trainParam.lr_inc = 1.05; % Ratio to increase learning rate
net.trainParam.max_fail = 5; % Maximum validation failures
net.trainParam.min_grad = 1e-5; % Minimum performance gradient
net.trainParam.show = 1; % Epochs between displays (NaN for no displays)
net.trainParam.showWindow = false; % Show training GUI

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

save('reference_results','net','tr')


% disp('--------------------------------------------------')
% disp('testing neural network')
% disp('--------------------------------------------------')
% ind_of_tst_segments_c1 = rand_sin_repeticion(1,mc1,batch_size/2);
% ind_of_tst_segments_c2 = rand_sin_repeticion(1,mc2,batch_size/2);
% inpt_tst_c1 = inputs_c1(:,ind_of_tst_segments_c1);
% inpt_tst_c2 = inputs_c2(:,ind_of_tst_segments_c2);
% inpt_tst = [inpt_tst_c1 inpt_tst_c2];
% out_tst = sim(net,inpt_tst);

% batch learning of the neural network

%inputs1 = [alpha(:,1:10:500) alpha(:,2:10:500)];
%targets1 = [(2*T_1_667(1:10:500)-1) (2*T_1_667(2:10:500)-1)];
%outputs1 = sim(net,inputs1);


