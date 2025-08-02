clc
close all
clear all
file_path='D:\Gopal\orcad\Gopal_anjali\CSV\CSV\Multiplier_MC100.csv';  % faultfree MonteCarlo data
faultfree=xlsread(file_path);  %read excel file faultfree is object
		
for n = 1:size(faultfree,2)			         %size(,2) give number of column in excel if 1 give crow
        d{n}=faultfree(:,n);					% d is cell and each cell contain one column
end
order=6                 % order of polynomial
for n = 1:(size(faultfree,2)-3)			%except 1st row 1st row is time
	y=d{n+1};                           % output of each run
    Vin1=d{102};   % first input
    Vin2=d{103};   % second input
    p= polyfitn([d{102},d{103}],y,order);  % doing polyfitn to get the polynomial regression
    vct{n}=p.Coefficients;                   % polynominal coefficients for each output run 
end
nocf=size(vct{1},2)   % no. of coefficients
for j=1:nocf          % creating matrix such that same coefficients of same degree of each run polynomial come in same row

    for k=1:(size(faultfree,2)-3)
    coeff((j),(k))=vct{k}(j);
    end
end
% max & min limits of all coefficients of 2500 Monte Carlo runs
cmax=max(coeff')  % finds max of each row
cmin=min(coeff')  % finds min of each row

faulty=xlsread('F:\Swati\Result\Lead lag\C2L_up.csv'); % output with faulty component 
yf=faulty(:,2);
pfault=polyfitn([d{2502},d{2503}],yf,order);						
vctfault=pfault.Coefficients;  % coefficients of faulty polynomial
m=1;
fault=0;							%fault flag
jj=1;
kk=1;
while m<=nocf
	if (vctfault(m)>cmax(m)) 
        vctfault(m)
	fprintf(">cmax, faulty coef(%d)",m-1)
        fault=1;
        mmaaxx(jj)=m-1; %coefficients that are greater than cmax
         jj=jj+1;
		
    end
    if (vctfault(m)<cmin(m))
        vctfault(m)
	fprintf("<cmin, faulty coef(%d)",m-1)
        fault=1;
        mmiinn(kk)=m-1; %coefficients that are less than cmin
         kk=kk+1;
		
    end
	m=m+1;
	if(m==nocf+1 & fault==0)
		fprintf("not faulty")
	end
end