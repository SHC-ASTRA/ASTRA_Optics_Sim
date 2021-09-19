clear

rayOrigin = [-0.055, 0];
initAngles = deg2rad(linspace(-10,10,500));
maxLength = 0.3;
alpha = 0.02;
% alpha = 1;
wavelengths = linspace(400,700,8);
% balmerResolution = 0.1;
% wavelengths = [repelem(656.2852,floor(180*balmerResolution)),...
%                 repelem(656.272,floor(120*balmerResolution)),...
%                 repelem(486.133,floor(80*balmerResolution)),...
%                 repelem(434.047,floor(30*balmerResolution)),...
%                 repelem(410.174,floor(15*balmerResolution))];

gratingX = 0;
m = -1;
linesPerMM = 300;
d = 1/linesPerMM * 0.001;

lens1Dist = 0.005;
lens1Radius = 0.0127;
lens1FocalLength = -rayOrigin(1)-lens1Dist;

lens2Angle = abs(diffract(0,m,d,wavelengths(end))+diffract(0,m,d,wavelengths(1)))/2;
lens2Dist = 0.01;
lens2Radius = 0.0127;
lens2FocalLength = 0.075;

sensorAngle = lens2Angle;
sensorDist = lens2Dist+lens2FocalLength;
sensorRadius = 0.008/2; % Not really a radius, just half the length
sensorBins = 1024;

i = 1;
for lambda = wavelengths
    for angle = initAngles
        rays(i).wavelength = lambda;
        rays(i).x0 = rayOrigin(1);
        rays(i).y0 = rayOrigin(2);
        rays(i).dx = cos(angle);
        rays(i).dy = sin(angle);
        rays(i).length = maxLength;
        i = i+1;
    end
end

iPreCollimator = i;

lens1Matrix = [1 0; -1/(lens1FocalLength) 1];


lens1CenterX = -lens1Dist;
lens1CenterY = 0;
lens1Angle = 0;
lens1dx = 0;
lens1dy = 1;
lens1X = [lens1CenterX-lens1Radius*lens1dx lens1CenterX+lens1Radius*lens1dx];
lens1Y = [lens1CenterY+lens1Radius*lens1dy lens1CenterY-lens1Radius*lens1dy];

for j = 1:iPreCollimator-1
    
    rayx1 = [rays(j).x0 rays(j).x0+rays(j).dx*rays(j).length];
    rayy1 = [rays(j).y0 rays(j).y0+rays(j).dy*rays(j).length];
    
    [xi,yi] = polyxpoly(rayx1,rayy1,lens1X,lens1Y);
    
    if ~isempty(xi)
        rays(j).length = sqrt((rays(j).x0-xi)^2 + (rays(j).y0-yi)^2);
        
        x1=(sqrt((lens1CenterX-xi)^2 + (lens1CenterY-yi)^2) * -sign(yi-lens1CenterY));
        rayAngle = atan2(rays(j).dy,rays(j).dx);
        theta = -(rayAngle-lens1Angle);
        %theta = deg2rad(theta);
        
        rayVec = [x1;theta];
        
        outgoingVec = lens1Matrix*rayVec;
        
        x2 = outgoingVec(1);
        theta2 = -outgoingVec(2);
        
        newAngle = lens1Angle+theta2;
        
        rays(i).wavelength = rays(j).wavelength;
        rays(i).x0 = lens1CenterX+lens1dx*x2;
        rays(i).y0 = lens1CenterY-lens1dy*x2;
        rays(i).dx = cos(newAngle);
        rays(i).dy = sin(newAngle);
        rays(i).length = maxLength;
        
        i = i+1;
    end

end

iPreGrating = i;

for j = iPreCollimator:iPreGrating-1
    
    rays(j).length = (gratingX - rays(j).x0)/rays(j).dx;
    
    newAngle = diffract(rays(j).dy,m,d,rays(j).wavelength);
    
    rays(i).wavelength = rays(j).wavelength;
    rays(i).x0 = rays(j).x0 + rays(j).length*rays(j).dx;
    rays(i).y0 = rays(j).y0 + rays(j).length*rays(j).dy;
    rays(i).dx = cos(newAngle);
    rays(i).dy = sin(newAngle);
    rays(i).length = maxLength;
    
    if imag(rays(i).dx) ~= 0 || imag(rays(i).dy) ~= 0
        rays(i) = [];
    else
        i = i+1;
    end
    
end

iPostGrating = i;

lens2Matrix = [1 0; -1/(lens2FocalLength) 1];

