clc;
close all;
clear all;
file_path='D:\SIMRAN_GUPTA_INTERN\CSV\multiplier_ramp\mc_500runs.csv';   
data=readtable(file_path);
noOfData=size(data,1);
% Step 1: Get the total number of rows
% numRows = size(data, 1);

% Step 2: Generate random indices for all rows
% shuffledIndices = randperm(numRows); % Randomly shuffle row indices

% Step 3: Split into 80% and 20%
% splitPoint = round(0.8 * numRows); % 80% of the rows
% indices80 = shuffledIndices(1:splitPoint); % First 80% of shuffled indices
% indices20 = shuffledIndices(splitPoint+1:end); % Remaining 20% of shuffled indices

% Step 4: Access the rows
% data80 = data(indices80, :); % 80% random rows
% data20 = data(indices20, :); % 20% random rows

% % Display results
% % disp('80% Random Rows:');
% % disp(data80);
% % disp('20% Random Rows:');
% % disp(data20);
% x=data80.Time;
% y=data80.Vout;
% Vin1=data80.Vx;
% Vin2=data80.Vy;
    newVin1=data.Vx;
    newVin2=data.Vy;
    newy=data.Vout;
% Append data80 and data20 vertically
% appendedData = vertcat(data80, data20);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for n=1:10      % upto number of order
    p= polyfitn([newVin1,newVin2],newy,n);
    c1{n}=p.Coefficients;
    % newVin1=appendedData.V_Vn_;
    % newVin2=appendedData.V_Vp_;
    % newy=appendedData.V_Vout_;
    newVin1=data.Vx;
    newVin2=data.Vy;
    newy=data.Vout; % 100% data 
    % zzgg{n}=polyvaln(p,[Vin1(:),Vin2(:)]);            %for 80% data
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

