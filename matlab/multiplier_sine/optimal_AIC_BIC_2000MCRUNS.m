clc;
close all;
clear all;

file_path = 'D:\SIMRAN_GUPTA_INTERN\CSV\multiplier_sine\reduced\red_mc_2000runs.csv';   
data = readtable(file_path);
num_vars = width(data);  % 3001
new_names = strings(1, num_vars);

% Assign known names
new_names(1) = "Index";
for i = 2:2001
    new_names(i) = "Vout_" + (i - 1);
end
new_names(2002) = "Vx";
% Columns 1003 to 3000 can be set as generic if not used
for i = 2003:6000
    new_names(i) = "Unused_" + i;
end
new_names(6001) = "Vy";

% Assign only if names match column count
if length(new_names) == num_vars
    data.Properties.VariableNames = new_names;
else
    error('Mismatch between variable names and number of columns in the table.');
end
% Extract inputs
newVin1 = data.Vx;
newVin2 = data.Vy;
noOfData = size(data, 1);


max_order = 30;

% Extract output signals
for i = 1:2000
    newy{i} = data.("Vout_" + i);
end

% Initialize array to store final optimal order for each run
final_optimal_order_per_run = zeros(1, 2000);

% Loop through each MC run
for run = 1:2000
    y = newy{run};
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

    % Get optimal order based on AIC and BIC
    [~, best_aic_order] = min(AIC);
    [~, best_bic_order] = min(BIC);

    % Take minimum of the two
    final_optimal_order_per_run(run) = min(best_aic_order, best_bic_order);
end

% Find most frequent optimal order
unique_orders = unique(final_optimal_order_per_run);
counts = histc(final_optimal_order_per_run, unique_orders);
max_count = max(counts);
most_frequent_orders = unique_orders(counts == max_count);
final_optimal_order = min(most_frequent_orders);

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
