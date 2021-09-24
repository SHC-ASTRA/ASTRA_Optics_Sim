tic
maxPlotRays = 1000;

[RayPos,RayVec,Lambdas] = initializeRays(10000000, [-0.01,0.01], [-0.01,0.01], deg2rad([-10,10]), [380,700]);
n_air = airRefractiveIndex(Lambdas);
n_nbk7 = nbk7RefractiveIndex(Lambdas);
PlotX = [];
PlotY = [];
disp("Init time: "+toc+" s"); tic;

PlotX(end+1,:) = RayPos(1,:);
PlotY(end+1,:) = RayPos(2,:);

[RayPos,NormalVec] = intersectRayArc(RayPos,RayVec,[44.47+4+25.8;0],25.8,deg2rad([-180+20,180-20]));
PlotX(end+1,:) = RayPos(1,:);
PlotY(end+1,:) = RayPos(2,:);


mu = n_air./n_nbk7;
[TransmittedVec] = calcSnellsLaw(RayVec,NormalVec,mu);
PlotX(end+1,:) = RayPos(1,:)+TransmittedVec(1,:)*10;
PlotY(end+1,:) = RayPos(2,:)+TransmittedVec(2,:)*10;


disp("Calc time: "+toc+" s"); tic;

numRays = size(PlotX,2);
period = numRays/maxPlotRays;
if period > 1
    period = round(period);
    PlotX = PlotX(:,1:period:end);
    PlotY = PlotY(:,1:period:end);
    PlotLambdas = Lambdas(:,1:period:end);
end

colors = gather(wavelengthToRGB(PlotLambdas));
colors = [colors, repelem(0.01,size(colors,1))'];
figure(1);
clf
h = plot(PlotX,PlotY);
set(h, {'color'}, num2cell(colors,2));
axis equal
hold on

plot(44.47+4+25.8+25.8*cosd(180+linspace(-20,20)),25.8*sind(180+linspace(-20,20)),'b-')
disp("Plot time: "+toc+" s"); tic;