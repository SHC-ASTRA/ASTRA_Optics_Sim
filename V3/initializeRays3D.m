function [RayPos,RayVec,Lambdas] = initializeRays3D(numRays, XRange, YRange, ZRange, ThetaRange, PhiRange, LambdaRange)

X = rand(1,numRays,'gpuArray')*(max(XRange)-min(XRange)) + min(XRange);
Y = rand(1,numRays,'gpuArray')*(max(YRange)-min(YRange)) + min(YRange);
Z = rand(1,numRays,'gpuArray')*(max(ZRange)-min(ZRange)) + min(ZRange);
Theta = rand(1,numRays,'gpuArray')*(max(ThetaRange)-min(ThetaRange)) + min(ThetaRange);
Phi = rand(1,numRays,'gpuArray')*(max(PhiRange)-min(PhiRange)) + min(PhiRange);

RayPos = [X;Y;Z];
RayVec = [sin(Theta).*cos(Phi);sin(Theta).*sin(Phi);cos(Theta)];

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

