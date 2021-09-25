function [HitPos,NormalVec] = intersectRayArc(RayPos,RayVec,ArcPos,ArcRad,StartVec,EndVec)
A = RayPos;
B = RayVec;
C = ArcPos;
r = ArcRad;

numRays = size(RayPos,2);

a = dot(B,B);
b = 2*dot(B,A-C);
c = dot(A-C,A-C)-r^2;

d = b.^2-4.*a.*c;

solExists = d>=0;

t_1 = ((-b-sqrt(max(d,0)))./(2.*a));
t_2 = ((-b+sqrt(max(d,0)))./(2.*a));

inside = vecnorm(RayPos-ArcPos) <= ArcRad;

HitPos = A + t_1.*B.*~inside + t_2.*B.*inside;

HitPos(:,~solExists) = NaN;

NormalVec = HitPos-ArcPos;
NormalVec = NormalVec./vecnorm(NormalVec);
NormalVec(:,inside) = -NormalVec(:,inside);

cross1 = cross(repelem(gpuArray([StartVec;0]),1,numRays),[NormalVec;zeros(1,numRays)]);
cross2 = cross([NormalVec;zeros(1,numRays)],repelem(gpuArray([EndVec;0]),1,numRays));
inRange = sign(cross1(3,:)) == sign(cross2(3,:));

HitPos(:,~inRange) = NaN;
NormalVec(:,~inRange) = NaN;

end

