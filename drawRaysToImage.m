function I = drawRaysToImage(PlotX,PlotY,colors,horizBounds,vertBounds,xRes)

aspect = range(horizBounds)/range(vertBounds);
blank = gpuArray(zeros(round(xRes/aspect),xRes,3));
I = blank;

PlotX = round(((PlotX - min(horizBounds))./range(horizBounds))*xRes);
PlotY = round(((PlotY - min(vertBounds))./range(vertBounds))*xRes/aspect);

x = [PlotX(1,1);PlotX(2,1)];
y = [PlotY(1,1);PlotY(2,1)];

c = [[1; 1]  x(:)]\y(:);                        % Calculate Parameter Vector
slope_m = c(2);
intercept_b = c(1);

x_vals = x(1):1:x(2);
y_vals = round(slope_m*x_vals + intercept_b);

line_on_im = blank;

I = I + line_on_im;

end

