% 
% rayAng = 30;
% [HitPos,NormalVec] = intersectRayArc([0;0],[cosd(rayAng);sind(rayAng)],[1;0],2,[cosd(70);sind(70)],[cosd(-70);sind(-70)])
% 
% figure();
% plot([0;5*cosd(rayAng)],[0;5*sind(rayAng)],"b:")
% hold on
% axis equal
% plot(1+2*cos(linspace(-pi,pi)),2*sin(linspace(-pi,pi)),'k:')
% plot(HitPos(1),HitPos(2),'ro')
% plot(HitPos(1)+[0;NormalVec(1)],HitPos(2)+[0;NormalVec(2)],'r')
% 
% return
tic
maxPlotRays = 1000;

[RayPos,RayVec,Lambda] = initializeRays(10000000, [-0.01,0.01], [-0.01,0.01], deg2rad([-10,10]), [380,700]);
PlotX = [];
PlotY = [];

lens1 = PlanoConvexLens([47.4;0],[-1;0],25.8,20,4,false,@nbk7RefractiveIndex,@airRefractiveIndex);
lens2 = PlanoConvexLens([70;0],[-1;0],19.7,25.4,6.6,true,@nbk7RefractiveIndex,@airRefractiveIndex);

disp("Init time: "+toc+" s"); tic;

PlotX(end+1,:) = RayPos(1,:);
PlotY(end+1,:) = RayPos(2,:);


[RayPos,RayVec,PlotX,PlotY] = lens1.ApplyElement(RayPos,RayVec,Lambda,PlotX,PlotY);
[RayPos,RayVec,PlotX,PlotY] = lens2.ApplyElement(RayPos,RayVec,Lambda,PlotX,PlotY);

PlotX(end+1,:) = RayPos(1,:)+RayVec(1,:)*40;
PlotY(end+1,:) = RayPos(2,:)+RayVec(2,:)*40;

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
clf
h = plot(PlotX,PlotY);
set(h, {'color'}, num2cell(colors,2));
axis equal
hold on

lens1.plotElement();
lens2.plotElement();

disp("Plot time: "+toc+" s"); tic;