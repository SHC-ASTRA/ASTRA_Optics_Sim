classdef GratingOnSubtstrate < OpticalElement
    properties
        lines_per_mm
        m
        width
        thickness
        gratingFirst
        n_medium_func
        n_air_func
    end
    
    methods
        function obj = GratingOnSubtstrate(Position,PointingVec,lines_per_mm,m,width,thickness,gratingFirst,n_medium_func,n_air_func)
            obj@OpticalElement(Position,PointingVec);
            obj.lines_per_mm = lines_per_mm;
            obj.m = m;
            obj.width = width;
            obj.thickness = thickness;
            obj.gratingFirst = gratingFirst;
            obj.n_medium_func = n_medium_func;
            obj.n_air_func = n_air_func;
        end
        
        function [RayPos,RayVec,PlotX,PlotY] = ApplyElement(obj,RayPos,RayVec,Lambda,PlotX,PlotY)
            
            
            d = 1/obj.lines_per_mm * 0.001;
            numRays = size(RayPos,2);
            
            if obj.gratingFirst
                RayProj = dot(RayVec,repelem(obj.PointingVec,1,numRays))./dot(obj.PointingVec,obj.PointingVec);
                RayRej = cross2(RayVec,repelem(obj.PointingVec,1,numRays))./dot(obj.PointingVec,obj.PointingVec);
                
                RelativeVec = [RayProj;RayRej];
                
                angle = asin(RelativeVec(2,:)-obj.m.*Lambda*1e-9./d);
                RayVec = [cos(angle).*RayVec(1,:) - sin(angle).*RayVec(2,:); sin(angle).*RayVec(1,:) + cos(angle).*RayVec(2,:)];
            end
            
            StartPos = obj.Position + ~obj.gratingFirst*obj.PointingVec*(obj.thickness) + obj.TangentVec*(obj.width/2);
            EndPos = obj.Position + ~obj.gratingFirst*obj.PointingVec*(obj.thickness) - obj.TangentVec*(obj.width/2);
            [RayPos,NormalVec] = intersectRayLine(RayPos,RayVec,StartPos,EndPos);
            PlotX(end+1,:) = RayPos(1,:);
            PlotY(end+1,:) = RayPos(2,:);
            
            mu = obj.n_air_func(Lambda)./obj.n_medium_func(Lambda);
            TransmittedVec = calcSnellsLaw(RayVec,NormalVec,mu);
            RayVec = TransmittedVec;
            
            StartPos = obj.Position - obj.gratingFirst*obj.PointingVec*(obj.thickness) + obj.TangentVec*(obj.width/2);
            EndPos = obj.Position - obj.gratingFirst*obj.PointingVec*(obj.thickness) - obj.TangentVec*(obj.width/2);
            [RayPos,NormalVec] = intersectRayLine(RayPos,RayVec,StartPos,EndPos);
            PlotX(end+1,:) = RayPos(1,:);
            PlotY(end+1,:) = RayPos(2,:);
            
            mu = obj.n_medium_func(Lambda)./obj.n_air_func(Lambda);
            TransmittedVec = calcSnellsLaw(RayVec,NormalVec,mu);
            RayVec = TransmittedVec;
            
            if ~obj.gratingFirst
                RayProj = dot(RayVec,repelem(obj.PointingVec,1,numRays))./dot(obj.PointingVec,obj.PointingVec);
                RayRej = cross2(RayVec,repelem(obj.PointingVec,1,numRays))./dot(obj.PointingVec,obj.PointingVec);
                
                RelativeVec = [RayProj;RayRej];
                
                angle = asin(RelativeVec(2,:)-obj.m.*Lambda*1e-9./d);
                RayVec = [cos(angle).*RayVec(1,:) - sin(angle).*RayVec(2,:); sin(angle).*RayVec(1,:) + cos(angle).*RayVec(2,:)];
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
            
            StartPosFront = obj.Position + ~obj.gratingFirst*obj.PointingVec*(obj.thickness) + obj.TangentVec*(obj.width/2);
            EndPosFront = obj.Position + ~obj.gratingFirst*obj.PointingVec*(obj.thickness) - obj.TangentVec*(obj.width/2);
            StartPosBack = obj.Position - obj.gratingFirst*obj.PointingVec*(obj.thickness) + obj.TangentVec*(obj.width/2);
            EndPosBack = obj.Position - obj.gratingFirst*obj.PointingVec*(obj.thickness) - obj.TangentVec*(obj.width/2);
            
            points = [StartPosFront,EndPosFront,EndPosBack,StartPosBack];
            if obj.gratingFirst
                gratingPoints = [StartPosFront,EndPosFront];
            else
                gratingPoints = [StartPosBack,EndPosBack];
            end
            plot(polyshape(points'),FaceColor = faceColor,EdgeColor = edgeColor,FaceAlpha = faceAlpha, EdgeAlpha = edgeAlpha);
            plot(gratingPoints(1,:),gratingPoints(2,:),'k:');
            plot(obj.Position(1),obj.Position(2),'+',Color=edgeColor);
        end
        
    end
end