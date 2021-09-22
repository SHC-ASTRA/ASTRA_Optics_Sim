tic
maxPlotRays = 1000;
[RayVec,Lambdas] = initializeRays(10000000, [-0.01,0.01], deg2rad([-10,10]), [400,700]);

focalLength = 50;
preLensFreeSpaceLength = focalLength;
postLensFreeSpaceLength = 10;
FreeSpaceTransferMatrix = [1 preLensFreeSpaceLength; 0 1];
LensTransferMatrix = [1 0; -1/focalLength 1];
FreeSpace2TransferMatrix = [1 postLensFreeSpaceLength; 0 1];

RayVec2 = FreeSpaceTransferMatrix*RayVec;
RayVec3 = LensTransferMatrix*RayVec2;
RayVec4 = FreeSpace2TransferMatrix*RayVec3;
toc

PlotY = RayVecToPlotForm(RayVec);
PlotX = repelem(0,size(RayVec,2));
Y_2 = RayVecToPlotForm(RayVec2);
PlotY = [PlotY;Y_2];
PlotX = [PlotX;repelem(50,size(RayVec,2))];
Y_2 = RayVecToPlotForm(RayVec3);
PlotY = [PlotY;Y_2];
PlotX = [PlotX;repelem(50,size(RayVec,2))];
Y_2 = RayVecToPlotForm(RayVec4);
PlotY = [PlotY;Y_2];
PlotX = [PlotX;repelem(60,size(RayVec,2))];

toc

numRays = size(PlotX,2);
period = numRays/maxPlotRays;
if period > 1
    period = round(period);
    PlotX = PlotX(:,1:period:end);
    PlotY = PlotY(:,1:period:end);
    Lambdas = Lambdas(:,1:period:end);
end

colors = gather(wavelengthToRGB(Lambdas));

h = plot(PlotX,PlotY);
set(h, {'color'}, num2cell(colors,2));
axis equal
toc