function angle = diffract(sinTheta_i,m,d,lambda)
if lambda < 1
    warning("diffract() expects lamba in nm, check units")
end

angle = asind(sinTheta_i-m*lambda*1e-9/d);

end

