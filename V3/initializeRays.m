function [RayPos,RayVec,Lambdas] = initializeRays(numRays, XRange, YRange, ThetaRange, LambdaRange)

X = rand(1,numRays,'gpuArray')*(max(XRange)-min(XRange)) + min(XRange);
Y = rand(1,numRays,'gpuArray')*(max(YRange)-min(YRange)) + min(YRange);
Theta = rand(1,numRays,'gpuArray')*(max(ThetaRange)-min(ThetaRange)) + min(ThetaRange);

RayPos = [X;Y];
RayVec = [cos(Theta);sin(Theta)];

noiseFrac = 0.75;

balmerWavelengths = gpuArray([repelem(656.2852,180),...
                repelem(656.272,120),...
                repelem(486.133,80),...
                repelem(434.047,30),...
                repelem(410.174,15),...
                repelem(397.0072,8),...
                repelem(388.9049,6),...
                repelem(383.5384,5)]);
numBalmer = numel(balmerWavelengths);
Lambdas = repelem(balmerWavelengths,floor(numRays*(1-noiseFrac)/numBalmer));
numLambdasRemaining = numRays-numel(Lambdas);

Lambdas = [Lambdas, rand(1,numLambdasRemaining,'gpuArray')*(max(LambdaRange)-min(LambdaRange)) + min(LambdaRange)];

end

