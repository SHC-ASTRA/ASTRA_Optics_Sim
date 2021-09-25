tic
maxPlotRays = 1000;
doplot = true;

gpurng(100)

[RayPos,RayVec,Lambda] = initializeRays(500000, [0,0], [-0.010,0.010], deg2rad([-10,10]), [400,700], 0, 2);
PlotX = [];
PlotY = [];

gratingLines = 600;
d = 1/gratingLines * 0.001;
diffractAngle = abs(diffract(0,-1,d,700)+diffract(0,-1,d,400))/2;
lens1Radius = 25.8;
lens1Width = 20;
lens1Thickness = 4;
lens1BFL = 47.4;

lens2Radius = 19.7;
lens2Width = 25.4;
lens2Thickness = 6.6;
lens2Dist = 10;
lens2BFL = 38.12-5.3;

detectoroffang = deg2rad(-20);

lens1 = PlanoConvexLens([lens1BFL;0],[-1;0],lens1Radius,lens1Width,lens1Thickness,false,@nbk7RefractiveIndex,@airRefractiveIndex);
lens2 = PlanoConvexLens([57;0]+lens2Dist*[cos(diffractAngle);sin(diffractAngle)],[cos(pi+diffractAngle);sin(pi+diffractAngle)],lens2Radius,lens2Width,lens2Thickness,true,@nbk7RefractiveIndex,@airRefractiveIndex);
grating1 = GratingOnSubtstrate([57;0],[-1;0],gratingLines,-1,25,3,false,@b270RefractiveIndex,@airRefractiveIndex);
detector = OpticalDetector([57;0]+(lens2Dist+lens2BFL)*[cos(diffractAngle);sin(diffractAngle)],[cos(pi+diffractAngle+detectoroffang);sin(pi+diffractAngle+detectoroffang)],8,1024);

if doplot
    disp("Init time: "+toc+" s"); tic;
end

PlotX(end+1,:) = RayPos(1,:);
PlotY(end+1,:) = RayPos(2,:);


[RayPos,RayVec,PlotX,PlotY] = lens1.ApplyElement(RayPos,RayVec,Lambda,PlotX,PlotY);
[RayPos,RayVec,PlotX,PlotY] = grating1.ApplyElement(RayPos,RayVec,Lambda,PlotX,PlotY);
[RayPos,RayVec,PlotX,PlotY] = lens2.ApplyElement(RayPos,RayVec,Lambda,PlotX,PlotY);
[RayPos,RayVec,PlotX,PlotY,sensor_hits] = detector.ApplyElement(RayPos,RayVec,Lambda,PlotX,PlotY);

% PlotX(end+1,:) = RayPos(1,:)+RayVec(1,:)*40;
% PlotY(end+1,:) = RayPos(2,:)+RayVec(2,:)*40;

if doplot
    disp("Calc time: "+toc+" s"); tic;
    
    numRays = size(PlotX,2);
    period = numRays/maxPlotRays;
    if period > 1
        period = round(period);
        PlotX = PlotX(:,1:period:end);
        PlotY = PlotY(:,1:period:end);
        PlotLambdas = Lambda(:,1:period:end);
    end
    
    colors = gather(wavelengthToRGB(PlotLambdas));
    colors = [colors, repelem(0.1,size(colors,1))'];
    figure(1);
    hold off
    h = plot(PlotX,PlotY);
    set(h, {'color'}, num2cell(colors,2));
    axis equal
%     xlim([96 108]);
%     ylim([10 22]);
    hold on
    
    lens1.plotElement();
    grating1.plotElement();
    lens2.plotElement();
    detector.plotElement();
    
    disp("Plot time: "+toc+" s"); tic;
end

sensorRadius = 8;
sensorBins = 1024;

[sensorData,~,bin] = histcounts(sensor_hits,linspace(0,sensorRadius,sensorBins+1));

if doplot
    figure(2);
    hold off
    b = bar(sensorData, 1, 'facecolor', 'flat');
    colors2 = zeros(sensorBins,3);
    fullColors = wavelengthToRGB(Lambda);
    for i = 1:sensorBins
        binNums = bin == i;
        binColors = fullColors(binNums,:);
        colors2(i,:) = sum(binColors,1)/size(binColors,1);
    end
    b.CData = colors2;
    xlabel("Sensor Pixel");
    ylabel("Rays Hitting Pixel");
    xlim([0,sensorBins]);
    disp("Hist time: "+toc+" s"); tic;
end
