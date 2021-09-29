classdef OpticalDetector < OpticalElement
    %OPTICALDETECTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        width
        bins
    end
    
    methods
        function obj = OpticalDetector(Position,PointingVec,width,bins)
            obj@OpticalElement(Position,PointingVec);
            obj.width = width;
            obj.bins = bins;
        end
        function [RayPos,RayVec,PlotX,PlotY,sensor_hits] = ApplyElement(obj,RayPos,RayVec,Lambda,PlotX,PlotY)
                StartPos = obj.Position + obj.TangentVec*(obj.width/2);
                EndPos = obj.Position - obj.TangentVec*(obj.width/2);
                [RayPos,~,u] = intersectRayLine(RayPos,RayVec,StartPos,EndPos);
                sensor_hits = u;
                PlotX(end+1,:) = RayPos(1,:);
                PlotY(end+1,:) = RayPos(2,:);
        end
        function plotElement(obj,edgeColor,faceColor,edgeAlpha,faceAlpha)
            if ~exist('edgeColor','var') || isempty(edgeColor)
                edgeColor = [0.33,0.33,0.33];
            end
            if ~exist('faceColor','var') || isempty(faceColor)
                faceColor = [0.33,0.33,0.33];
            end
            if ~exist('edgeAlpha','var') || isempty(edgeAlpha)
                edgeAlpha = 0.5;
            end
            if ~exist('faceAlpha','var') || isempty(faceAlpha)
                faceAlpha = 0.2;
            end
            
            
            points = obj.Position+obj.width/2*[obj.TangentVec,-obj.TangentVec];
            plot(points(1,:),points(2,:),Color=edgeColor)
        end
    end
end
