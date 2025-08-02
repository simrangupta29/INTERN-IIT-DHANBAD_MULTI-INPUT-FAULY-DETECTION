clc;
close all;
clear all;

% File path to CSV
file_path = 'D:\SIMRAN_GUPTA_INTERN\CSV\mc_1000runs.csv';  % Add .csv extension

% Read the CSV file
faultfree = readmatrix(file_path);  % Matrix where each column is a signal

% Extract columns into cells
for n = 1:size(faultfree,2)
    d{n} = faultfree(:,n);  % Each cell contains one column
end

order = 6;  % Polynomial order

% Loop through each Vout (columns 2 to 1001)
for n = 1:(1000)
    y = d{n+1};                  % Vout_n (from column 2 onwards)
    Vin1 = d{1002};              % Vin1 at column 1002
    Vin2 = d{3001};              % Vin2 at column 3001

    % Polynomial fit
    p = polyfitn([Vin1, Vin2], y, order);

    % Store coefficients
    vct{n} = p.Coefficients;
end

% Determine number of coefficients
nocf = length(vct{1});

% Arrange coefficients in matrix form
for j = 1:nocf
    for k = 1:1000
        coeff(j,k) = vct{k}(j);
    end
end

% max & min limits of all coefficients of each Monte Carlo runs
cmax=max(coeff')  % finds max of each row
cmin=min(coeff')  % finds min of each row
%display(cmax);
%display(cmin);
faulty=readmatrix('D:\SIMRAN_GUPTA_INTERN\CSV\fault\fault_r12_small_up_7%.csv'); % output with faulty component 
yf=faulty(:,2);
Vinf1=faulty(:,3);
Vinf2=faulty(:,4);
pfault=polyfitn([Vinf1,Vinf2],yf,order);						
vctfault=pfault.Coefficients;  % coefficients of faulty polynomial
mmaaxx = [];  % Initialize as empty array
mmiinn = [];  % Initialize as empty array
m = 1;
fault = 0;    % fault flag
jj = 1;
kk = 1;
%for i = 1:nocf
  %  fdisp("Index   vctfault     cmin       cmax")
%printf("%3d   %12.6f   %12.6f   %12.6f\n", i-1, vctfault(i), cmin(i), cmax(i));
%end

while m <= nocf
    if (vctfault(m) > cmax(m)) 
        vctfault(m)
        fprintf(">cmax, faulty coef(%d)\n", m-1)
        fault = 1;
        mmaaxx(jj) = m - 1; % coefficients greater than cmax
        jj = jj + 1;
    end
    if (vctfault(m) < cmin(m))
        vctfault(m)
        fprintf("<cmin, faulty coef(%d)\n", m-1)
        fault = 1;
        mmiinn(kk) = m - 1; % coefficients less than cmin
        kk = kk + 1;
    end
    m = m + 1;
    if (m == nocf + 1 && fault == 0)
        fprintf("not faulty\n")
    end
end

% Safe to compute total out-of-bounds now
total_out_of_bounds = length(mmaaxx) + length(mmiinn);
fprintf("\nTotal coefficients out of bound: %d\n", total_out_of_bounds);
