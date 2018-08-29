clear; close all; clc; format short g;

no_of_pts = 15;
temperature = linspace(-15,40,no_of_pts) + 273.15; % kelvin
ce = linspace(0,2000,no_of_pts);

[Ce,T] = meshgrid(ce,temperature);

kappa = (1e-4*Ce.*((-10.5+0.668*1e-3*Ce+0.494*1e-6*Ce.^2) +...
                (0.074  -1.78*1e-5*Ce -8.86*1e-10*Ce.^2).*T + (-6.96*1e-5+2.8*1e-8*Ce).*T.^2).^2);

%% Plots
%  brewermap('plot')
clf;
surf(Ce,T,kappa,'EdgeColor','interp','LineStyle','none','FaceColor','interp');
ylim([250 320]);
xlabel('$c_\mathrm{e}\, (\mathrm{mol}\, \mathrm{m}^{-3})$');
ylabel('$\mathrm{Temp.}\, (K)$');
zlabel('$\kappa.\, (\mathrm{S}\, \mathrm{m}^{-1})$');

% colormap(brewermap([],'*Greys'));
customgrey_start = gray(300);
customgrey = customgrey_start(1:225,:);
colormap(customgrey);
colorbar;
shg;

% figwidth_mm = 140; % mm elsevier 1.5 column size
width_scale = 0.75;
figwidth_mm = 157.4776*width_scale;     % scaling the textwidth reported by LaTeX doc

% custom_m2t_fcn('m2t_kappa_ce_T',figwidth_mm, false);
custom_m2t_fcn('m2t_kappa_ce_T',figwidth_mm,[],false);
