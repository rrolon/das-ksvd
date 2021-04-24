function [ index_out,p_dist_out ] = SDKSVD_get_indices(p, p_dist_in, beta)
% Randomly selects p indexes using the probabilities given in p_dist_in.
% And updates p_dist_out using factor beta (0 =< beta < 1).

    p_dist_out = p_dist_in;
                                                                                                                                                                                                                                                                                                                                        
    index_out = bootsmp(p_dist_in,p);
    
    p_dist_out(index_out) = p_dist_in(index_out)*beta;
    p_dist_out = p_dist_out./sum(p_dist_out);

end