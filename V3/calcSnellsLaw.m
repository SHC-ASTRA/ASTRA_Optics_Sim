function [TransmittedVec] = calcSnellsLaw(IncidentVec,NormalVec,mu)

l = IncidentVec;
n = NormalVec;
c = -dot(n,l);
r = mu;

TransmittedVec = r.*l + (r.*c - sqrt(1-r.^2.*(1-c.^2))).*n;

end

