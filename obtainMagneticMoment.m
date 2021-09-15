%{
Attribution-NonCommercial-ShareAlike 3.0 Unported (CC BY-NC-SA 3.0)

This function calculates the magnetic moment

%}
function [N,coilLength,I,crossSectionalArea,R,totalMagneticMoment, L, totalLength, avrArea] = obtainMagneticMoment(Vin, tempLevel, coilLayers, outerDiameter, innerDiamater, trace_width, trace_height, trace_spacing,Rsafe)
%
% [Start of parameters]
%
r_permitivity = 4; %inner substrates material FR4 -> from manufacturer
r_permeability = 1; % relative

permeability_constant = 4*pi*10^-7; %magnetic constant, permeability H/m

res_0 = 1.68*10^-8; % ohms*m reference cooper resistivity at reference temperature, MANUFACTURER value
T_0 = 293; %293K reference temperature at 20C
alpha = 0.00404; % temperature coefficient for cooper

%Constants weights for a square coil
K_1= 2.34;
K_2= 2.75;

%
% [END of parameters]
%

left_space_length_a = outerDiameter;
left_space_length_b = outerDiameter;
left_space_length_c = outerDiameter;
left_space_length_d = outerDiameter;

%{
Coils outer square, for VISUAL GUIDANCE
   ___a___
  |       |
 d|       |b
  |       |
  ----c----
%}

N = 1; %init variable number of turns
coilLength = 0; %mm init variable
areaOfEachTurn = 0;%zeros(1, 20); %vector, init variable
D = 0 ; %magnetic moment, init vartiable

%
% The square spiral of each trace follows a mathematical pattern of odds and pairs
% 
oddNumb = 1:2:200; %odd numbers till 200 (just to init the array, because 200 is a very big number...)
zeroIdx = zeros(1, 1);
mulOdd=[zeroIdx , oddNumb]; %first value is zero, then are the odds

evenNumb = 2:2:200; %even numbers till 200 
mulEven=[zeroIdx , evenNumb]; %first value is zero, then are the even

%Now we calculate the number of turns per coil and the coil length
while left_space_length_d >= innerDiamater
    
    left_space_length_a = outerDiameter - mulOdd(N)*(trace_width + trace_spacing);
    left_space_length_b = outerDiameter - mulEven(N)*(trace_width + trace_spacing);
    left_space_length_c = outerDiameter - mulEven(N)*(trace_width + trace_spacing);
    left_space_length_d = outerDiameter - mulOdd(N+1)*(trace_width + trace_spacing);
    
    if left_space_length_d >= innerDiamater
        areaOfEachTurn(N) = left_space_length_b*left_space_length_c;          
        coilLength = coilLength + left_space_length_a+left_space_length_b+left_space_length_c+left_space_length_d-(trace_width)*4;
        N = N+1;
    end
    
end

%clean data
N = N -1; %deleate the last N
coilLength = coilLength - trace_width; %deleate initial width from the first loop from the trace a

%calculate I
crossSectionalArea = (trace_width*trace_height)*10^-6; %pass it to m^2
coilLength = coilLength*10^-3; %pass to m
%linear aproximation for the resistivity, is an APROXIMATION 
resistivity = res_0*(1+alpha*(tempLevel-T_0)); % ohms*m
R=resistivity*(coilLength/crossSectionalArea); % Resistance for one coil layer
R=coilLayers*R;% R in series, global R for all coil layers
R=R+Rsafe; % Resistance on safety added in series
I = (Vin) / (R); %Intensity in A in all layers

%obtain average area
avrArea = 0;

%calculate magnetic moment from one plaque
for i = 1:N
    area_m = areaOfEachTurn(i)*10^-6;% area is mm^2, we pass it to m^2
    D = D + 1*(area_m)*I;
    avrArea = avrArea + area_m;
end

avrArea = avrArea/N;

%obtain total magnetic moment from all layers
totalMagneticMoment = D*coilLayers;

totalLength = coilLength*coilLayers;

%calculate L coil value for one pocketcube side, the formula requires the
%lenths in um
outerDiameter= outerDiameter*10^3; %value from mm to um
innerDiamater= innerDiamater*10^3; %value from mm to um
Davg = (outerDiameter+innerDiamater)/2; %Average diameter in um
fillFactor= (outerDiameter-innerDiamater)/(outerDiameter+innerDiamater);
L=K_1*permeability_constant*((N^2)*Davg)/(1+K_2*fillFactor);

end