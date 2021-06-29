% Plot profiles
load pressure_displacement_profiles

% Plot initial -Cp and shape
fig1=figure;
plot(initial.x,-initial.cp,'b-'); hold on;
plot(initial.x,initial.disp,'k-');
