 %%% Curve fitting model
 
%% create the model
ft_1 = fittype('fourier8');
fit_model_1 = fit(preDaySameHourLoad(:,25:end)',Load(:,25:end)',ft_1);
%% use linear regression to get an average estimation
[b,bint,r]=regress(Load',[year' month' day' dayOfWeek'  hour' preDaySameHourLoad' pre24HourAverLoad']);
% %% validate the model
% avrege_load=([year' month' day' dayOfWeek' hour' preDaySameHourLoad'  pre24HourAverLoad']*b)';
% FIT_Load_1=fit_model_1(preDaySameHourLoad)';
% FIT_load=(FIT_Load_1+ avrege_load)/2;
% % calculate Mean Absolute percent Error
% err    = Load- FIT_load;
% errpct = abs(err)./Load*100;
% MAPE   = nanmean(errpct(~isinf(errpct)));
% fprintf('\n\nMean Absolute Percent Error (MAPE) for histroical loads: %0.3f%%\n',MAPE); 
% % Plot of Actual load VS predicted load
% figure(1);
% t=[1:length(Load)];
% plot(t,FIT_load);  hold all;
% plot(t,Load);             hold off;
% legend('predicted load', 'Actual load');
% title('Actual load VS predicted load (Curve Fitting)','Fontsize', 12);   ylabel('Load');   xlabel('Hour');

%% predict the load for one day ahead and avreage it with regression 
avrege_load=([vyear' vmonth' vday' vdayOfWeek'  vhour' vpreDaySameHourLoad',vpre24HourAverLoad']*b)';
FIT_load_1=fit_model_1(vpreDaySameHourLoad)';
FIT_predicted=(FIT_load_1+ avrege_load)/2;

% calculate Mean Absolute percent Error 
err    = vLoad- FIT_predicted;
errpct = abs(err)./vLoad*100;
MAPE   = nanmean(errpct(~isinf(errpct)));
fprintf('Mean Absolute Percent Error (MAPE) for the forecasted load of day ahead:  %0.3f%%\n',MAPE);  

figure(2);
t=[1:length(vLoad)];
plot(t,FIT_predicted);  hold all;
plot(t,vLoad);            hold off;
legend('forecasted load', 'Actual load');
title('Actual load VS forecasted load for one day ahead (Curve Fitting)','Fontsize', 12);   ylabel('Load');   xlabel('Hour');

 clear  errpct err FIT_load_1 t avrege_load           
                    