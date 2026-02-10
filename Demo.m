clc;
clear;
close all; 
addpath(genpath('lib'));
addpath(genpath('data'));
%% Set enable bits 
EN_MPCP=1;
methodname    = {'Observed','MPCP'};
dataname={'chart_and_stuffed_toy','fake_and_real_lemons','fake_and_real_tomatoes','real_and_fake_peppers', 'sponges','thread_spools','MRI','akiyo_qcif','coastguard_qcif','hall_qcif','antinous_128'};
load('mpcppara.mat')
for k11=1:1:1
for i1=1:1

Mnum = length(methodname);
Re_tensor  =  cell(Mnum,1);
psnr       =  zeros(Mnum,1);
ssim       =  zeros(Mnum,1);
fsim       =  zeros(Mnum,1);
time       =  zeros(Mnum,1);
ergas   =  zeros(Mnum,1);


load(dataname{i1});

saveroad = ['result' ];
if k11==1
    sample_ratio = 0.05;
elseif k11==2
    sample_ratio = 0.1;
elseif k11==3
    sample_ratio = 0.2;
end
% if max(X(:))>1
%     normalize = max(X(:));
%         X = X/normalize;
% end
%% Sampling with random position
fprintf('=== The sample ratio is %4.2f ===\n', sample_ratio);
imname1=[dataname{i1}, num2str(sample_ratio*100) '.mat'];
load(imname1);
% Y_tensorT = X;
Ndim      = ndims(Y_tensorT);
Nway      = size(Y_tensorT);

% Omega     = zeros(Nway);
% known     = find(rand(prod(Nway),1)<sample_ratio);
% Omega(known) = 1;
% Omega     = (Omega > 0);
% Y_tensor0 = zeros(Nway);
% Y_tensor0(Omega) = Y_tensorT(Omega);
enList = [];
%%
i  = 1;
Re_tensor{i} = Y_tensor0;
[psnr(i), ssim(i), fsim(i), ergas(i)] = MSIQA(Y_tensorT * 255, Re_tensor{i}  * 255); 
enList = 1;
%% Perform  algorithms

%% Use NMPCP
i = 2;
if EN_MPCP
disp(['performing MPCP ... ']);
    % initialization of the  parameters
    % Please refer to our paper to set the parameters
    opts=[];
    if i1<=6
        alpha=[0,   0.001,  1;
            0,    0,    1;
            0,    0,    0];
    elseif i1==7
        alpha=[0,   1,  1;
            0,    0,    1;
            0,    0,    0];
    elseif i1>=8 && i1<=10
       alpha=[ 0, 1, 1, 1;
        0, 0, 1, 1;
        0, 0, 0, 1;
        0, 0, 0, 0];
    elseif i1==11
       alpha=[ 0, 1, 1, 1, 1;
        0, 0, 1, 1, 1;
        0, 0, 0, 1, 1;
        0, 0, 0, 0, 1;
        0, 0, 0, 0, 0];
    end
    opts.alpha=alpha/sum(alpha(:));
    opts.tol = 1e-3;
    opts.maxit = 200;
    opts.rho = 1.05;
    opts.beta = opts.alpha/1000;
    opts.max_beta = 1e10*ones(Ndim,Ndim);
    opts.sp=0.1;
    opts.gama=gama01(i1,k11)^0.1;
    % opts.Xtrue=Y_tensorT;
    t0= tic;
    [Re_tensor{i},~]=LRTC_MPCP(Y_tensor0,Omega,opts);
    time(i)= toc(t0);
    [psnr(i), ssim(i), fsim(i),ergas(i)] = MSIQA(Y_tensorT*255, Re_tensor{i}*255);
    enList = [enList,i];

end

%% Show result
fprintf('%20s   %5.3f   \n', dataname{i1}, sample_ratio );
     fprintf('    %5.3f    %5.3f  %5.3f  %5.3f  %5.3f\n',...
      psnr(i), ssim(i), fsim(i),ergas(i),time(i));
end
end
