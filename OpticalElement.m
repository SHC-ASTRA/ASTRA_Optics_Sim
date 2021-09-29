classdef OpticalElement
    properties
        Position
        PointingVec
        TangentVec
    end
    
    methods
        function obj = OpticalElement(Position,PointingVec)
            obj.Position = Position;
            obj.PointingVec = PointingVec/norm(PointingVec);
            obj.TangentVec = [obj.PointingVec(2);-obj.PointingVec(1)];
        end
        function [RayPos,RayVec,PlotX,PlotY] = ApplyElement(obj,RayPos,RayVec,Lambda,PlotX,PlotY)
        end
        function plotElement(obj,edgeColor,faceColor,edgeAlpha,faceAlpha)
        end
        
    end
end