%%% Neural Network Model

%% generate predictors 

%in(1,:) = year;  % this one will be used for long term forecasting only 
in(1,:) = month;
in(2,:) = day; 
in(3,:) = dayOfWeek;  %day Of the Week
in(4,:) = hour; 
in(5,:) = preWeekSameHourLoad;  % previous Week Same Hour Load
in(6,:) = preDaySameHourLoad;   % previous day same hour load


% forming validtion input data to the same format 

%vin(1,:) = vyear;  % this one will be used for long term forecasting only 
vin(1,:) = vmonth;
vin(2,:) = vday; 
vin(3,:) = vdayOfWeek;  %day Of the Week
vin(4,:) = vhour; 
vin(5,:) = vpreWeekSameHourLoad;  % previous Week Same Hour Load
vin(6,:) = vpreDaySameHourLoad;   % previous day same hour load


%% create and train the network

reTrain = input('Do you want to load a pre-trained Network or train a new network? \n(u ==load pre_trained network , r ==re_train): ','s');
if reTrain=='r' || reTrain=='R' || ~exist('Models\NNModel.mat', 'file')
    min_err     = inf;
    % since the NN has diffrent behaviour and it can generate different
    % results every time the network is intialized 
    % the network has to be rebulit to generate the minimum MAPE
    % this is done by trail and error until a good reuslt is achieved 
    % desired_err should take the MAPE of the best result
    % and when training the network again, the code will ensure to get to
    % the achieved results before, by re-intialzing the network
    % so if you are training a new network with no previous results 
    % start with a big desired_err (say 100) and run, if the training is
    % finished reduce the desired_err until the network no longer converges
    % i.e. the training does not stop
    % in my case I tested the network with my current database and I
    % managed to go down until 4, after that the network stopped converging
    % note that changes in the database can make the network not convege to
    % the current desired_err, so desired_err has to be increased until it
    % converges 
    tic
    display('training in progress.......');
    display('Note: If the network does not converge after 30 minutes then use CTRL+C to stop the code');
    display('and go to NN_model.m file and change the variable desired_err to a bigger value or ');
    display('a satisfying value that is displayed and try again repeat until the NN converges.');
    display('To understand why, please  refer to the comment above the variable desired_err in NN_model.m');
    desired_err = 4.7;
    
    while min_err>desired_err
    for neurons_no = 1:3:24
        net = newff(in, Load, neurons_no);   %% using newfit or newff 
        net.performFcn = 'mae';
        net = train(net, in, Load);
        
        NNpredicted = sim(net, vin);  
        % Mean absolute percentage error.
        err    = vLoad - NNpredicted;
        errpct = abs(err)./vLoad*100;            %Absolute percentage error
        MAPE   = mean(errpct(~isinf(errpct)));  
        fprintf('Current MAPE(Mean Absolute Percent Error):  %0.3f%%\n',MAPE);  
        if MAPE<min_err
            min_err= MAPE;
            if min_err <= desired_err
                break;
            end
        end
    end
    end
    toc
    fprintf('Mean Absolute Percent Error (MAPE) for the forecasted load of day ahead:  %0.3f%%\n',MAPE);  
    x=input('Do you want to save this network? ( y ==yes , else==no): ','s');
    if x=='y' || x=='Y'
        save Models\NNModel.mat net
        display('Network has been saved');       
    end

    
else
    load Models\NNModel.mat
    NNpredicted = sim(net, vin);  
    % Mean absolute percentage error.
    err    = vLoad - NNpredicted;
    errpct = abs(err)./vLoad*100;            %Absolute percentage error
    MAPE  = mean(errpct(~isinf(errpct)));  
    fprintf('\nMean Absolute Percent Error (MAPE) for the forecasted load of day ahead:  %0.3f%%\n',MAPE);        
end

clear reTrain min_err desired_err neurons_no err x   % delete temporary variables 

%% Plot of Actual load VS forecasted load

figure(1);
t=[1:length(vLoad)];
plot(t,NNpredicted);  hold all;
plot(t,vLoad);             hold off;
legend('forecasted load', 'Actual load');
title('Actual load VS forecasted load for one day ahead (Neural Networks)','Fontsize', 12,'color','b');   ylabel('Load');   xlabel('Hour'); 

% %% Test the network data for the hestorical loads
% NN_load = sim(net, in);  
% % Mean absolute percentage error.
% err    = Load - NN_load;
% errpct = abs(err)./Load*100;            %Absolute percentage error
% MAPE   = mean(errpct(~isinf(errpct)));  
% fprintf('Mean Absolute Percent Error (MAPE) for histroical loads: %0.3f%%\n',MAPE); 
% % Plot of Actual load VS predicted load  
% figure(2);
% t=[1:length(Load)];
% plot(t,NN_load);  hold all;
% plot(t,Load);            hold off;
% legend('predicted load', 'Actual load');
% title('Actual load VS predicted load (Neural Networks)','Fontsize', 12,'color','b');   ylabel('Load');   xlabel('Hour');
% 
