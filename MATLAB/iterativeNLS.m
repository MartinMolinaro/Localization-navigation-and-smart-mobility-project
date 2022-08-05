function [uHat,numberOfPerformedIterations] = iterativeNLS( parameters , AP , rho , uHatInit , threshold_stopping_criterion)

uHat = zeros( parameters.NiterMax , 2 );

for iter = 1:parameters.NiterMax-1
    %% Step 1 - initial guess
    if iter==1
        uHat(iter,:) = uHatInit;
    end
    %% Step 2 - compute Jacobian matrix
    H = buildJacobianMatrixH( parameters , uHat(iter,:) , AP);

    %% Step 3 - compute the observation matrix and evaluate the difference delta rho
    h_uhat = measurementModel( parameters , uHat(iter,:) , AP);

    delta_rho = rho' - h_uhat;

    %% Step 4 - compute the correction
    %% NLS

    delta_u = pinv(H)*delta_rho';
    

    %% Step 5 - update the estimate
     uHat( iter+1 , :  ) = uHat( iter , : ) + parameters.iterative_step * delta_u';
    numberOfPerformedIterations = iter + 1;
 if threshold_stopping_criterion==1   % choice in control panel in the main
    %% stopping criterion
    if sum(delta_u.^2)<1e-6 % std. threshold chosen
        return
    end       
 end    
end

end