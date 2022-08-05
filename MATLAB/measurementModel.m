function [ h ] = measurementModel(parameters,UE,AP,TYPE)

%% compute the distance between UE and APs
distanceUEAP = sqrt( sum( [UE-AP].^2 , 2 ) ); 

%% build the vector/matrix of observation
h = zeros( 1 , parameters.numberOfAP-1 );

for a = 1:parameters.numberOfAP
  
    %case TDOA
    refBs = 2; %MASTER#AP=2
    if a<refBs
       h(a) = distanceUEAP( a ) - distanceUEAP( refBs );
    elseif a>refBs
       h(a-1) = distanceUEAP( a ) - distanceUEAP( refBs );
    end
    
end

end