function plotEllipse( parameters , AP , ellipsePoints , UE , TYPE , tag , COLOR)
x_ell = ellipsePoints( 1 , : );
y_ell = ellipsePoints( 2 , : );

 
hold on
fig.WindowState = 'maximized';

fill( x_ell , y_ell , [.9 .95 1],'edgecolor',COLOR,'linewidth',0.5);alpha(0.01)
plot( UE(1) , UE(2) , 'o','MarkerSize',1,'MarkerEdgeColor',[0.30,0.75,0.93],'MarkerFaceColor' , [0.30,0.75,0.93])

legend('tag1_{CRB}','tag2_{CRB}','tag3_{CRB}','tag4_{CRB}')
xlim( [7 14] ) , ylim( [21.5 23] )
xlabel('meter','FontSize',12) , ylabel('meter','FontSize',12)
grid on
box on
axis equal

% axis equal
switch TYPE
    case 'TOA'
        title([' ',num2str(TYPE),', $N_{AP}$ = ',num2str(parameters.numberOfAP),' , $\sigma $ = ',num2str(parameters.sigmaTOA),' m'],'Interpreter','Latex')
    case 'RSS'
        title([' ',num2str(TYPE),', $N_{AP}$ = ',num2str(parameters.numberOfAP),' , $\sigma $ = ',num2str(parameters.sigmaRSS),' dB'],'Interpreter','Latex')
    case 'AOA'
        title([' ',num2str(TYPE),', $N_{AP}$ = ',num2str(parameters.numberOfAP),' , $\sigma $ = ',num2str(rad2deg(parameters.sigmaAOA)),' deg '],'Interpreter','Latex')
    case 'TDOA' % our case
        title([' ',num2str(TYPE),'$-Tag:$',num2str(tag),' $N_{AP}$ = ',num2str(parameters.numberOfAP),' , $\sigma $ = ',num2str(parameters.sigmaTDOA),' m'],'Interpreter','Latex')
end


end