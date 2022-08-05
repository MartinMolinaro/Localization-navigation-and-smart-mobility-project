function [uHatTime , numberOfPerformedIterations]=trackerNLS(parameters, AP, rho, u_Init , threshold_stopping_criterion)
Time=size(rho,2);
uHatTime=zeros(Time,2);

for t=1:Time
[ uHat , numberOfPerformedIterations ] = iterativeNLS( parameters , AP, rho (:,t) , u_Init , threshold_stopping_criterion);

uHat = uHat( 1:numberOfPerformedIterations , :);
uHatTime(t,:)=uHat(numberOfPerformedIterations,:);

end


end