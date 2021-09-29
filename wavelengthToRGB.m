function [RGB,style] = wavelengthToRGB(wavelength, gamma)
if nargin == 1
    gamma = 0.8;
end

l_U380 = wavelength<=380;
l_380_440 = wavelength>380 & wavelength<=440;
l_440_490 = wavelength>440 & wavelength<=490;
l_490_510 = wavelength>490 & wavelength<=510;
l_510_580 = wavelength>510 & wavelength<=580;
l_580_645 = wavelength>580 & wavelength<=645;
l_645_750 = wavelength>645 & wavelength<=750;
l_O750 = wavelength>750;

R_U380 = 0.3817;
G_U380 = 0.0;
B_U380 = 0.3817;

lowAttenuation = 0.3 + 0.7 .* (wavelength - 380) ./ (440 - 380);
R_380_440 = max(((-(wavelength - 440) ./ (440 - 380)) .* lowAttenuation),0) .^ gamma;
G_380_440 = 0.0;
B_380_440 = (1.0 .* lowAttenuation) .^ gamma;

R_440_490 = 0.0;
G_440_490 = max(((wavelength - 440) ./ (490 - 440)),0) .^ gamma;
B_440_490 = 1.0;

R_490_510 = 0.0;
G_490_510 = 1.0;
B_490_510 = max((-(wavelength - 510) ./ (510 - 490)),0) .^ gamma;

R_510_580 = max(((wavelength - 510) ./ (580 - 510)),0) .^ gamma;
G_510_580 = 1.0;
B_510_580 = 0.0;

R_580_645 = 1.0;
G_580_645 = max((-(wavelength - 645) ./ (645 - 580)),0) .^ gamma;
B_580_645 = 0.0;

highAttenuation = 0.3 + 0.7 .* (750 - wavelength) ./ (750 - 645);
R_645_750 = max((1.0 * highAttenuation),0) .^ gamma;
G_645_750 = 0.0;
B_645_750 = 0.0;

R_O750 = 0.3817;
G_O750 = 0.0;
B_O750 = 0.0;

R = R_U380.*l_U380 + R_380_440.*l_380_440 + R_440_490.*l_440_490 + R_490_510.*l_490_510 + R_510_580.*l_510_580 + R_580_645.*l_580_645 + R_645_750.*l_645_750 + R_O750.*l_O750;
G = G_U380.*l_U380 + G_380_440.*l_380_440 + G_440_490.*l_440_490 + G_490_510.*l_490_510 + G_510_580.*l_510_580 + G_580_645.*l_580_645 + G_645_750.*l_645_750 + G_O750.*l_O750;
B = B_U380.*l_U380 + B_380_440.*l_380_440 + B_440_490.*l_440_490 + B_490_510.*l_490_510 + B_510_580.*l_510_580 + B_580_645.*l_580_645 + B_645_750.*l_645_750 + B_O750.*l_O750;

l_380_750 = wavelength>380 & wavelength<=750;
l_U380_O750 = ~l_380_750;

style_380_750='-';
style_U380_O750='--';


RGB = [R' G' B'];
end