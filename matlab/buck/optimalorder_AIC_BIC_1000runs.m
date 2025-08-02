clc;
close all;
clear all;

% Load data
file_path = 'D:\SIMRAN_GUPTA_INTERN\CSV\buck\reduced2031_mcp_1000runs.csv';   
data = readtable(file_path);

% Rename columns
new_names = strings(1, width(data));
for i = 2:1001
    new_names(i) = "Vout_" + (i - 1);
end
new_names(1002) = "Vx";
new_names(1003) = "Vy";
new_names(1) = "Index";
data.Properties.VariableNames = new_names;

% Input vectors
newVin1 = data.Vx;
newVin2 = data.Vy;
noOfData = size(data, 1);
max_order = 30;

% Extract output signals
for i = 1:1000
    newy{i} = data.("Vout_" + i);
end

% Initialize array to store final optimal order for each run
final_optimal_order_per_run = zeros(1, 1000);

% Loop through each MC run
for run = 1:1000
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

% Display result
fprintf('Most frequent optimal order (based on min(AIC,BIC)): %d\n', final_optimal_order);

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