classdef PlanoConvexLens < OpticalElement
    %PLANOCONVEXLENS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        radius
        width
        thickness
        curvedFirst
        n_medium_func
        n_air_func
    end
    
    methods
        function obj = PlanoConvexLens(Position,PointingVec,radius,width,thickness,curvedFirst,n_medium_func,n_air_func)
            obj@OpticalElement(Position,PointingVec);
            obj.radius = radius;
            obj.width = width;
            obj.thickness = thickness;
            obj.curvedFirst = curvedFirst;
            obj.n_medium_func = n_medium_func;
            obj.n_air_func = n_air_func;
        end
        
        function [RayPos,RayVec,PlotX,PlotY] = ApplyElement(obj,RayPos,RayVec,Lambda,PlotX,PlotY)
            if obj.curvedFirst
                Center = obj.Position + obj.PointingVec*(obj.thickness-obj.radius);
                L = obj.radius*cos(asin(obj.width/(2*obj.radius)));
                FromVec = obj.PointingVec*(L) + obj.TangentVec*(obj.width/2);
                ToVec = obj.PointingVec*(L) - obj.TangentVec*(obj.width/2);
                [RayPos,NormalVec] = intersectRayArc(RayPos,RayVec,Center,obj.radius,FromVec,ToVec);
                PlotX(end+1,:) = RayPos(1,:);
                PlotY(end+1,:) = RayPos(2,:);
                
                mu = obj.n_air_func(Lambda)./obj.n_medium_func(Lambda);
                TransmittedVec = calcSnellsLaw(RayVec,NormalVec,mu);
                RayVec = TransmittedVec;
                
                StartPos = obj.Position + obj.TangentVec*(obj.width/2);
                EndPos = obj.Position - obj.TangentVec*(obj.width/2);
                [RayPos,NormalVec] = intersectRayLine(RayPos,RayVec,StartPos,EndPos);
                PlotX(end+1,:) = RayPos(1,:);
                PlotY(end+1,:) = RayPos(2,:);
                
                mu = obj.n_medium_func(Lambda)./obj.n_air_func(Lambda);
                TransmittedVec = calcSnellsLaw(RayVec,NormalVec,mu);
                RayVec = TransmittedVec;
                
            else
                StartPos = obj.Position + obj.TangentVec*(obj.width/2);
                EndPos = obj.Position - obj.TangentVec*(obj.width/2);
                [RayPos,NormalVec] = intersectRayLine(RayPos,RayVec,StartPos,EndPos);
                PlotX(end+1,:) = RayPos(1,:);
                PlotY(end+1,:) = RayPos(2,:);
                
                mu = obj.n_air_func(Lambda)./obj.n_medium_func(Lambda);
                TransmittedVec = calcSnellsLaw(RayVec,NormalVec,mu);
                RayVec = TransmittedVec;
                
                Center = obj.Position - obj.PointingVec*(obj.thickness-obj.radius);
                L = obj.radius*cos(asin(obj.width/(2*obj.radius)));
                FromVec = obj.PointingVec*(-L) + obj.TangentVec*(obj.width/2);
                ToVec = obj.PointingVec*(-L) - obj.TangentVec*(obj.width/2);
                [RayPos,NormalVec] = intersectRayArc(RayPos,RayVec,Center,obj.radius,FromVec,ToVec);
                PlotX(end+1,:) = RayPos(1,:);
                PlotY(end+1,:) = RayPos(2,:);
                
                mu = obj.n_medium_func(Lambda)./obj.n_air_func(Lambda);
                TransmittedVec = calcSnellsLaw(RayVec,NormalVec,mu);
                RayVec = TransmittedVec;
            end
        end
        
        function plotElement(obj,edgeColor,faceColor,edgeAlpha,faceAlpha)
            if ~exist('edgeColor','var') || isempty(edgeColor)
                edgeColor = [66/255,135/255,245/255];
            end
            if ~exist('faceColor','var') || isempty(faceColor)
                faceColor = [66/255,135/255,245/255];
            end
            if ~exist('edgeAlpha','var') || isempty(edgeAlpha)
                edgeAlpha = 0.5;
            end
            if ~exist('faceAlpha','var') || isempty(faceAlpha)
                faceAlpha = 0.2;
            end
            
            if obj.curvedFirst
                Center = obj.Position + obj.PointingVec*(obj.thickness-obj.radius);
                L = obj.radius*cos(asin(obj.width/(2*obj.radius)));
                FromVec = obj.PointingVec*(L) + obj.TangentVec*(obj.width/2);
                ToVec = obj.PointingVec*(L) - obj.TangentVec*(obj.width/2);
                
                startAngle = atan2(FromVec(2),FromVec(1));
                endAngle = atan2(ToVec(2),ToVec(1));
                if abs(startAngle-endAngle) > pi
                    if startAngle > endAngle
                        endAngle = endAngle + 2*pi;
                    else
                        startAngle = startAngle+2*pi;
                    end
                end
                
                points = Center + [obj.radius*cos(linspace(startAngle,endAngle)); obj.radius*sin(linspace(startAngle,endAngle))];
                points = [points, obj.Position - obj.TangentVec*(obj.width/2), obj.Position + obj.TangentVec*(obj.width/2)];
                plot(polyshape(points'),FaceColor = faceColor,EdgeColor = edgeColor,FaceAlpha = faceAlpha, EdgeAlpha = edgeAlpha);
                plot(obj.Position(1),obj.Position(2),'+',Color=edgeColor);
            else
                Center = obj.Position - obj.PointingVec*(obj.thickness-obj.radius);
                L = obj.radius*cos(asin(obj.width/(2*obj.radius)));
                FromVec = obj.PointingVec*(L) + obj.TangentVec*(obj.width/2);
                ToVec = obj.PointingVec*(L) - obj.TangentVec*(obj.width/2);
                
                startAngle = atan2(FromVec(2),FromVec(1));
                endAngle = atan2(ToVec(2),ToVec(1));
                if abs(startAngle-endAngle) > pi
                    if startAngle > endAngle
                        endAngle = endAngle + 2*pi;
                    else
                        startAngle = startAngle+2*pi;
                    end
                end
                
                points = Center - [obj.radius*cos(linspace(startAngle,endAngle)); obj.radius*sin(linspace(startAngle,endAngle))];
                points = [points, obj.Position + obj.TangentVec*(obj.width/2), obj.Position - obj.TangentVec*(obj.width/2)];
                plot(polyshape(points'),FaceColor = faceColor,EdgeColor = edgeColor,FaceAlpha = faceAlpha, EdgeAlpha = edgeAlpha);
                plot(obj.Position(1),obj.Position(2),'+',Color=edgeColor);
            end
        end
        
    end
end

