clc
clear all
close all

% Parameters
folder_path = 'D:\SIMRAN_GUPTA_INTERN\CSV\Lead_lag\monotonic_coefficients\';  % folder containing the CSV files
num_components = 10;                         % R1 to R10
order = 4;                                   % Polynomial order

% For storing results
monotonicity_result = {};     % stores monotonicity labels
coeff_all = {};               % stores coefficient matrices

for comp = 1:num_components
    % Load data
    filename = sprintf('sinewave_para_var%d.csv', comp);
    file_path = fullfile(folder_path, filename);
    fprintf('\nProcessing %s...\n', filename);
   
    data = xlsread(file_path);
    [~, num_cols] = size(data);

    % Extract signals into cell array
    for n = 1:num_cols
        d{n} = data(:, n);
    end

    % Assume last 2 columns are Vin1 and Vin2 (adjust if needed)
    Vin1 = d{13};
    Vin2 = d{14};

    % For storing polynomial coefficients for each run
    num_runs = num_cols - 3;
    for n = 1:num_runs
        y = d{n + 1};  % output signal (e.g., Vout)
        p = polyfitn([Vin1, Vin2], y, order);
        vct{n} = p.Coefficients;
    end

    % Create coefficient matrix: rows = coefficients, cols = runs
    nocf = size(vct{1}, 2);  % number of coefficients
    coeff = zeros(nocf, num_runs);
    for j = 1:nocf
        for k = 1:num_runs
            coeff(j, k) = vct{k}(j);
        end
    end

    % Check monotonicity (Increasing only) for each coefficient
    for i = 1:nocf
        coeff_series = coeff(i, :);
        if all(diff(coeff_series) >= 0)
            monotonicity_result{comp, i} = 'Monotonic Increasing';
        elseif all(diff(coeff_series) <= 0)
            monotonicity_result{comp, i} = 'Monotonic Decreasing';
        else
            monotonicity_result{comp, i} = 'Non-monotonic';
        end
    end

    coeff_all{comp} = coeff;  % optional: store all coefficient matrices
    clear d vct coeff
end

% Display summary for each component
fprintf('\nMonotonicity Summary:\n');
for comp = 1:num_components
    fprintf('Component R%d:\n', comp);
    for i = 1:size(monotonicity_result, 2)
        if ~isempty(monotonicity_result{comp, i})
            fprintf('\tCoefficient C%d: %s\n', i-1, monotonicity_result{comp, i});
        end
    end
end
% ===================================================
% ✅ Identify coefficients that are MONOTONIC (Increasing or Decreasing) across ALL components
% ===================================================
num_coeffs = size(monotonicity_result, 2);
is_monotonic_either = true(1, num_coeffs);

for j = 1:num_coeffs
    for i = 1:num_components
        status = monotonicity_result{i, j};
        if ~strcmp(status, 'Monotonic Increasing') && ~strcmp(status, 'Monotonic Decreasing')
            is_monotonic_either(j) = false;
            break;
        end
    end
end

% Final list of coefficients monotonic in any direction
monotonic_all = find(is_monotonic_either) - 1;

fprintf('\nPolynomial Coefficients Monotonic (Increasing or Decreasing) for ALL Components:\n');
if isempty(monotonic_all)
    fprintf('None of the coefficients are monotonic across all components.\n');
else
    fprintf('C%d ', monotonic_all);
    fprintf('\n');
end


