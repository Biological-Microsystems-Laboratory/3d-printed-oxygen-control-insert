clear
filename = 'results.txt';
delimiterIn = '\t';
headerlinesIn = 1;
A = importdata(filename,delimiterIn,headerlinesIn);
intensities = A.data(:, 3);
M = size(intensities,1)/24;
wells = reshape(intensities,M,24);
%csvwrite('wells.csv',wells)
number_of_calibration_points = 5;
exposures_per_calibration = 5;
calibration_exposures = wells(1:[number_of_calibration_points*exposures_per_calibration],:);
calibration = zeros(number_of_calibration_points,24);
start = 1;
last = exposures_per_calibration;

for n = 1:number_of_calibration_points
   m = calibration_exposures(start:last,:);
   calibration(n,:) = mean(m);
   start = last+1;
   last = last+exposures_per_calibration;
end

csvwrite('calibration-intensities.csv',calibration)
exp = wells(number_of_calibration_points*exposures_per_calibration+1:length(wells),:);
csvwrite('characterization-intensities.csv',exp)
%%% Stern-Volmer
calibration_tanks = [0, 1, 7.5, 15, 21];
I1 = calibration(1,:);
I2 = calibration(number_of_calibration_points,:);
X1 = calibration_tanks(1);
X2 = calibration_tanks(number_of_calibration_points);
kt = (I2-I1)./((X1*I1)-(X2*I2)); % calculation for Ktau
Io = I1;
x1 = [0:1:25]'; % makes x values for plot of stern-volmer
%stern_volmer_plot = x1*kt+1; % plots I0/I Vs oxygen
%intensity_plot = I0./(1+kt*x1); % plots intensity(I) Vs oxygen

for i = 1:24
    oxygen_percent(:,i) = ((Io(i)./exp(:,i))-1)/kt(i);
end

%%% Two-Site Stern-Volmer fitting
Q = calibration_tanks';
for i = 1:24
    I = calibration(:,i);
    I0 = I1(i);
    % (f1/(1+ksv1*Q))+(1-f1/(1+ksv2*Q))== I/I0 ; f1+f2=1, f1=1-f2 f2=1-f1
    g = fittype('I0*((f1/(1+ksv1*Q))+((1-f1)/(1+ksv2*Q)))',...
            'independent',{'Q'},'dependent','I','problem','I0');
    myfit = fit(Q,I,g,'problem',I0,'lower',[0 0 0],'upper',[1 inf inf],'Start',[0, 0, 0]);
    coeff_twosite(:,i) = coeffvalues(myfit)';
    %hold on
    %plot(myfit,Q,I)
end

for i = 1:24
    coeff=coeff_twosite(:,i);
    f1 = coeff(1);
    f2 = 1-f1;
    ksv1 = coeff(2);
    ksv2 = coeff(3);
    I0 = I1(i);
    I = exp(:,i);
    a =(I0^2*f1^2*ksv2^2 + 2*I0^2*f1*f2*ksv1*ksv2 + I0^2*f2^2*ksv1^2 + 2*I0*I*f1*ksv1*ksv2 - 2*I0*I*f1*ksv2^2 - 2*I0*I*f2*ksv1^2 + 2*I0*I*f2*ksv1*ksv2 + I.^2*ksv1^2 - 2*I.^2*ksv1*ksv2 + I.^2*ksv2^2);
    b = -I*ksv2 - I*ksv1 + I0*f1*ksv2 + I0*f2*ksv1;
    c = (2*I*ksv1*ksv2);
    oxygen_percent_twosite(:,i) = ((a.^(1/2))+b)./c;
end
%figure
plot(oxygen_percent_twosite,'b-')
hold on
plot(oxygen_percent,'r--')
csvwrite('analyzed-oxygen-values-150812.csv',oxygen_percent_twosite)