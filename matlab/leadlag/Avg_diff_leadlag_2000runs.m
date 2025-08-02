clc;
close all;
clear all;
file_path = 'D:\SIMRAN_GUPTA_INTERN\CSV\Leadlag_sine\mc_2000runs.csv';  % faultfree MonteCarlo data
faultfree=readmatrix(file_path);  %read excel file faultfree is object
		
for n = 1:size(faultfree,2)			         %size(,2) give number of column in excel if 1 give crow
        d{n}=faultfree(:,n);					% d is cell and each cell contain one column
end
noOfData=size(faultfree,1);
NMC=size(faultfree,2)-3;
% vpp=9.07834;

order=18;
Vin1=d{2002};   % first input
Vin2=d{2003};   % second input
for n = 1:2000		%except 1st row 1st row is time
	y=d{n+1};                           % output of each run
    % Vin1=d{2502};   % first input
    % Vin2=d{2503};   % second input
    p= polyfitn([d{2002},d{2003}],y,order);  % doing polyfitn to get the polynomial regression
    vct{n}=p.Coefficients;                   % polynominal coefficients for each output run
    zg{n} = polyvaln(p,[Vin1(:),Vin2(:)]);
    diff{n}=y-zg{n};
    avg_diff_ithRun(n)=((sum(abs(diff{n})))/noOfData)/(max(y)-min(y));
end
Avg_diff=(sum(avg_diff_ithRun))/NMC