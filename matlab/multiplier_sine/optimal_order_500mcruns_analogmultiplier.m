clc;
close all;
clear all;

file_path = ['D:\SIMRAN_GUPTA_INTERN\CSV\mc_500runs.csv'];   
data = readtable(file_path);

new_names = strings(1, width(data));
for i = 2:501
    new_names(i) = "Vout_" + (i - 1);
end
new_names(502) = "Vx";
new_names(503) = "Vy";
new_names(1) = "Index";
data.Properties.VariableNames = new_names;

newVin1 = data.Vx;
newVin2 = data.Vy;
noOfData = size(data, 1);

for i = 1:500
    newy{i} = data.("Vout_" + i);
end

max_order = 10;
for run = 1:500
    y = newy{run};
    for n = 1:max_order
        p = polyfitn([newVin1, newVin2], y, n);
        c1{run, n} = p.Coefficients;
        zg{run, n} = polyvaln(p, [newVin1(:), newVin2(:)]);
        residuals{run, n} = y - zg{run, n};
        mserror(run, n) = sum(residuals{run, n}.^2);
    end
end

for run = 1:500
    for k = 1:10
        optimal_order_criterion(run, k) = mserror(run, k) / (noOfData - k - 1);
    end
end

threshold = 1e-5;
optimal_orders = cell(1, 500);

for run = 1:500
    values = optimal_order_criterion(run, :);
    above_threshold_indices = find(values > threshold);
    if isempty(above_threshold_indices)
        order_found = 0;
    else
        order_found = above_threshold_indices(end);
    end
    optimal_orders{1, run} = order_found;
end

optimal_order_vector = cell2mat(optimal_orders);
unique_orders = unique(optimal_order_vector);
counts = histc(optimal_order_vector, unique_orders);
max_count = max(counts);
most_frequent_orders = unique_orders(counts == max_count);
final_optimal_order = min(most_frequent_orders) + 1;

fprintf('Most frequent optimal order (500 runs): %d\n', final_optimal_order);
