% train and test MLP

%%
ompfunc = @omp;
for kk = 1:n_folds
    
    for 
    
    inputs = full(ompfunc(disc_dicts{1,k},data_train,[],ceil(sparsity*60)));
   
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

    disp('--------------------------------------------------');
    fprintf('Number of segments corresponding to class 1 (N): %d \n',mc1);
    fprintf('Number of segments corresponding to class 2 (A): %d \n',mc2);
    fprintf('Number of segments corresponding to class 3 (H): %d \n',mc3);
    disp('--------------------------------------------------');

    n_samples = min([mc1 mc2 mc3]); % number of samples for each class
    i_trn_1 = datasample(I1,n_samples,'Replace',false);
    inp_trn_1 = inputs(:,i_trn_1);
    i_trn_2 = datasample(I2,n_samples,'Replace',false);
    inp_trn_2 = inputs(:,i_trn_2);
    i_trn_3 = datasample(I3,n_samples,'Replace',false);
    inp_trn_3 = inputs(:,i_trn_3);
    inputs_train_dksvd = [inp_trn_1 inp_trn_2 inp_trn_3]; % double
    
    GroupTrain = zeros(3,3*n_samples);
    GroupTrain(1,1:n_samples) = ones(1,n_samples);
    GroupTrain(2,n_samples+1:2*n_samples) = ones(1,n_samples);
    GroupTrain(3,2*n_samples+1:3*n_samples) = ones(1,n_samples);
    
    TrainingSet_dksvd = inputs_train_dksvd;
    %TestSet_dksvd = inputs_test_dksvd;
    net_dasksvd = patternnet(300); % create a net
    %
    net_dasksvd.performFcn = 'mse';
    net_dasksvd.layers{1}.transferFcn = 'tansig' %satlin'; % 'logsig' 'tansig' 'satlin'
    %
    [net_dasksvd,tr_dasksvd] = train(net_dasksvd,TrainingSet_dksvd,GroupTrain); % training
    plotperform(tr_dasksvd)
    
end




% test

%
% GroupTest = zeros(3,3000);
% GroupTest(1,1:1000) = ones(1,1000);
% GroupTest(2,1001:2000) = ones(1,1000);
% GroupTest(3,2001:3000) = ones(1,1000);
%
%labels_test = [zeros(1,1000) ones(1,1000) 2*ones(1,1000)];



%inputs_train_dksvd = [inputs(:,I1(1:10000)) inputs(:,I2(1:10000)) inputs(:,I3(1:10000))]; % double

%inputs_test_dksvd = [inputs(:,I1(10001:11000)) inputs(:,I2(10001:11000)) inputs(:,I3(10001:11000))]; % double
    %
TrainingSet_dksvd = inputs_train_dksvd;
%TestSet_dksvd = inputs_test_dksvd;
net_dasksvd = patternnet(300); % create a net
%
net_dasksvd.performFcn = 'mse';
net_dasksvd.layers{1}.transferFcn = 'tansig' %satlin'; % 'logsig' 'tansig' 'satlin'
%
[net_dasksvd,tr_dasksvd] = train(net_dasksvd,TrainingSet_dksvd,GroupTrain); % training
%out_net_dksvd = net_dksvd(TestSet_dksvd);
%[~,inx_dksvd] = max(out_net_dksvd);
%class_det_mlp_dksvd = inx_dksvd-1;
%acc_mlp_dksvd = length(find(class_det_mlp_dksvd==labels_test))/100;
%fprintf('Accuracy MLP classifier DKSVD: %.2f \n',acc_mlp_dksvd);

%length(find(lt==ld>0))/30

%% test signal matrix building

%load('/home/igareis/Proyectos/project_individual_apnea_hypopnea_detection/data/indices_test.mat')
% 
% L = 16; % number of non-zero elements
A_test = cell(1,n_studies_30);
AHIN=zeros(1,n_studies_30);
AHIest=zeros(1,n_studies_30);
time_sleep=zeros(1,n_studies_30);
acc = zeros(1,n_studies_30);
tic
for i = 1:n_studies_30
    disp(['iteration ' num2str(i) ' loading PSG ' num2str(indices_test(i)) ' ' char(studies_identification(i))]);
    psg = char(studies_identification(indices_test(i)));
    load(['/home/rrolon/roman_sinc/Publications_2016/NOCICA_MDAS/SHHS_database/' psg],'Flujo','SaO2','apn','SleepStage');
    %load(['/home/igareis/Proyectos/project_individual_apnea_hypopnea_detection/SHHS_database/' psg],'Flujo','SaO2','apn','SleepStage');
	apn = apn(1:10:end);
    Flujo.signal = Flujo.signal(1:10:end);
    [spo2, apn_spo2] = filtrado2(SaO2.signal, apn); % wavelet filtering
    
    
	[signal, target] = SDKSVD_build_signal_matrix(spo2, apn_spo2, win, over);
    
    time_sleep(i) = sum(SleepStage > 0)/10/60/60;
    AHIN(i)=sum((diff(apn==100 |apn==200) ~= 0))/2/time_sleep(i);
    
    A_test{i} = full(ompfunc(disc_dicts{1},signal,[],ceil(sparsity*60)));            % sparse train matrix

    out_net_dksvd = net_dasksvd(A_test{i});
    [~,inx_dksvd] = max(out_net_dksvd);
    class_det_mlp_dksvd = inx_dksvd-1;
    ld=class_det_mlp_dksvd;
    ind=find(class_det_mlp_dksvd);
    ld(ind)=1;
    target_1 = double(target>0);
    acc(i)=length(find(target_1==ld))/length(target);
    AHIest(i)=sum(ld)/time_sleep(i);
    
end % end for i
tiempo_mdcs_od = toc;

%%
% thresholds and targets settings
disp('--------------------------------------------------')
disp('thresholds and targets settings')
disp('--------------------------------------------------')

AHIthr = 15; % AHI threshold
disp('--------------------------------------------------')
fprintf('Threshold value for OSAHS screening: %d \n',AHIthr);
disp('--------------------------------------------------')
aux = sum(AHIN<AHIthr);
etiq = [-ones(aux,1);ones(n_studies_30-aux,1)]; % "-1"-> sano, "+1"-> enfermo
labels = [];
for i = 1:n_studies_30
    if AHIN(i)>AHIthr
    labels{i} = 'enfermo';
    else
        labels{i} = 'sano';
    end
end

% perform ROC analysis
disp('--------------------------------------------------')
disp('ROC analysis performing...')
disp('--------------------------------------------------')
[X,Y,T,AUC] = perfcurve(labels,AHIest,'enfermo');
