tic
maxPlotRays = 10000;
[RayVec,Lambdas] = initializeRays(10000000, [-0.01,0.01], deg2rad([-10,10]), [380,700]);

focalLength = 50;
focalLength2 = 50;
preLensFreeSpaceLength = focalLength;
postLensFreeSpaceLength = 10;
FreeSpaceTransferMatrix = [1 preLensFreeSpaceLength; 0 1];
Lens1TransferMatrix = [1 0; -1/focalLength 1];
FreeSpace2TransferMatrix = [1 postLensFreeSpaceLength; 0 1];
FreeSpace3TransferMatrix = [1 postLensFreeSpaceLength; 0 1];
Lens2TransferMatrix = [1 0; -1/focalLength2 1];
FreeSpace4TransferMatrix = [1 focalLength2; 0 1];

RayVec2 = [RayVec(1,:)+tan(RayVec(2,:))*preLensFreeSpaceLength; RayVec(2,:)];
RayVec3 = Lens1TransferMatrix*RayVec2;
RayVec4 = [RayVec3(1,:)+tan(RayVec3(2,:))*postLensFreeSpaceLength; RayVec3(2,:)];

m = -1;%randi([-1,1],1,size(RayVec,2));
linesPerMM = 600;
d = 1/linesPerMM * 0.001;

angles = asin(sin(RayVec4(2,:))-m.*Lambdas*1e-9/d);
RayVec5 = [RayVec4(1,:);angles];
RayVec6 = [RayVec5(1,:)+tan(RayVec5(2,:))*postLensFreeSpaceLength; RayVec5(2,:)];
RayVec7 = Lens2TransferMatrix*RayVec6;
RayVec8 = [RayVec7(1,:)+tan(RayVec7(2,:))*focalLength2; RayVec7(2,:)];
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
Y_2 = RayVecToPlotForm(RayVec5);
PlotY = [PlotY;Y_2];
PlotX = [PlotX;repelem(60,size(RayVec,2))];
Y_2 = RayVecToPlotForm(RayVec6);
PlotY = [PlotY;Y_2];
PlotX = [PlotX;repelem(70,size(RayVec,2))];
Y_2 = RayVecToPlotForm(RayVec7);
PlotY = [PlotY;Y_2];
PlotX = [PlotX;repelem(70,size(RayVec,2))];
Y_2 = RayVecToPlotForm(RayVec8);
PlotY = [PlotY;Y_2];
PlotX = [PlotX;repelem(70+50,size(RayVec,2))];

toc

sensorHitsLambda = Lambdas;

numRays = size(PlotX,2);
period = numRays/maxPlotRays;
if period > 1
    period = round(period);
    PlotX = PlotX(:,1:period:end);
    PlotY = PlotY(:,1:period:end);
    Lambdas = Lambdas(:,1:period:end);
end

colors = gather(wavelengthToRGB(Lambdas));
colors = [colors, repelem(0.01,size(colors,1))'];
figure(1);
clf
h = plot(PlotX,PlotY);
set(h, {'color'}, num2cell(colors,2));
axis equal
toc

%%
figure(2);
clf

sensorRadius = 1;
sensorBins = 1024;

[sensorData,~,bin] = histcounts(RayVec8(1,:),sensorBins);
b = bar(sensorData, 1, 'facecolor', 'flat');
colors2 = zeros(sensorBins,3);
fullColors = wavelengthToRGB(sensorHitsLambda);
for i = 1:sensorBins
    binNums = bin == i;
    binColors = fullColors(binNums,:);
    colors2(i,:) = sum(binColors,1)/size(binColors,1);
end
b.CData = colors2;
xlabel("Sensor Pixel");
ylabel("Rays Hitting Pixel");
xlim([0,sensorBins]);
toc

