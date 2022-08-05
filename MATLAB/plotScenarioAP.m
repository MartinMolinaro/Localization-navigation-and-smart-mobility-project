function plotScenarioAP( parameters , AP)

nAP = parameters.numberOfAP;
xmin = parameters.xmin;
ymin = parameters.ymin;
zmin = parameters.zmin;
xmax = parameters.xmax;
ymax = parameters.ymax;
zmax = parameters.zmax;


fig = figure(); hold on
fig.WindowState = 'maximized';
% Localization area
x = [xmin xmin xmin; xmin xmin xmax; xmin xmax xmax; xmin xmax xmin];
y = [ymax ymin ymax; ymin ymin ymax; ymin ymin ymin; ymax ymin ymin];
z = [zmax zmin zmax; zmax zmax zmax; zmin zmax zmax; zmin zmin zmax]; %for 3D
patch( x , y, z , 'c' , 'FaceAlpha', .1)


% AP
plot( AP(:,1) , AP(:,2) , '^' , 'MarkerSize', 8 , 'MarkerEdgeColor' , [ 0.64 , 0.08 , 0.18 ] , 'MarkerFaceColor' , [ 0.64 , 0.08 , 0.18 ] )
legend('AP','location','northwest')
axis equal

for a=1:nAP
   text( AP(a,1)+2 , AP(a,2) , sprintf('AP %d ', a) )
end


grid on
% grid minor
box on
axis equal
legend( 'Localization Area' , 'AP' , 'location' , 'best' )
xticks( [xmin:5:xmax] )  , yticks( [xmin:5:xmax] ) , zticks( [zmin:5:zmax] )
xlim( [xmin-5 xmax+5] ) , ylim( [ymin-5 ymax+5] ) , zlim( [zmin-5 zmax+5] )
xlabel( 'meter' , 'FontSize' , 12 ) , ylabel( 'meter' , 'FontSize' , 12 )



end