
clc;
clear all;
close all;

format long;

% === File path and sheet setup ===
file_path = 'D:\SIMRAN_GUPTA_INTERN\CSV\buck\reduced2031_noise\noise_p28.csv';  % ⚠️ Change to your actual file path
data = readmatrix(file_path);                % Use readtable if headers are present

% === Choose the column (e.g., 1st column has time values in seconds) ===
time_col = data(:, 1);  % Assumed to be time in seconds
V1 = data(:,2);

% === Step size and max time ===
step_ns = 530;                        % in nanoseconds
step_s = step_ns * 1e-9;              % convert to seconds
max_time = max(time_col);            % maximum time in the data

% === Generate target time points ===
target_times = 0:step_s:max_time;    % all multiples of 530 ns

% === Find closest matches for each target time ===
matched_indices = zeros(length(target_times), 1);
matched_values  = zeros(length(target_times), 1);

for i = 1:length(target_times)
    [~, idx] = min(abs(time_col - target_times(i)));  % Find closest index
    matched_indices(i) = idx;
    matched_values(i)  = time_col(idx);
end

% === Display ===
disp('Target times vs Matched values:');
disp(table(target_times', matched_values, matched_indices, ...
     'VariableNames', {'TargetTime_s', 'MatchedTime_s', 'Index'}));

v = data(matched_indices,:);
plot(matched_values,v);
hold on 
plot(time_col, V1);
output_file_csv = 'D:\SIMRAN_GUPTA_INTERN\CSV\buck\reduced2031_noise\reduced2031_noise_p28.csv';
% writematrix(final_data, output_file);
writematrix(v, output_file_csv);
   

