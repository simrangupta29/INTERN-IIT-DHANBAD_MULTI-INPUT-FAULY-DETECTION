clc;
close all;
file_path = 'D:\SIMRAN_GUPTA_INTERN\CSV\multiplier_sine\mc_500runs.csv';
v = readmatrix(file_path);
time = v(:,1); Vout= v(:,2); VR1=v(:,502); VR2=v(:,503);
plot(time,Vout,'red');
p= polyfitn([VR1,VR2],Vout,18);
% value = zeros(99,1);
% for index = 1 : 99
%     X1 = time(index);
%     X2 = VR1(index);
%     X3 = VR2(index);
%  value(index) = 1593486932252.512*X1^6 - 30272403933.2702*X1^5*X2 - 130065368208.4194*X1^5*X3 - 488347054025.1102*X1^5 - 9958153346.2178*X1^4*X2^2 - 10538759242.9842*X1^4*X2*X3 + 10131539696.6299*X1^4*X2 - 12161259203.8758*X1^4*X3^2 + 33788830397.7731*X1^4*X3 + 55066843526.5972*X1^4 + 584539772.9254*X1^3*X2^3 - 2954898369.894*X1^3*X2^2*X3 + 2392484412.6651*X1^3*X2^2 + 991660995.9604*X1^3*X2*X3^2 + 2215357682.222*X1^3*X2*X3 - 1200822617.1381*X1^3*X2 + 176952899.2682*X1^3*X3^3 + 2638265718.1091*X1^3*X3^2 - 3476997179.7242*X1^3*X3 - 2777758241.9703*X1^3 - 2130445.6335*X1^2*X2^4 - 28969465.5811*X1^2*X2^3*X3 - 87172183.4953*X1^2*X2^3 + 145485695.094*X1^2*X2^2*X3^2 + 429342232.3361*X1^2*X2^2*X3 - 184565817.4334*X1^2*X2^2 - 92586.183*X1^2*X2*X3^3 - 159868318.4666*X1^2*X2*X3^2 - 141744528.9129*X1^2*X2*X3 + 59583810.0746*X1^2*X2 + 31126895.7967*X1^2*X3^4 - 34831334.1232*X1^2*X3^3 - 166190975.3669*X1^2*X3^2 + 176740492.1163*X1^2*X3 + 59903828.7853*X1^2 + 2273514.7134*X1*X2^5 - 616585.2033*X1*X2^4*X3 + 4673.8603*X1*X2^4 - 1117259.1376*X1*X2^3*X3^2 + 2926323.6212*X1*X2^3*X3 + 2760620.8771*X1*X2^3 + 3729737.8824*X1*X2^2*X3^3 - 14764434.6891*X1*X2^2*X3^2 - 11360495.7907*X1*X2^2*X3 + 4505541.733*X1*X2^2 + 464727.7989*X1*X2*X3^4 - 311167.3657*X1*X2*X3^3 + 8486347.5624*X1*X2*X3^2 + 2056468.5455*X1*X2*X3 - 1054618.8654*X1*X2 + 855586.3327*X1*X3^5 - 3276365.5474*X1*X3^4 + 4570411.408*X1*X3^3 + 2281675.1577*X1*X3^2 - 3826460.3484*X1*X3 - 379930.157*X1 + 89875.3993*X2^6 + 98145.01*X2^5*X3 - 95668.6404*X2^5 - 12274.0737*X2^4*X3^2 + 17855.7012*X2^4*X3 - 2184.3164*X2^4 - 30843.9709*X2^3*X3^3 + 57042.7642*X2^3*X3^2 - 135872.2047*X2^3*X3 + 6093.1744*X2^3 + 73371.9818*X2^2*X3^4 - 187462.4398*X2^2*X3^3 + 707921.6313*X2^2*X3^2 - 175272.7524*X2^2*X3 - 490.5398*X2^2 + 11085.759*X2*X3^5 - 30196.4555*X2*X3^4 - 32997.3201*X2*X3^3 - 169067.2607*X2*X3^2 + 41153.8875*X2*X3 + 12.8954*X2 + 13727.2181*X3^6 - 45422.2333*X3^5 + 125148.0329*X3^4 - 185556.1882*X3^3 + 58538.6178*X3^2 + 15065.2979*X3 - 0.0015589 ;
% end
Vout_fit = polyvaln(p,[VR1,VR2]);
 plot(time, Vout_fit,'b');
hold on;
 % plot(time,Vout,time,VR1,time,VR2,'LineWidth',2);
 % legend("Output Voltage","Inverting input","Non-Inverting Input",'Linewidth',2);
  plot(time,Vout,time,Vout_fit,'LineWidth',2);
  legend("Simulated Output Voltage","Estimated Output Voltage",'Linewidth',2);
  xlabel('Time(ms)');
  ylabel('Voltage');
  grid;
  % Create a new figure with subplots
figure;

% First subplot: Simulated Output Voltage (Vout)
subplot(2,1,1);
plot(time, Vout, 'r', 'LineWidth', 2);
title('Simulated Output Voltage 2000');
xlabel('Time (ms)');
ylabel('Voltage (V)');
grid on;

% Second subplot: Estimated Output Voltage (Vout\_fit)
subplot(2,1,2);
plot(time, Vout_fit, 'b', 'LineWidth', 2);
title('Estimated Output Voltage from Polynomial Fit 2000');
xlabel('Time (ms)');
ylabel('Voltage (V)');
grid on;
