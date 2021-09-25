function [n] = b270RefractiveIndex(lambda)

lambda_vals = [706.5 656.3 643.8 589.3 587.6 546.1 486.1 480 435.8 404.7 365];
n_vals = [1.51883 1.52037 1.5208 1.52299 1.52307 1.5252 1.52929 1.5298 1.53416 1.5382 1.5451];

n = interp1(lambda_vals,n_vals,lambda,'spline');

end

