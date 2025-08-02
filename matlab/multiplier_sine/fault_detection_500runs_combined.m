clc;
close all;
clear all;

%% Load fault-free data
file_path = 'D:\SIMRAN_GUPTA_INTERN\CSV\multiplier_sine\mcp_500runs.csv';
faultfree = readmatrix(file_path);

% Extract columns into cells
for n = 1:size(faultfree, 2)
    d{n} = faultfree(:, n);
end

order = 18;  % Polynomial order

% Fit polynomial for each Vout (MC run)
for n = 1:500
    y = d{n+1};
    Vin1 = d{502};
    Vin2 = d{503};
    p = polyfitn([Vin1, Vin2], y, order);
    vct{n} = p.Coefficients;
end

% Arrange coefficients into matrix
nocf = length(vct{1});
for j = 1:nocf
    for k = 1:500
        coeff(j, k) = vct{k}(j);
    end
end

% Min and max for each coefficient
cmax = max(coeff, [], 2);  % Max of each row
cmin = min(coeff, [], 2);  % Min of each row

%% Load combined fault file
combined_fault_file = 'D:\SIMRAN_GUPTA_INTERN\CSV\multiplier_sine\mcpFault_500runs.csv';
faulty_data = readmatrix(combined_fault_file);

num_fault_files = 65;
Vout_fault_start_col = 2;
Vin1_col = 502;
Vin2_col = 503;

% Initialize result containers
total_out_of_bounds = zeros(1, num_fault_files);
all_mmaaxx = cell(1, num_fault_files);
all_mmiinn = cell(1, num_fault_files);

% Extract Vin1 and Vin2 (common for all)
Vinf1 = faulty_data(:, Vin1_col);
Vinf2 = faulty_data(:, Vin2_col);

%% Loop through each fault Vout column
for fidx = 1:num_fault_files
    try
        yf = faulty_data(:, Vout_fault_start_col + fidx - 1);

        pfault = polyfitn([Vinf1, Vinf2], yf, order);
        vctfault = pfault.Coefficients;

        mmaaxx = [];
        mmiinn = [];

        for m = 1:nocf
            if vctfault(m) > cmax(m)
                mmaaxx(end+1) = m - 1;
            end
            if vctfault(m) < cmin(m)
                mmiinn(end+1) = m - 1;
            end
        end

        total_out_of_bounds(fidx) = length(mmaaxx) + length(mmiinn);
        all_mmaaxx{fidx} = mmaaxx;
        all_mmiinn{fidx} = mmiinn;

        fprintf("Fault Case %d processed. Total out-of-bound: %d\n", fidx, total_out_of_bounds(fidx));
    catch ME
        fprintf("Error processing fault case %d: %s\n", fidx, ME.message);
        total_out_of_bounds(fidx) = NaN;
    end
end
