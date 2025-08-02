clc;
close all;
clear all;

file_path = 'D:\SIMRAN_GUPTA_INTERN\CSV\multiplier_sine\mc_1000runs.csv';   
data = readtable(file_path);
num_vars = width(data);  % 3001
new_names = strings(1, num_vars);

% Assign known names
new_names(1) = "Index";
for i = 2:1001
    new_names(i) = "Vout_" + (i - 1);
end
new_names(1002) = "Vx";
% Columns 1003 to 3000 can be set as generic if not used
for i = 1003:3000
    new_names(i) = "Unused_" + i;
end
new_names(3001) = "Vy";

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



% Extract all MC run outputs
for i = 1:1000
    newy{i} = data.("Vout_" + i);
end

% Fit models of order 1 to 10 for each MC run
max_order = 10;
for run = 1:1000
    y = newy{run};

    for n = 1:max_order
        p = polyfitn([newVin1, newVin2], y, n);
        c1{run, n} = p.Coefficients;

        zg{run, n} = polyvaln(p, [newVin1(:), newVin2(:)]);
        residuals{run, n} = y - zg{run, n};
        mserror(run, n) = sum(residuals{run, n}.^2);  % Sr
    end
end
% Adjusted MSE for each MC run and each order
for run = 1:1000
    for k = 1:10
        optimal_order_criterion(run, k) = mserror(run, k) / (noOfData - k - 1);
    end
end
% Define threshold
threshold = 1e-5;

% Initialize cell array to store optimal order for each run
optimal_orders = cell(1, 1000);

for run = 1:1000
    values = optimal_order_criterion(run, :);
    
    % Find the last index where value is greater than threshold
    above_threshold_indices = find(values > threshold);
    
    if isempty(above_threshold_indices)
        order_found = 0;  % If none are above threshold
    else
        order_found = above_threshold_indices(end);  % Last such index
    
    end
    optimal_orders{1, run} = order_found;
end

% Convert cell array to numeric vector
optimal_order_vector = cell2mat(optimal_orders);

% Count the frequency of each unique value
unique_orders = unique(optimal_order_vector);
counts = histc(optimal_order_vector, unique_orders);

% Find the maximum frequency
max_count = max(counts);

% Find all orders that have this maximum frequency
most_frequent_orders = unique_orders(counts == max_count);

% Choose the smallest one among them
final_optimal_order = min(most_frequent_orders)+1;

% Display result
fprintf('Most frequent optimal order (with tie-breaking): %d\n', final_optimal_order);

