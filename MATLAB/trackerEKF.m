function [x_hat]=trackerEKF(parameters, AP , rho, u_Init , driving_noise_sigma_pos , driving_noise_sigma , MODEL , UE_init_COV_pos , UE_init_COV_vel , show_plots_covarianceEKFM1 , show_plots_covarianceEKFM3)
Time=size(rho,2);
switch MODEL
    case 'M1'
%% 1.Motion Model M1 (random-walk): Measurement of: position, State: position
% 1.1.Initialization
% Covariance of measurement noise n [choice]
sigma=repmat(parameters.sigmaTDOA.^2,5,1);
R=diag(sigma);
% Covariance matrix of the driving process noise w [choice]
Q = diag([driving_noise_sigma_pos driving_noise_sigma_pos]); % chosen variance
% System model matrix
F = [1, 0; 0 , 1]; %identity matrix

UE_init = u_Init; % computed with ML or random
UE_init_COV = diag([UE_init_COV_pos^2; UE_init_COV_pos^2]); % choice [control panel]
x_hat = zeros( Time , 2);
P_hat = zeros( 2 , 2 , Time );

% Update over time
for time = 1 : Time
    % Prediction
    if time == 1
        x_pred = UE_init';
        P_pred = UE_init_COV;
    else
        x_pred = F * x_hat(time-1,:)';
        P_pred = F * P_hat(:,:,time-1) * F' + Q;
    end
    H = buildJacobianMatrixH(parameters,x_pred',AP);
    h = measurementModel( parameters , x_pred' , AP);
    % Update
    G = P_pred * H' * inv(H * P_pred * H' + R);
    x_hat(time,:) = x_pred' + (G * (rho(:,time) - h'))';
    P_hat(:,:,time) = P_pred - G * H * P_pred;

    if show_plots_covarianceEKFM1==1
    %plot evolution
    fig = figure(11); hold on;
    set(gcf,'Visible','on')
    fig.WindowState = 'maximized';
    %plot( UE(:,1) , UE(:,2) , 'o','MarkerSize',10,'MarkerEdgeColor',[0.30,0.75,0.93],'MarkerFaceColor',[0.30,0.75,0.93] ), hold on
    %plot( UE(time,1) , UE(time,2) , 'o','MarkerSize',10,'MarkerEdgeColor',[0.30,0.75,0.93],'MarkerFaceColor',[0.50,0,0] ),
    plotCovariance( P_pred(1:2,1:2)  , x_pred(1) , x_pred(2)  , 3 , 'Prior');
    axis equal
    xlim([parameters.xmin parameters.xmax]) , ylim([parameters.ymin parameters.ymax])
    xlabel('[m]'), ylabel('[m]');
    legend('Cov. pred.')
    title('EKF-M1  Time:',  num2str(time) )
    
    %plot( rho(time,1) , rho(time,2) , '^k')
    plot( x_hat(:,1) , x_hat(:,2) ,'o',  'MarkerFaceColor','green','MarkerSize',1)
    plotCovariance( P_hat(1:2,1:2,time)  , x_hat(time,1) , x_hat(time,2)  , 3 , 'Update');
    legend('Cov. pred.','KF est. ','Cov. upd.')

    pause(0.01)
    hold off
    end
end




    case 'M3'
%% 2.Motion Model M3 (NCV -random force): Measurement of: position, State: position, velocity
% 1.1.Initialization
% Covariance of measurement noise n [choice]
sigma=repmat(parameters.sigmaTDOA.^2,5,1);
R=diag(sigma);

% Covariance matrix of the driving process noise w [choice]

L = [parameters.samplingTime^2/2 0;
     0 parameters.samplingTime^2/2;
     parameters.samplingTime 0;
     0 parameters.samplingTime];
 
Q = driving_noise_sigma^2 * L * L';

% System model matrix
 
F = [1 0 parameters.samplingTime 0;
     0 1 0 parameters.samplingTime;
     0 0 1 0;
     0 0 0 1];
 
UE_init = [u_Init, 0, 0]; % 4 states 2 pos, 2 vel
UE_init_COV = diag([UE_init_COV_pos^2; UE_init_COV_pos^2 ; UE_init_COV_vel^2 ; UE_init_COV_vel^2]); % large uncertainty (100 or bigger) % (riguarda e parametrizza al posto di 100)
x_hat = zeros( Time , 4);
P_hat = zeros( 4 , 4 , Time );


% Update over time
for time = 1 : Time
    % Prediction
    if time == 1
        x_pred = UE_init';
        P_pred = UE_init_COV;
    else
        x_pred = F * x_hat(time-1,:)';
        P_pred = F * P_hat(:,:,time-1) * F' + Q;
    end
    H = [buildJacobianMatrixH(parameters,x_pred(1:2)',AP) , zeros(5,2)];
    h = measurementModel( parameters , x_pred(1:2)' , AP);
    % Update
    G = P_pred * H' * inv(H * P_pred * H' + R);
    x_hat(time,:) = x_pred' + (G * (rho(:,time) - h'))';
    P_hat(:,:,time) = P_pred - G * H * P_pred;

      if show_plots_covarianceEKFM3==1
    %plot evolution
    fig = figure(11); hold on;
    set(gcf,'Visible','on')
    fig.WindowState = 'maximized';
    %plot( UE(:,1) , UE(:,2) , 'o','MarkerSize',10,'MarkerEdgeColor',[0.30,0.75,0.93],'MarkerFaceColor',[0.30,0.75,0.93] ), hold on
    %plot( UE(time,1) , UE(time,2) , 'o','MarkerSize',10,'MarkerEdgeColor',[0.30,0.75,0.93],'MarkerFaceColor',[0.50,0,0] ),
    plotCovariance( P_pred(1:2,1:2)  , x_pred(1) , x_pred(2)  , 3 , 'Prior');
    axis equal
    xlim([parameters.xmin parameters.xmax]) , ylim([parameters.ymin parameters.ymax])
    xlabel('[m]'), ylabel('[m]');
    legend('Cov. pred.')
    title('EKF-M3   Time:',  num2str(time) )
    
    %plot( rho(time,1) , rho(time,2) , '^k')
    plot( x_hat(:,1) , x_hat(:,2) ,'o',  'MarkerFaceColor','green','MarkerSize',1)
    plotCovariance( P_hat(1:2,1:2,time)  , x_hat(time,1) , x_hat(time,2)  , 3 , 'Update');
    legend('Cov. pred.','KF est.','Cov. upd.')

    pause(0.01)
    hold off
    end

end


end

end