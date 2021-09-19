function [RGB,style] = wavelengthToRGB(wavelength, gamma)
if nargin == 1
    gamma = 0.8;
end


style='-';

if (wavelength >= 380 && wavelength <= 440)
    attenuation = 0.3 + 0.7 * (wavelength - 380) / (440 - 380);
    R = ((-(wavelength - 440) / (440 - 380)) * attenuation) ^ gamma;
    G = 0.0;
    B = (1.0 * attenuation) ^ gamma;
    
elseif (wavelength >= 440 && wavelength <= 490)
    R = 0.0;
    G = ((wavelength - 440) / (490 - 440)) ^ gamma;
    B = 1.0;
    
elseif (wavelength >= 490 && wavelength <= 510)
    R = 0.0;
    G = 1.0;
    B = (-(wavelength - 510) / (510 - 490)) ^ gamma;
    
elseif (wavelength >= 510 && wavelength <= 580)
    R = ((wavelength - 510) / (580 - 510)) ^ gamma;
    G = 1.0;
    B = 0.0;
    
elseif (wavelength >= 580 && wavelength <= 645)
    R = 1.0;
    G = (-(wavelength - 645) / (645 - 580)) ^ gamma;
    B = 0.0;
    
elseif (wavelength >= 645 && wavelength <= 750)
    attenuation = 0.3 + 0.7 * (750 - wavelength) / (750 - 645);
    R = (1.0 * attenuation) ^ gamma;
    G = 0.0;
    B = 0.0;
    
else
    style = '--';
    if wavelength > 750
        R = 0.3817;
        G = 0.0;
        B = 0.0;
    else
        R = 0.3817;
        G = 0.0;
        B = 0.3817;
    end
end

RGB = [R G B];
end