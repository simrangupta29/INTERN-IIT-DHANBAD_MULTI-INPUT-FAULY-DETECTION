clc;
close all;
clear all;

% Load CSV file
file_path = 'D:\SIMRAN_GUPTA_INTERN\CSV\Lead_lag\mc_2000runs.csv';   
data = readtable(file_path);

% Display actual variable names to avoid mismatch
disp('Actual column names:');
disp(data.Properties.VariableNames);

% Extract number of rows
noOfData = size(data, 1);

% Extract correct columns using actual variable names
% (Replace with actual names printed above if different)
Time = data.(data.Properties.VariableNames{1});
newy = data.(data.Properties.VariableNames{2});     % Vout
newVin1 = data.(data.Properties.VariableNames{2002});  % Vx
newVin2 = data.(data.Properties.VariableNames{2003});  % Vy

% Initialize containers
mserror = zeros(1,10);
c1 = cell(1,10);
zg = cell(1,10);
residuals = cell(1,10);
optimal_order = zeros(1,10);

% Loop over polynomial orders from 1 to 20
for n = 1:10
    % Fit polynomial model of order n
    p = polyfitn([newVin1, newVin2], newy, n);
    c1{n} = p.Coefficients;
    
    % Predict Vout for all data using the model
    zg{n} = polyvaln(p, [newVin1(:), newVin2(:)]);
    
    % Compute residuals
    residuals{n} = newy - zg{n};
    
    % Sum of squared residuals
    mserror(n) = sum(residuals{n}.^2);
end

% Compute optimal order using Sr/(n-m-1)
for k = 1:10
    optimal_order(k) = mserror(k) / (noOfData - k - 1);
end

% Plot: Optimal Order Criteria
figure;
plot(1:10, optimal_order, 'o-', 'LineWidth', 1.5);  
xlabel('Polynomial Order');
ylabel('Sr / (n - m - 1)');
title('Optimal Polynomial Order');
grid on;

% Plot: Raw Error (Sum of Squared Residuals)
figure;
plot(1:10, mserror, 'o-', 'LineWidth', 1.5);  
xlabel('Polynomial Order');
ylabel('Sum of Squared Residuals (Sr)');
title('Model Fitting Error');
grid on;
