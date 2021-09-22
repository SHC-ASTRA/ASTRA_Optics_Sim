function [RayVec,Lambdas] = initializeRays(numRays, XRange, ThetaRange, LambdaRange)

X = rand(1,numRays,'gpuArray')*(max(XRange)-min(XRange)) + min(XRange);
Theta = rand(1,numRays,'gpuArray')*(max(ThetaRange)-min(ThetaRange)) + min(ThetaRange);
RayVec = [X;Theta];
Lambdas = rand(1,numRays,'gpuArray')*(max(LambdaRange)-min(LambdaRange)) + min(LambdaRange);

end

