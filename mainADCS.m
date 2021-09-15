%{
Attribution-NonCommercial-ShareAlike 3.0 Unported (CC BY-NC-SA 3.0)

Automated calculation for magnetic moments and torques for a pico spacecraft at 400 km, pocektcube 1U
Temperature ranges from* [-30, 45, 65]C  -> [243.15, 318.15, 338.15]K 
https://radian.systems/es/fossasat-1-data/

Square coils

Orbital radius: 6,778.14

[Random links for me]
https://www.deepfriedneon.com/tesla_f_calcspiral.html
https://www.toppr.com/ask/question/find-the-resistance-of-the-coil-of-length-l-number-of-turns-per-unit-length/
https://rimstar.org/science_electronics_projects/coil_design_inductance.htm
https://www.translatorscafe.com/unit-converter/ro/calculator/planar-coil-inductance/
https://sciencing.com/calculate-crosssection-area-4913182.html
[end]

%}

%
% [Start of parameters]
%
clear all;

Vin = 1.5; %V 

tempLevel = 4; % 1 for minimmum, 2 for ambient, and 3 for maximum1, 4 maxiumum2

side=0.05; %side in m
mass=0.250; %weight in kg

coilLayers = 7; % PCB multilayer levels
outerDiameter = 45; %mm 
innerDiamater = 20; %mm

trace_width = 1.8; %mm
trace_height = 0.018; % 18um  =  0.018 base unit mm
trace_spacing = 0.2; %mm

requiredTime= 180;%time to rotate the spacecraft in seconds
distancePhi = 180; %angular distance to be covered
angleFields = 90;%angle among magnetic and coils fields

T(1) = 244; %K min temp
T(2) = 298.15; %K ambient temp 25 degrees
T(3) = 319; %K max temp1
T(4) = 338.15; %K max temp2

Rsafe = 10;% extra ohms to lower the amperage

option(1) = 19.5*10^-6;% T Earth Magnetic flux density at 400km from fossasatGithub;
option(2) = 37.6316*10^-6;% T Earth magnetic field at Barcelona 400km above sea level NOOA data 37631.6*10^-9; T
localMagneticField = option(2);

spacecraftSpeed = 7.668557; %km/s satellite speed at 400km

%
% [END of parameters]
%
[N,coilLength,I,crossSectionalArea,R,totalMagneticMoment, L,totalLength, avrArea]=obtainMagneticMoment(Vin, T(tempLevel), coilLayers, outerDiameter, innerDiamater, trace_width, trace_height, trace_spacing,Rsafe);
[generatedTime, moi, genTor] = torque(totalMagneticMoment, distancePhi, angleFields, side, mass, localMagneticField);
[distanceOrb, earthDistance] = distance(generatedTime, spacecraftSpeed);

status = "";
if requiredTime > generatedTime
    status = "SUCCESFULL";
else
    status = "NOK";
end

totTurns = N*coilLayers;
y=R-Rsafe;

disp("**********************");
disp("Calculations at temperature K: "+T(tempLevel));
disp("Vin in V: "+Vin);
disp("Number of layers: "+coilLayers);
disp("Number of turns for one coil layer n: "+N);
disp("Number of turns for all layers n: "+totTurns);
disp("Coil length for one layer m: "+coilLength);
disp("Total coil length for all layers m: "+totalLength);
disp("Intensity in all coil layers A: "+I);
disp("Trace cross sectional area in m^2: "+crossSectionalArea);
disp("Average area of one coil layer m^2: "+avrArea);
disp("Trace resistance in ohms for all layers: "+y);
disp("Trace resistance in ohms for all layers with Rsafe: "+R);
disp("Coil Inductance value in uH: "+L);
disp("Magnetic moment from all "+coilLayers +" layers, Am2: "+totalMagneticMoment);
disp(" ");
disp("Required gradians to turn: "+distancePhi);
disp("Moment of Inertia in kg*m^2: "+moi);
disp("Magnetic field reference in T: "+localMagneticField);
disp("Generated torque in Nm: "+genTor);
disp("Required time in seconds: "+requiredTime);
disp("Generated time in seconds: "+generatedTime);
disp("Orbital radius to turn the spacecraft in km: "+distanceOrb);
disp("Earth radius to turn the spacecraft in km: "+earthDistance);
disp("The simulation is: "+status);
disp("**********************");
disp(" ");