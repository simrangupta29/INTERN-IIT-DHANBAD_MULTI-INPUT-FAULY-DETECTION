clc;
close all;
clear all;

% Load fault-free data
file_path = 'D:\SIMRAN_GUPTA_INTERN\CSV\Leadlag_slowdc\mc_500runs.csv';  
faultfree = readmatrix(file_path);

% Extract columns into cells
for n = 1:size(faultfree,2)
    d{n} = faultfree(:,n);
end

order = 14;  % Polynomial order

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
        coeff(j,k) = vct{k}(j);
    end
end

% Min and max for each coefficient
cmax = max(coeff, [], 2);  % Max of each row
cmin = min(coeff, [], 2);  % Min of each row

%% List of fault file names
num_fault_files = 10;
fault_files = strings(1, num_fault_files);
for i = 1:num_fault_files
    fault_files(i) = sprintf('D://SIMRAN_GUPTA_INTERN//CSV//Leadlag_slowdc//lowcheckfault//lowcheck_var%d.csv', i);
end

%% Initialize result containers
total_out_of_bounds = zeros(1, num_fault_files);
all_mmaaxx = cell(1, num_fault_files);
all_mmiinn = cell(1, num_fault_files);
all_vctfault = cell(1, num_fault_files);

%% Loop through each fault file
for fidx = 1:num_fault_files
    faulty = readmatrix(fault_files(fidx));
    yf = faulty(:,2);
    Vinf1 = faulty(:,3);
    Vinf2 = faulty(:,4);

    pfault = polyfitn([Vinf1, Vinf2], yf, order);
    vctfault = pfault.Coefficients;
    all_vctfault{fidx} = vctfault;  % store immediately in each iteration

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

    all_mmaaxx{fidx} = mmaaxx;
    all_mmiinn{fidx} = mmiinn;
    total_out_of_bounds(fidx) = length(mmaaxx) + length(mmiinn);
end

