clear; close all; clc; format short g;

no_of_pts = 100;
temperature = linspace(-15,40,no_of_pts) + 273.15; % kelvin
ce = linspace(0,2000,no_of_pts);

[Ce,T] = meshgrid(ce,temperature);

kappa = (1e-4*Ce.*((-10.5+0.668*1e-3*Ce+0.494*1e-6*Ce.^2) +...
                (0.074  -1.78*1e-5*Ce -8.86*1e-10*Ce.^2).*T + (-6.96*1e-5+2.8*1e-8*Ce).*T.^2).^2);

%% Plots
%  brewermap('plot')
clf;
surf(Ce,T,kappa,'EdgeColor','interp','LineStyle','none','FaceColor','interp');
% colormap(brewermap([],'*Greys'));
customgrey_start = gray(300);
customgrey = customgrey_start(1:225,:);
colormap(customgrey);
colorbar ;
shg;

cleanfigure;
matlab2tikz('showInfo',false,'m2t_kappa_ce_T.tikz');
