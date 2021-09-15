%{

Attribution-NonCommercial-ShareAlike 3.0 Unported (CC BY-NC-SA 3.0)
This function calculates the torque 

http://hyperphysics.phy-astr.gsu.edu/hbase/rotq.html#avel

https://www.ngdc.noaa.gov/geomag/calculators/magcalc.shtml#igrfwmm
Earth magnetic field at Barcelona 400km above sea level
37,631.6 nT = 37631.6*10^-9 T

https://spacegrant.colorado.edu/COSGC_Projects/symposium_archive/2010/papers/CUSRS10_13%20Estimation%20of%20Small%20Satellite%20Magnetic%20Torquing%20and%20Momentum%20Storage%20Requirements.pdf
minMagneticMoment = 1.67324; % Am^2 minimum magnetic moment for a cubesat*, not used, just for testing

%}

function [generatedTime, moi, genTor] = torque(totalMagneticMoment, distancePhi,angleFields,side, mass, localMagneticField)

moi = 1/6 * mass * side^2;

angleFields = angleFields*pi / 180;
genTor=totalMagneticMoment*localMagneticField*sin(angleFields);

distancePhi = distancePhi*pi / 180;
generatedTime = sqrt(2*moi*distancePhi/genTor); %in seconds

end
