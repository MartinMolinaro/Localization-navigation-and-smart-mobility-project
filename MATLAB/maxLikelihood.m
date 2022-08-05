function [uhat]=maxLikelihood(parameters, rho , AP , x , y , show_plots_ML)
%% 1. Compute likelihood for each AP in each evaluation point
likelihood = zeros(parameters.numberOfAP,length(x),length(y));
TYPE = 'TDOA';

for a = 1:parameters.numberOfAP
   if a<parameters.numberOfAP
   rho_True = rho (a , 1) ; % initial position
   end
   
    % evaluate the likelihood in each evaluation point
    for i=1:1:length(x)        
        for j=length(y):-1:1
            if a~=2 % MASTER.AP#=2
                
               likelihood(a,i,j) = evaluateLikelihoodTDOA( parameters, rho_True , AP(2,:) , AP(a,:) , [x(i),y(j)] ); % AP2 is the master AP          
            end            
        end %j        
    end %i
end %a

%% 2.3. Plot the likelihood for each AP
if show_plots_ML==1
plot2Dlikelihood( parameters, AP , [15 , 15] , x , y , likelihood , TYPE) % initial guess in the middle of the localization area
plot3Dlikelihood( parameters, AP , [15 , 15] , x , y , likelihood , TYPE)
end
%% 4. Compute the maximum likelihood and plot it
% compute ML
maximumLikelihood = ones( length(x) , length(y) );

    for a = 1:parameters.numberOfAP
        if a~=2
        maximumLikelihood = maximumLikelihood.*squeeze(likelihood(a,:,:));
        end
    end

maximumLikelihood = maximumLikelihood./sum(sum(maximumLikelihood)); %normalization

%plot
if show_plots_ML==1
plotMaximumlikelihood( parameters, AP , [15 , 15] , x , y , maximumLikelihood , TYPE)
end
%% 5. Evaluate the UE estimated (initial) position
maxValue = max( maximumLikelihood(:) );
[xhat yhat] = find( maximumLikelihood == maxValue );
uhat(1,1) = x(xhat(1));
uhat(1,2) = y(yhat(1));

fprintf('\n The estimated initial tag position is [ %.3f %.3f ] \n', uhat(1), uhat(2))
end