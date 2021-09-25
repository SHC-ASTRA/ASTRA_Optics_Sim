function [TransmittedVec] = calcSnellsLaw(IncidentVec,NormalVec,mu)

l = IncidentVec;
n = NormalVec;
c = -dot(n,l);
r = mu;

TransmittedVec = r.*l + (r.*c - sqrt(max(1-r.^2.*(1-c.^2),0))).*n;

end

