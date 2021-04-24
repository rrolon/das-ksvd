% save results

results_das_ksvd = cell(40,2);

% results_mdcs_bc_ce{1,1} = 'params'; results_mdcs_bc_ce{1,2} = params;
%results_das_ksvd{2,1} = 'phi_c1'; results_das_ksvd{2,2} = Phi_c1;
%results_das_ksvd{3,1} = 'phi_c2'; results_das_ksvd{3,2} = Phi_c2;
%results_das_ksvd{4,1} = 'phi_od'; results_das_ksvd{4,2} = Phi_OD;
results_das_ksvd{5,1} = 'phi_mdcs'; results_das_ksvd{5,2} = Phi_das_ksvd;
results_das_ksvd{6,1} = 'r'; results_das_ksvd{6,2} = r;
results_das_ksvd{7,1} = 'over'; results_das_ksvd{7,2} = over;
%results_das_ksvd{8,1} = 'indx'; results_das_ksvd{8,2} = indx;
results_das_ksvd{9,1} = 'batch_size'; results_das_ksvd{9,2} = batch_size;
results_das_ksvd{10,1} = 'net'; results_das_ksvd{10,2} = net;
results_das_ksvd{11,1} = 'num_hidden_neurons'; results_das_ksvd{11,2} = numHiddenNeurons;
results_das_ksvd{12,1} = 'tr'; results_das_ksvd{12,2} = tr;
results_das_ksvd{13,1} = 'AHInew'; results_das_ksvd{13,2} = AHInew;
results_das_ksvd{14,1} = 'AHIthr'; results_das_ksvd{14,2} = AHIthr;
results_das_ksvd{15,1} = 'AHIest'; results_das_ksvd{15,2} = AHIest;
results_das_ksvd{16,1} = 'number_features'; results_das_ksvd{16,2} = num_features;
results_das_ksvd{17,1} = 'tiempo'; results_das_ksvd{17,2} = tiempo;
results_das_ksvd{18,1} = 'auc'; results_das_ksvd{18,2} = auc;
results_das_ksvd{19,1} = 'min_distance'; results_das_ksvd{19,2} = min_distance;
results_das_ksvd{20,1} = 'se'; results_das_ksvd{20,2} = se;
results_das_ksvd{21,1} = 'sp'; results_das_ksvd{21,2} = sp;
results_das_ksvd{22,1} = 'acc'; results_das_ksvd{22,2} = acc;
results_das_ksvd{23,1} = 'stack_x'; results_das_ksvd{23,2} = stack_x;
results_das_ksvd{24,1} = 'stack_y'; results_das_ksvd{24,2} = stack_y;
results_das_ksvd{25,1} = 'n_folds'; results_das_ksvd{25,2} = n_folds;
%results_das_ksvd{26,1} = 'ksvd_iter'; results_das_ksvd{26,2} = ksvd_iter;
results_das_ksvd{27,1} = 'L'; results_das_ksvd{27,2} = L;
results_das_ksvd{28,1} = 'metodo'; results_das_ksvd{28,2} = metodo;
results_das_ksvd{29,1} = 'n_trn'; results_das_ksvd{29,2} = n_trn;
results_das_ksvd{30,1} = 'n_tst'; results_das_ksvd{30,2} = n_tst;
results_das_ksvd{31,1} = 'sparsity'; results_das_ksvd{31,2} = sparsity;
results_das_ksvd{32,1} = 'win'; results_das_ksvd{32,2} = win;