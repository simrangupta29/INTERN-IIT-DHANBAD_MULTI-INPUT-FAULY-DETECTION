clc;
close all;
clear all;

% Load CSV file
file_path = 'D:\SIMRAN_GUPTA_INTERN\CSV\multiplier_ramp\mc_500runs.csv';   
data = readtable(file_path);

% Display actual variable names
disp('Actual column names:');
disp(data.Properties.VariableNames);

% Get number of rows
noOfData = size(data, 1);

% Extract relevant columns (adjust column indices if needed)
Time = data.(data.Properties.VariableNames{1});
newy = data.(data.Properties.VariableNames{2});         % Vout
newVin1 = data.(data.Properties.VariableNames{502});    % Vx
newVin2 = data.(data.Properties.VariableNames{503});    % Vy

% Initialize containers
mserror = zeros(1, 20);
c1 = cell(1, 20);
zg = cell(1, 20);
residuals = cell(1, 20);

% Loop over polynomial orders from 1 to 20
for n = 1:20
    p = polyfitn([newVin1, newVin2], newy, n);
    c1{n} = p.Coefficients;
    zg{n} = polyvaln(p, [newVin1(:), newVin2(:)]);
    residuals{n} = newy - zg{n};
    mserror(n) = sum(residuals{n}.^2);
end

% Perform F-test for each consecutive order
f_values = zeros(1, 19);
p_values = zeros(1, 19);

for n = 1:19
    SSE1 = mserror(n);
    SSE2 = mserror(n + 1);
    df1 = noOfData - n - 1;
    df2 = noOfData - (n + 1) - 1;
    f_num = (SSE1 - SSE2) / (df1 - df2);
    f_den = SSE2 / df2;
    F = f_num / f_den;
    f_values(n) = F;
    p_values(n) = 1 - fcdf(F, df1 - df2, df2);
end

% Determine optimal order (simplest sufficient model)
i = find(p_values > 0.05, 1, 'first');
if isempty(i)
    optimal_order = 20;  % All improvements significant
else
    optimal_order = i;   % Simpler model is sufficient
end

fprintf('Based on F-test, optimal order (no overfitting) is: %d\n', optimal_order);

%% Plot: p-values
figure;
plot(2:20, p_values, 'o-', 'LineWidth', 1.5);
yline(0.05, 'r--', 'LineWidth', 1);
xlabel('Polynomial Order');
ylabel('p-value');
title('F-test for Polynomial Order Selection');
legend('p-value', 'Significance Threshold (0.05)');
grid on;

%% Plot: Raw SSE
figure;
plot(1:20, mserror, 'o-', 'LineWidth', 1.5);
xlabel('Polynomial Order');
ylabel('Sum of Squared Residuals (Sr)');
title('Model Fitting Error (Raw SSE)');
grid on;

%% Plot: Normalized SSE
Sr_normalized = zeros(1, 20);
for n = 1:20
    Sr_normalized(n) = mserror(n) / (noOfData - n - 1);
end

figure;
plot(1:20, Sr_normalized, 'o-', 'LineWidth', 1.5);
xlabel('Polynomial Order');
ylabel('Normalized SSE (Sr / (n - m - 1))');
title('Normalized Model Error');
grid on;

%% Plot: Predicted vs Actual for Optimal Model
best_model = polyfitn([newVin1, newVin2], newy, optimal_order);
predicted_y = polyvaln(best_model, [newVin1, newVin2]);

figure;
scatter(newy, predicted_y, 20, 'filled');
xlabel('Actual Vout');
ylabel('Predicted Vout');
title(['Predicted vs. Actual Output (Polynomial Order = ', num2str(optimal_order), ')']);
grid on;
axis equal;
refline(1, 0); % Reference line y = x
