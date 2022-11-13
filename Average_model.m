 %%% Curve Fitting + Regression Trees + Neural Network averaging Model
 
%% validate the model
Average_load =( FIT_load+ RTREE_load + NN_load )/3.0;

% calculate Mean Absolute percent Error
err    = Load- Average_load;
errpct = abs(err)./Load*100;
MAPE   = nanmean(errpct(~isinf(errpct)));
fprintf('\n\nMean Absolute Percent Error (MAPE) for histroical loads: %0.3f%%\n',MAPE); 
% Plot of Actual load VS predicted load
figure(1);
t=[1:length(Load)];
plot(t,Average_load);  hold all;
plot(t,Load);             hold off;
legend('predicted load', 'Actual load');
title('Actual load VS predicted load (Averaging Model)','Fontsize', 12);   ylabel('Load');   xlabel('Hour');

%% predict the load for one day ahead
Average_predicted =( FIT_predicted+ RTREE_predicted + NNpredicted)/3.0;

% calculate Mean Absolute percent Error 
err    = vLoad- Average_predicted;
errpct = abs(err)./vLoad*100;
MAPE   = nanmean(errpct(~isinf(errpct)));
fprintf('Mean Absolute Percent Error (MAPE) for the forecasted load of day ahead:  %0.3f%%\n',MAPE);  

figure(2);
t=[1:length(vLoad)];
plot(t,Average_predicted);  hold all;
plot(t,vLoad);            hold off;
legend('forecasted load', 'Actual load');
title('Actual load VS forecasted load for one day ahead (Averaging Model)','Fontsize', 12);   ylabel('Load');   xlabel('Hour');

 clear  errpct err t          
                    