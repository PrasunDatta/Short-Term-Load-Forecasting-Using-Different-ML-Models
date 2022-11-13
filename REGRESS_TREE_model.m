%%%% Load Forecasting using Bagged Regression Trees

%% generate predictors 
in_tree(1,:) = year;
in_tree(2,:) = month;
in_tree(3,:) = day; 
in_tree(4,:) = dayOfWeek;            %day Of the Week
in_tree(5,:) = hour; 
in_tree(6,:) = preWeekSameHourLoad;  % previous Week Same Hour Load
in_tree(7,:) = preDaySameHourLoad;   % previous day same hour load
in_tree(8,:) = pre24HourAverLoad ;   % previous 24 Hour Average Load
% forming validtion input data to the same format 
vin_tree(1,:) = vyear;
vin_tree(2,:) = vmonth;
vin_tree(3,:) = vday; 
vin_tree(4,:) = vdayOfWeek;            %day Of the Week
vin_tree(5,:) = vhour; 
vin_tree(6,:) = vpreWeekSameHourLoad;  % previous Week Same Hour Load
vin_tree(7,:) = vpreDaySameHourLoad;   % previous day same hour load
vin_tree(8,:) = vpre24HourAverLoad ;   % previous 24 Hour Average Load
%% create a Regression Tree
fprintf('in progress..........');
T = fitctree(in_tree',Load')
%T = treefit(in_tree',Load');
simpleTree = prune(T, 'Level', 100)
fprintf('done\n');

%% use the Regression Tree to forecast one day ahead
RTREE_predicted= predict(simpleTree,vin_tree')';
% calculate Mean Absolute percent Error
err    = vLoad-RTREE_predicted;
errpct = abs(err)./vLoad*100;
MAPE   = mean(errpct(~isinf(errpct)));
fprintf('Mean Absolute Percent Error (MAPE) for the forecasted load of day ahead:  %0.3f%%\n',MAPE);    
%% Plot of Actual load VS forecasted load
figure(2);
t=[1:length(vLoad)];
plot(t,RTREE_predicted);  hold all;
plot(t,vLoad);            hold off;
legend('forecasted load', 'Actual load');
title('Actual load VS forecasted load for one day ahead (Regression Trees)','Fontsize', 12,'color','r');   ylabel('Load');   xlabel('Hour');
