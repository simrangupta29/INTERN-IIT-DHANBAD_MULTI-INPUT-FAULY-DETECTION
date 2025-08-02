clc;
clear all;
close all;

% Load the original CSV file
file_path = 'D:\SIMRAN_GUPTA_INTERN\CSV\multiplier_sine\mcp_1000runs.csv'; 
data = readmatrix(file_path);

% Display number of columns
% [~, total_columns] = size(data);
% fprintf('Total number of columns in the file: %d\n', total_columns);
% % Display number of rows
% [total_rows, ~] = size(data);
% fprintf('Total number of rows in the file: %d\n', total_rows);

% Extract:
time_col = data(:, 1);             % Column 1: Time
vout_cols = data(:, 2:1001);        % Columns 2–1001: Vout
selected_input1 = data(:, 1002);    % Fixed input from column 1002
selected_input2 = data(:, 3001);   % Fixed input from column 3001

% Combine everything
final_data = [time_col, vout_cols, selected_input1, selected_input2];

% Save to new Excel file
% output_file = 'D:\SIMRAN_GUPTA_INTERN\CSV\buck\new_data_1000_xlsx.xlsx';
output_file_csv = 'D:\SIMRAN_GUPTA_INTERN\CSV\multiplier_sine\reduced_mcp_1000runs.csv';
% writematrix(final_data, output_file);
writematrix(final_data, output_file_csv);


%% read the large file

