clc;
close all;
clear all;

% Load data
file_path = 'D:\SIMRAN_GUPTA_INTERN\CSV\Lead_lag\monotonic_coefficients\nominal_optimal.csv';   
data = readtable(file_path);

% Rename columns
new_names = strings(1, width(data));
new_names(2) = "Vout";
new_names(3) = "Vx";
new_names(4) = "Vy";
new_names(1) = "Index";
data.Properties.VariableNames = new_names;

% Input vectors
newVin1 = data.Vx;
newVin2 = data.Vy;
noOfData = size(data, 1);
max_order = 30;

% Extract output signal (for single MC run)
y = data.Vout;  % Use directly if it's one signal vector

% Initialize AIC and BIC arrays
AIC = zeros(1, max_order);
BIC = zeros(1, max_order);

% Fit models of increasing order
for n = 1:max_order
    model = polyfitn([newVin1, newVin2], y, n);
    predicted = polyvaln(model, [newVin1(:), newVin2(:)]);
    residuals = y - predicted;
    SSE = sum(residuals.^2);
    k = length(model.Coefficients);

    % Compute AIC and BIC
    AIC(n) = 2 * k + noOfData * log(SSE / noOfData);
    BIC(n) = k * log(noOfData) + noOfData * log(SSE / noOfData);
end

% Determine optimal order
[~, best_aic_order] = min(AIC);
[~, best_bic_order] = min(BIC);
final_optimal_order = min(best_aic_order, best_bic_order);

% Display result
fprintf('Optimal order for single MC run (based on min(AIC,BIC)): %d\n', final_optimal_order);
% Plot AIC and BIC vs Model Order
figure;
plot(1:max_order, AIC, '-o', 'LineWidth', 2, 'DisplayName', 'AIC');
hold on;
plot(1:max_order, BIC, '-s', 'LineWidth', 2, 'DisplayName', 'BIC');
xline(final_optimal_order, '--r', 'LineWidth', 2, ...
    'DisplayName', sprintf('Optimal Order = %d', final_optimal_order));
xlabel('Model Order');
ylabel('Criterion Value');
title('Model Order Selection using AIC and BIC');
legend('Location', 'best');
grid on;