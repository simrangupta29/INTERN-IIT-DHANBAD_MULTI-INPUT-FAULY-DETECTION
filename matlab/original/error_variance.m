clc;
close all;
clear all;

% Read the CSV file
file_path = 'D:\Gopal\orcad\Gopal_anjali\CSV\Multiplier_MC100.csv';   
data = readtable(file_path);


% Now you can access columns like:
newVin1=data.Vx;
    newVin2=data.Vy;
    newy=data.Vout; % 100% data

for n=1:10      % upto number of order
    p= polyfitn([newVin1,newVin2],newy,n);
    c1{n}=p.Coefficients;
    
    zg{n} = polyvaln(p,[newVin1(:),newVin2(:)]);        %for all 100% data
    residuals{n}=newy-zg{n};
    %var1{n}=residuals{n}.^2;
    mserror(n)=sum(residuals{n}.^2);  %%%  Sr
end
for k=1:10                                       % method for finding optimum order
    optimal_order(k)=mserror((k))/(noOfData-k-1);         %criteria
end
% subplot(2, 1, 1);
figure;
plot(optimal_order, 'o-', 'LineWidth', 1);  
xlabel('Order');
ylabel('Sr/(n-m-1)');
title('Optimum Order Plot');
grid on;
% subplot(2, 1, 2);
figure;
plot(mserror, 'o-', 'LineWidth', 1);  
xlabel('Order');
ylabel('value');
title('Error Plot');
grid on;
