%% Data processing function
function [rho]=dataProcessing(rho , parameters_rho , show_plots , refinement , remove_outliers)
%% Original data
time=1:parameters_rho.rho_TimeSteps;

% plotting
if show_plots==1
figure;
plot(time,rho)
xlabel('TimeSteps'),ylabel('TDOA measurements');
title('Original data')
end

%% Fill missing data
cleanedData = fillmissing(rho,'linear',2);

% plotting
if show_plots==1
figure;
plot(time,cleanedData)
xlabel('TimeSteps'),ylabel('TDOA measurements');
title('Filled missing data')
fprintf('\n');
end

if remove_outliers==1
%% Fill outliers [step-by-step]


% 1.Remove big outliers
cleanedData2 = filloutliers(cleanedData,'linear','movmedian', 10,2,'SamplePoints',time, 'ThresholdFactor', 2);

% plotting
if show_plots==1
figure;
plot(time,cleanedData2)
xlabel('TimeSteps'),ylabel('TDOA measurements');
title('Remove big outliers')
fprintf('\n');
end

% 2.Refining
rho_out=filloutliers(cleanedData2,'linear','movmedian', 10,2,'SamplePoints',time, 'ThresholdFactor', refinement);

% plotting
if show_plots==1
figure;
plot(time,rho_out)
xlabel('TimeSteps'),ylabel('TDOA measurements');
title('Refined data')
fprintf('\n');
end

%% Final cleaned and refilled rho
rho=rho_out;
else
    rho = cleanedData; % if you don't remove outliers
end
end
