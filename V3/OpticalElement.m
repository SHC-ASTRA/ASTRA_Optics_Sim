classdef OpticalElement
    properties
        Position
        Rotation
    end
    
    methods
        function obj = OpticalElement(Position,Rotation)
            obj.Position = Position;
            obj.Rotation = Rotation;
        end
        function [RayPos,RayVec,PlotX,PlotY] = ApplyElement(RayPos,RayVec,PlotX,PlotY)
        end
        function plotElement(edgeColor,faceColor)
        end
        
    end
end