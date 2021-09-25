function [HitPos,NormalVec,u] = intersectRayLine(RayPos,RayVec,StartPos,EndPos)
% N = number of rays
p = RayPos; % 2xN
r = RayVec; % 2xN
q = StartPos; % 2x1
s = (EndPos-StartPos)./vecnorm(EndPos-StartPos); % 2x1
uEnd = vecnorm(EndPos-StartPos); % scalar

t = cross2((q-p),s)./cross2(r,s); % 1xN
u = cross2((q-p),r)./cross2(r,s); % 1xN

HitPos = p + t.*r; % 2xN
NormalVec = repelem(gpuArray([s(2,:);-s(1,:)]),1,size(RayPos,2)); % 2xN

inRange = u>=0 & u <=uEnd; %1xN boolean
HitPos(:,~inRange) = NaN;
NormalVec(:,~inRange) = NaN;
u(~inRange) = NaN;

end

