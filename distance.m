%{
Attribution-NonCommercial-ShareAlike 3.0 Unported (CC BY-NC-SA 3.0)
Function to obtain the distance to stop the spacecraft since the trigger
%}

function [distanceOrb, earthDistance] = distance(generatedTime, spacecraftSpeed)
distanceOrb = generatedTime*spacecraftSpeed; % distance in km
earthDistance = 6378*distanceOrb/6778.14;
end