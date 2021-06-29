% Plot profiles
load pressure_displacement_profiles

fig1=figure;
%here, the groups of two are put as input for each of the y slots, while the x are the same
[hAx,hLine1,hLine2] = plotyy(initial.x,[-initial.cp -optimal.cp],initial.x,[initial.disp optimal.disp]); 
set(hAx(1),'YLim',[-1.2 1])             %these 4 lines of code set 
set(hAx(2),'YLim',[-0.1 0.6])           %the vertical limits
set(hAx(1),'ytick',[-1.2:0.2:1]);       %and tick frequency
set(hAx(2),'ytick',[-0.1:0.1:0.6]);     
set(hLine1(1),'linestyle','-','Color','b','linewidth',2);       %these lines of code set the lines
set(hLine1(2),'linestyle',':','Color','b','linewidth',2);       %to the given style 
set(hLine2(1),'linestyle','-','Color',[0 0.5 0],'linewidth',2); %[0 0.5 0] is rgb for dark green, b is blue
set(hLine2(2),'linestyle',':','Color',[0 0.5 0],'linewidth',2); %- is solid line and : is dotted line
ylabel(hAx(1),'$-C_p$','interpreter','latex') %here the label is written in latex formapt.
ylabel(hAx(2),'Distance transverse to air foil','interpreter','latex') %here the label is written in latex format.
set(hAx,{'ycolor'},{'b';[0 0.5 0]})     %this sets the color of vertical limits and ticks.
%here the legend (the part where the names for lines is written) is written in latex format.
legend([hLine1(1);hLine2(1);hLine1(2);hLine2(2)],'Initial $(C_)$','Initial (Shape)','Optimal $(C_p)$','Optimal (Shape)','interpreter','latex','Location','best');