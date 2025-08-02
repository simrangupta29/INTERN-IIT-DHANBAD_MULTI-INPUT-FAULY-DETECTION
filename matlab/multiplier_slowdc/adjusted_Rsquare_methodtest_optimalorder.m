clc;
close all;
clear all;

% Load CSV file
file_path = ['D:\SIMRAN_GUPTA_INTERN\CSV\multiplier_sine\mc_500runs.csv'];   
data = readtable(file_path);

% Display actual variable names
disp('Actual column names:');
disp(data.Properties.VariableNames);

% Get number of data points
noOfData = size(data, 1);

% Extract inputs and output
Time    = data.(data.Properties.VariableNames{1});
newy    = data.(data.Properties.VariableNames{2});         % Vout
newVin1 = data.(data.Properties.VariableNames{502});       % Vx
newVin2 = data.(data.Properties.VariableNames{503});       % Vy

% Containers
mserror = zeros(1, 20);
adjR2 = zeros(1, 20);
zg = cell(1, 20);
models = cell(1, 20);

% Loop: Fit polynomial model of order n
for n = 1:20
    model = polyfitn([newVin1, newVin2], newy, n);
    models{n} = model;
    
    % Predict output
    zg{n} = polyvaln(model, [newVin1(:), newVin2(:)]);
    
    % Compute residuals and SSE
    residuals = newy - zg{n};
    SSE = sum(residuals.^2);
    mserror(n) = SSE;
    
    % Compute Adjusted R²
    SSR = sum((zg{n} - mean(newy)).^2);
    R2 = 1 - SSE / sum((newy - mean(newy)).^2);
    df = noOfData - length(model.Coefficients);  % Adjust for model complexity
    adjR2(n) = 1 - (1 - R2) * (noOfData - 1) / df;
end

% Choose model with highest adjusted R²
[~, optimal_order] = max(adjR2);
best_model = models{optimal_order};
predicted_y = zg{optimal_order};

fprintf('Based on Adjusted R², optimal polynomial order is: %d\n', optimal_order);

%% Plot: Adjusted R²
figure;
plot(1:20, adjR2, 'o-', 'LineWidth', 1.5);
xlabel('Polynomial Order');
ylabel('Adjusted R²');
title('Adjusted R² for Polynomial Orders');
grid on;

%% Plot: Raw SSE
figure;
plot(1:20, mserror, 'o-', 'LineWidth', 1.5);
xlabel('Polynomial Order');
ylabel('Sum of Squared Residuals (SSE)');
title('Model Fitting Error');
grid on;

%% Plot: Predicted vs Actual for Optimal Model
figure;
scatter(newy, predicted_y, 20, 'filled');
xlabel('Actual Vout');
ylabel('Predicted Vout');
title(['Predicted vs Actual Output (Order = ', num2str(optimal_order), ')']);
grid on;
axis equal;
refline(1, 0);  % Ideal line
