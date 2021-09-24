classdef PlanoConvexLens < OpticalElement
    %PLANOCONVEXLENS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        radius
        width
        thickness
        curvedFirst
    end
    
    methods
        function obj = PlanoConvexLens(Position,Rotation,radius,width,thickness,curvedFirst)
            obj@OpticalElement(Position,Rotation);
            obj.radius = radius;
            obj.width = width;
            obj.thickness = thickness;
            obj.curvedFirst = curvedFirst;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

