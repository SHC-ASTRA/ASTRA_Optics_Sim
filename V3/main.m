tic
maxPlotRays = 1000;

[RayPos,RayVec,Lambda] = initializeRays(10000000, [-0.01,0.01], [-0.01,0.01], deg2rad([-10,10]), [380,700]);
PlotX = [];
PlotY = [];
disp("Init time: "+toc+" s"); tic;

PlotX(end+1,:) = RayPos(1,:);
PlotY(end+1,:) = RayPos(2,:);

lens1 = PlanoConvexLens([47.4;0],[-1;0],25.8,20,4,false,@nbk7RefractiveIndex,@airRefractiveIndex);
[RayPos,RayVec,PlotX,PlotY] = lens1.ApplyElement(RayPos,RayVec,Lambda,PlotX,PlotY);

PlotX(end+1,:) = RayPos(1,:)+RayVec(1,:)*10;
PlotY(end+1,:) = RayPos(2,:)+RayVec(2,:)*10;

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
colors = [colors, repelem(0.1,size(colors,1))'];
figure(1);
clf
h = plot(PlotX,PlotY);
set(h, {'color'}, num2cell(colors,2));
axis equal
hold on

lens1.plotElement();

disp("Plot time: "+toc+" s"); tic;