lens2CenterX = gratingX+lens2Dist*cos(lens2Angle);
lens2CenterY = lens2Dist*sin(lens2Angle);
lens2dx = cos(pi/2-lens2Angle);
lens2dy = sin(pi/2-lens2Angle);
lens2X = [lens2CenterX-lens2Radius*lens2dx lens2CenterX+lens2Radius*lens2dx];
lens2Y = [lens2CenterY+lens2Radius*lens2dy lens2CenterY-lens2Radius*lens2dy];


for j = iPreGrating:iPostGrating-1
    
    rayx1 = [rays(j).x0 rays(j).x0+rays(j).dx*rays(j).length];
    rayy1 = [rays(j).y0 rays(j).y0+rays(j).dy*rays(j).length];
    
    [xi,yi] = polyxpoly(rayx1,rayy1,lens2X,lens2Y);
    
    if ~isempty(xi)
         rays(j).length = sqrt((rays(j).x0-xi)^2 + (rays(j).y0-yi)^2);
        
        x1=(sqrt((lens2CenterX-xi)^2 + (lens2CenterY-yi)^2) * -sign(yi-lens2CenterY));
        rayAngle = atan2(rays(j).dy,rays(j).dx);
        theta = -(rayAngle-lens2Angle);
        %theta = deg2rad(theta);
        
        rayVec = [x1;theta];
        
        outgoingVec = lens2Matrix*rayVec;
        
        x2 = outgoingVec(1);
        theta2 = -outgoingVec(2);
        
        newAngle = lens2Angle+theta2;
        
        rays(i).wavelength = rays(j).wavelength;
        rays(i).x0 = lens2CenterX+lens2dx*x2;
        rays(i).y0 = lens2CenterY-lens2dy*x2;
        rays(i).dx = cos(newAngle);
        rays(i).dy = sin(newAngle);
        rays(i).length = maxLength;
        
        i = i+1;
    end

end

iPostFocusLens = i;

sensorCenterX = gratingX+sensorDist*cos(sensorAngle);
sensorCenterY = sensorDist*sin(sensorAngle);
sensordx = cos(pi/2-sensorAngle);
sensordy = sin(pi/2-sensorAngle);
sensorX = [sensorCenterX-sensorRadius*sensordx sensorCenterX+sensorRadius*sensordx];
sensorY = [sensorCenterY+sensorRadius*sensordy sensorCenterY-sensorRadius*sensordy];

sensorHitsLambda = [];
sensorHitsX = [];

for j = iPostGrating:iPostFocusLens-1
    
    rayx1 = [rays(j).x0 rays(j).x0+rays(j).dx*rays(j).length];
    rayy1 = [rays(j).y0 rays(j).y0+rays(j).dy*rays(j).length];
    
    [xi,yi] = polyxpoly(rayx1,rayy1,sensorX,sensorY);
    
    if ~isempty(xi)
         rays(j).length = sqrt((rays(j).x0-xi)^2 + (rays(j).y0-yi)^2);
        
        x1=(sqrt((sensorCenterX-xi)^2 + (sensorCenterY-yi)^2) * -sign(yi-sensorCenterY));
        sensorHitsLambda(end+1) = rays(j).wavelength;
        sensorHitsX(end+1) = x1;
        
    end

end

figure(1);
clf
xlabel("X Position (m)");
ylabel("Y Position (m)");
hold on
rays = rays(randperm(length(rays)));
for ray = rays
    [rgb, style] = wavelengthToRGB(ray.wavelength);
    rgba = [rgb, alpha];
    plot([ray.x0 ray.x0+ray.dx*ray.length], [ray.y0 ray.y0+ray.dy*ray.length],style, 'Color',rgba)
end
axis equal

plot(lens1X,lens1Y,'b')
plot(lens2X,lens2Y,'b')
plot(sensorX,sensorY,'k')

xlim manual

plot([gratingX gratingX],[-0.1 0.1],'k:')
plot([gratingX gratingX+0.2*cos(lens2Angle)],[0 0.2*sin(lens2Angle)],'b:')

hold off
%%
figure(2);
clf
[sensorData,~,bin] = histcounts(sensorHitsX,linspace(-sensorRadius,sensorRadius,sensorBins+1));
b = bar(sensorData, 1, 'facecolor', 'flat');
colors = zeros(sensorBins,3);
binColorCounts = zeros(sensorBins,1);
for i = 1:numel(sensorHitsLambda)
    binNum = bin(i);
    colors(binNum,:) = colors(binNum,:) + wavelengthToRGB(sensorHitsLambda(i));
    binColorCounts(binNum) = binColorCounts(binNum)+1;
end
colors = colors./binColorCounts;
b.CData = colors;
xlabel("Sensor Pixel");
ylabel("Rays Hitting Pixel");
xlim([0,sensorBins]);