function [ H ] = buildJacobianMatrixH(parameters,UE,AP)

%% compute the distance between UE and APs
distanceUEAP = sqrt( sum( [UE-AP].^2 , 2 ) ); 

%% evaluate direction cosine
directionCosineX = ( UE(1)-AP(:,1) ) ./ distanceUEAP;
directionCosineY = ( UE(2)-AP(:,2) ) ./ distanceUEAP;

%% build H
H = zeros( parameters.numberOfAP-1 , 2 );
for a = 1:parameters.numberOfAP
     %case 'TDOA'
     refBs=2; % MASTER#AP=2
            if a<refBs
            H(a,:)=[-directionCosineX(refBs)+directionCosineX(a) , -directionCosineY(refBs)+directionCosineY(a) ];
            elseif a>refBs
            H(a-1,:)=[-directionCosineX(refBs)+directionCosineX(a) , -directionCosineY(refBs)+directionCosineY(a) ];    
            end
         
end

end