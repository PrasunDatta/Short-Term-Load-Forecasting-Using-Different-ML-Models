%%% Multiple linear regression

%% generate predictors 
clear in_regress vin_regress
in_regress(1,:) = preDaySameHourLoad;   % previous day same hour load
in_regress(2,:) = pre24HourAverLoad ;   % previous 24 Hour Average Load
in_regress(3,:) = day; 
in_regress(4,:) = dayOfWeek;            %day Of the Week

% forming validtion input data to the same format 
vin_regress(1,:) = vpreDaySameHourLoad;   % previous day same hour load
vin_regress(2,:) = vpre24HourAverLoad ;   % previous 24 Hour Average Load
vin_regress(3,:) = vday; 
vin_regress(4,:) = vdayOfWeek;            %day Of the Week


%% create regression coefficients b
fprintf('in progress..........');
[b,bint,r]=regress(Load',in_regress');
fprintf('done\n');

%% validate the Regression coefficients by evaluating the input data
% REGRESS_load=(in_regress'*b)';
% % calculate Mean Absolute percent Error
% err    = Load-REGRESS_load;
% errpct = abs(err)./Load*100;
% MAPE   = nanmean(errpct(~isinf(errpct)));
% fprintf('\nMean Absolute Percent Error (MAPE) for histroical loads: %0.3f%%\n',MAPE); 
% % Plot of Actual load VS predicted load
% figure(1);
% t=[1:length(Load)];
% plot(t,REGRESS_load);  hold all;
% plot(t,Load);             hold off;
% legend('predicted load', 'Actual load');
% title('Actual load VS predicted load (linear Regression)','Fontsize', 12,'color','m');   ylabel('Load');   xlabel('Hour');

%% use the Regression coefficients to forecast one day ahead
REGRESSpredictd=(vin_regress'*b)';
% calculate Mean Absolute percent Error
err    = vLoad-REGRESSpredictd;
errpct = abs(err)./vLoad*100;
MAPE   = nanmean(errpct(~isinf(errpct)));
fprintf('Mean Absolute Percent Error (MAPE) for the forecasted load of day ahead:  %0.3f%%\n',MAPE);    
%% Plot of Actual load VS forecasted load
figure(2);
t=[1:length(vLoad)];
plot(t,REGRESSpredictd);  hold all;
plot(t,vLoad);            hold off;
legend('forecasted load', 'Actual load');
title('Actual load VS forecasted load for one day ahead (linear Regression)','Fontsize', 12,'color','m');   ylabel('Load');   xlabel('Hour'); 