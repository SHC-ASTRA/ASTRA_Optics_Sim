clear
tic

%% Program Settings

maxTracedRays = 10000000; % Maximum number of rays to trace (usually between 10,000 and 10,000,000)
maxPlotRays = 250; % Maximum number of rays to plot (usually between 100 and 25,000)
doplot = true; % Setting this to false supresses all output


%% Design (units are mm and radians)

minLambda = 400; %Minimum design/sim wavelength
maxLambda = 700; %Maximum design/sim wavelength

gratingLinesPerMM = 600; %Grating Lines

%Angle of post-grating optical centerline
diffractAngle = abs(diffract(0,-1,1/gratingLinesPerMM * 0.001,maxLambda)+diffract(0,-1,1/gratingLinesPerMM * 0.001,minLambda))/2;

%Slit dimensions
slitWidth = 0.01;

%Lens 1 dimensions
lens1Radius = 25.8;
lens1Width = 20;
lens1Thickness = 4;
lens1BFL = 47.4;
%Lens 1 position
lens1DistFromSlit = lens1BFL;

%Grating dimensions
gratingWidth = 25;
gratingThickness = 3;
%Grating position
gratingPos = [57;0];

%Lens 2 dimensions
lens2Radius = 19.7;
lens2Width = 25.4;
lens2Thickness = 6.6;
lens2BFL = 38.12;
%Lens 2 position
lens2DistFromGratingCenter = 10;

%Detector dimensions
detectorPixels = 1024;
detectorWidth = 8;
%Detector position
detectoroffang = deg2rad(-20);
detectorDistFromGratingCenter = lens2DistFromGratingCenter+lens2BFL-5.3;

%% Create Elements
lens1 = PlanoConvexLens([lens1DistFromSlit;0],[-1;0],lens1Radius,lens1Width,lens1Thickness,false,@nbk7RefractiveIndex,@airRefractiveIndex);
lens2 = PlanoConvexLens(gratingPos+lens2DistFromGratingCenter*[cos(diffractAngle);sin(diffractAngle)],[cos(pi+diffractAngle);sin(pi+diffractAngle)],lens2Radius,lens2Width,lens2Thickness,true,@nbk7RefractiveIndex,@airRefractiveIndex);
grating1 = GratingOnSubtstrate(gratingPos,[-1;0],gratingLinesPerMM,-1,gratingWidth,gratingThickness,false,@b270RefractiveIndex,@airRefractiveIndex);
detector = OpticalDetector(gratingPos+(detectorDistFromGratingCenter)*[cos(diffractAngle);sin(diffractAngle)],[cos(pi+diffractAngle+detectoroffang);sin(pi+diffractAngle+detectoroffang)],detectorWidth,detectorPixels);

%% Setup Sim
[RayPos,RayVec,Lambda] = initializeRays(maxTracedRays, [0,0], [-slitWidth/2,slitWidth/2], deg2rad([-10,10]), [minLambda,maxLambda], 0.25, 1);
PlotX = [];
PlotY = [];

if doplot
    disp("Init time: "+toc+" s"); tic;
end

PlotX(end+1,:) = RayPos(1,:);
PlotY(end+1,:) = RayPos(2,:);

%% Do Sim
[RayPos,RayVec,PlotX,PlotY] = lens1.ApplyElement(RayPos,RayVec,Lambda,PlotX,PlotY);
[RayPos,RayVec,PlotX,PlotY] = grating1.ApplyElement(RayPos,RayVec,Lambda,PlotX,PlotY);
[RayPos,RayVec,PlotX,PlotY] = lens2.ApplyElement(RayPos,RayVec,Lambda,PlotX,PlotY);
[RayPos,RayVec,PlotX,PlotY,sensor_hits] = detector.ApplyElement(RayPos,RayVec,Lambda,PlotX,PlotY);

%% Output Results
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
    colors = [colors, repelem(0.02*(2500/maxPlotRays),size(colors,1))'];
    figure(1);
    hold off
    plot(0,0,"k+");
        

    hold on
    h = plot(PlotX,PlotY);
    set(h, {'color'}, num2cell(colors,2));
    axis equal
    xlim([-5 105])
    
    xlabel("X (mm)");
    ylabel("Y (mm)");
    title("Visualization of "+((maxPlotRays/maxTracedRays)*100)+"% of Traced Rays");
    
    
    lens1.plotElement();
    grating1.plotElement();
    lens2.plotElement();
    detector.plotElement();
    
    disp("Plot time: "+toc+" s"); tic;
end

[sensorData,~,bin] = histcounts(sensor_hits,linspace(0,detectorWidth,detectorPixels+1));

if doplot
    figure(2);
    hold off
    b = bar(sensorData, 1, 'facecolor', 'flat');
    colors2 = zeros(detectorPixels,3);
    fullColors = wavelengthToRGB(Lambda);
    for i = 1:detectorPixels
        binNums = bin == i;
        binColors = fullColors(binNums,:);
        colors2(i,:) = sum(binColors,1)/size(binColors,1);
    end
    b.CData = colors2;
    xlabel("Sensor Pixel");
    ylabel("Rays Hitting Pixel");
    title("Simulated Sensor Output");
    xlim([0,detectorPixels]);
    disp("Hist time: "+toc+" s"); tic;
end
