function [n] = nbk7RefractiveIndex(lambda)
lambda = lambda./1000;

n = sqrt((1.03961212*lambda.^2)./(lambda.^2 - 0.00600069867) + ...
         (0.231792344*lambda.^2)./(lambda.^2 - 0.0200179144) + ...
         (1.01046945*lambda.^2)./(lambda.^2 - 103.560653) + 1);
end

