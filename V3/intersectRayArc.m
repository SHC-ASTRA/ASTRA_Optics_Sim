function [HitPos,NormalVec] = intersectRayArc(RayPos,RayVec,ArcPos,ArcRad,ArcRange)
A = RayPos;
B = RayVec;
C = ArcPos;
r = ArcRad;

a = dot(B,B);
b = 2*dot(B,A-C);
c = dot(A-C,A-C)-r^2;

d = b.^2-4.*a.*c;

solExists = d>=0;

t = ((-b-sqrt(max(d,0)))./(2.*a));

HitPos = A+t.*B;

HitPos(:,~solExists) = NaN;

NormalVec = HitPos-ArcPos;
NormalVec = NormalVec./vecnorm(NormalVec);

HitAngle = atan2(NormalVec(2,:),NormalVec(1,:));

if ArcRange(1) < ArcRange(2)
    inRange = HitAngle<ArcRange(1) | HitAngle>ArcRange(2);
else
    inRange = HitAngle>ArcRange(1) & HitAngle<ArcRange(2);
end

HitPos(:,~inRange) = NaN;
NormalVec(:,~inRange) = NaN;

end

