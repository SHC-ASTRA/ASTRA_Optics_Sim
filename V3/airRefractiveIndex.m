function [n] = airRefractiveIndex(lambda)
lambda = lambda./1000;

n = 0.05792105./(238.0185-lambda.^(-2)) + 0.00167917./(57.362-lambda.^(-2)) + 1;
end

