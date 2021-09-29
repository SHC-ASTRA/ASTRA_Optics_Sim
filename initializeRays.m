function [RayPos,RayVec,Lambdas] = initializeRays(numRays, XRange, YRange, ThetaRange, LambdaRange, noiseFrac, mode)
if ~exist('noiseFrac','var') || isempty(noiseFrac)
    noiseFrac = 0.75;
end
if ~exist('mode','var') || isempty(mode)
    mode = 1;
end

X = rand(1,numRays,'gpuArray')*(max(XRange)-min(XRange)) + min(XRange);
Y = rand(1,numRays,'gpuArray')*(max(YRange)-min(YRange)) + min(YRange);
Theta = rand(1,numRays,'gpuArray')*(max(ThetaRange)-min(ThetaRange)) + min(ThetaRange);

RayPos = [X;Y];
RayVec = [cos(Theta);sin(Theta)];

if mode == 1
    balmerWavelengths = gpuArray([repelem(656.2852,180),...
                    repelem(656.272,120),...
                    repelem(486.133,80),...
                    repelem(434.047,30),...
                    repelem(410.174,15),...
                    repelem(397.0072,8),...
                    repelem(388.9049,6),...
                    repelem(383.5384,5)]);
    numLambdas = numel(balmerWavelengths);
    Lambdas = repelem(balmerWavelengths,floor(numRays*(1-noiseFrac)/numLambdas));
    numLambdasRemaining = numRays-numel(Lambdas);
elseif mode == 2
    uniformWavelengths = linspace(LambdaRange(1),LambdaRange(2),10);
    numLambdas = numel(uniformWavelengths);
    Lambdas = repelem(uniformWavelengths,floor(numRays*(1-noiseFrac)/numLambdas));
    numLambdasRemaining = numRays-numel(Lambdas);
end

Lambdas = [Lambdas, rand(1,numLambdasRemaining,'gpuArray')*(max(LambdaRange)-min(LambdaRange)) + min(LambdaRange)];

end

