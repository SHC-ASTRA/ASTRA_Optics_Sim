function [HitPos,NormalVec] = intersectRayLine(RayPos,RayVec,StartPos,EndPos)

p = RayPos;
r = RayVec;
q = StartPos;
s = (EndPos-StartPos)./vecnorm(EndPos-StartPos);
uEnd = vecnorm(EndPos-StartPos);

t = cross2((q-p),s)./cross2(r,s);
u = cross2((q-p),r)./cross2(r,s);

HitPos = p + t.*r;
NormalVec = repelem(gpuArray([s(2,:);-s(1,:)]),1,size(RayPos,2));

inRange = u>=0 & u <=uEnd;
HitPos(:,~inRange) = NaN;
NormalVec(:,~inRange) = NaN;

end

