function [ output ] = encoder( position_x,position_y )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% load pretrain atuto-encoder data
load('autoencoder_w_900 484 225 121 113 57 29 15.mat');
  
nn = nnsetup([900 484 225 121 113 57 29 15]);
nn.activation_function              = 'sigm';
nn.learningRate                     = 1;

nn.W{1}=w1 ;
nn.W{2}=w2 ;
nn.W{3}=w3 ;
nn.W{4}=w4 ;
nn.W{5}=w5 ;
nn.W{6}=w6 ;
nn.W{7}=w7 ;

matrix=produce_state_picture( position_x,position_y );
output= nn_compute_output( nn,matrix )';
for i=1:15
    if (output(i,1)>0.8) output(i,1) = 1;
    else output(i,1) = 0;
    end
end

