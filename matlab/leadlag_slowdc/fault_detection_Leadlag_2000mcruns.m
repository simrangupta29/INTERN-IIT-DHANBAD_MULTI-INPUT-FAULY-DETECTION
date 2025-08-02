clc;
close all;
clear all;

% Load fault-free data
file_path = 'D:\SIMRAN_GUPTA_INTERN\CSV\Leadlag_slowdc\mc_2000runs.csv';
faultfree = readmatrix(file_path);

% Extract columns into cells
for n = 1:size(faultfree,2)
    d{n} = faultfree(:,n);
end

order = 14;  % Polynomial order

% Fit polynomial for each Vout (MC run)
for n = 1:2000
    y = d{n+1};
    Vin1 = d{2002};
    Vin2 = d{2003};
    p = polyfitn([Vin1, Vin2], y, order);
    vct{n} = p.Coefficients;
end

% Arrange coefficients into matrix
nocf = length(vct{1});
for j = 1:nocf
    for k = 1:2000
        coeff(j,k) = vct{k}(j);
    end
end

% Min and max for each coefficient
[cmax, idx_max] = max(coeff, [], 2);
[cmin, idx_min] = min(coeff, [], 2);

% Store runs corresponding to cmax and cmin
run_max = idx_max;  % Each row j has index of run giving cmax
run_min = idx_min;  % Each row j has index of run giving cmin
%% List of fault file names
num_fault_files = 20;
fault_files = strings(1, num_fault_files);
for i = 1:num_fault_files
    fault_files(i) = sprintf('D:\\SIMRAN_GUPTA_INTERN\\CSV\\Leadlag_slowdc\\fault\\rampfault_para%d.csv', i);  % adjust naming scheme as per your files
end

%% Initialize result containers
total_out_of_bounds = zeros(1, num_fault_files);  % total count for each file
all_mmaaxx = cell(1, num_fault_files);            % indices greater than cmax
all_mmiinn = cell(1, num_fault_files);            % indices less than cmin

%% Loop through each fault file
for fidx = 1:num_fault_files
    try
        faulty = readmatrix(fault_files(fidx));
        yf = faulty(:,2);
        Vinf1 = faulty(:,3);
        Vinf2 = faulty(:,4);
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

        % Store the result
        total_out_of_bounds(fidx) = length(mmaaxx) + length(mmiinn);
        all_mmaaxx{fidx} = mmaaxx;
        all_mmiinn{fidx} = mmiinn;

        fprintf("File %d processed. Total out-of-bound: %d\n", fidx, total_out_of_bounds(fidx));
    catch ME
        fprintf("Error reading file %s: %s\n", fault_files(fidx), ME.message);
        total_out_of_bounds(fidx) = NaN;
    end
end
