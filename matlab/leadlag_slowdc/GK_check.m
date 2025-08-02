clc;
clear all;
file_path1 = 'D:\SIMRAN_GUPTA_INTERN\CSV\leadlag_slowdc\lowcheckfault\nominal_check.csv';  
file_path2 = 'D:\SIMRAN_GUPTA_INTERN\CSV\leadlag_slowdc\mc_500check.csv';  
faultfree = readmatrix(file_path1);
faultmonte = readmatrix(file_path2);
   ymonte = faultmonte(:,2);
    Vinmonte1 = faultmonte(:,502);
    Vinmonte2 = faultmonte(:,503);
order=3;
    pmonte = polyfitn([Vinmonte1, Vinmonte2], ymonte, order);
    monte = pmonte.Coefficients;

% 
%    yff = faultfree(:,2);
%     Vin1ff = faultfree(:,3);
%     Vin2ff = faultfree(:,4);
% order=3;
%     pff = polyfitn([Vin1ff, Vin2ff],  yff , order);
%     ff = pff.Coefficients;
    % plot(faultfree(:,1),faultfree(:,2));
