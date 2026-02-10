function psnr = PSNR(imagery1, imagery2)

% psnr - compute the Peack Signal to Noise Ratio, defined by :
%       PSNR(x,y) = 10*log10( max(max(x),max(y))^2 / |x-y|^2 ).
%
%   p = psnr(x,y);
%
%   Copyright (c) 2004 Gabriel Peyr
% 
% d = mean( mean( (x(:)-y(:)).^2 ) );
% m1 = max( abs(x(:)) );
% m2 = max( abs(y(:)) );
% % m = max(m1,m2);
% m = 1;
% 
% p = 10*log10( m^2/d );

[m, n, k] = size(imagery1);
[mm, nn, kk] = size(imagery2);
m = min(m, mm);
n = min(n, nn);
k = min(k, kk);
imagery1 = imagery1(1:m, 1:n, 1:k);
imagery2 = imagery2(1:m, 1:n, 1:k);

psnr = 0;


for i = 1:k
    psnr = psnr + 10*log10(255^2/mse(imagery1(:, :, i) - imagery2(:, :, i)));
    % ssim = ssim + ssim_index(imagery1(:, :, i), imagery2(:, :, i));
    % fsim = fsim + FeatureSIM(imagery1(:, :, i), imagery2(:, :, i));
end
psnr = psnr/k;
% ssim = ssim/k;
% fsim = fsim/k;
% ssim = mean(ssim);
% fsim = mean(fsim);
%  p = 10*log10(1/mean((x(:)-y(:)).^2));
% p=10*( log10( 255^2 ) + (log10(size(x,1)*size(x,2))-log10(norm(x(:)-y(:))^2)));
