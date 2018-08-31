clear; close all; clc; format short g;

temp_vector = sort([25,linspace(-15,40,3)] + 273.15); % kelvin
N = length(temp_vector);
ce = linspace(0,2000,100);

greymap = brewermap([],'*Greys');close;
cmap_stop_pts = length(greymap);
c_map_factor = 0.8; % starting from the darkest, what fraction is needed
cmap_new_stop_pts = floor(c_map_factor*cmap_stop_pts);
greymap_new = greymap(1:cmap_new_stop_pts,:);
line_colors_indices = round(linspace(1,cmap_new_stop_pts,N));
line_colors = greymap_new(line_colors_indices,:);

run('custom_colors');
line_colors(3,:) = color_imp_blue2;
set(0,'DefaultAxesColorOrder',line_colors);
legendCell = [];
for idx = 1:length(temp_vector)
    T = temp_vector(idx);
    kappa_T = (1e-4*ce.*((-10.5+0.668*1e-3*ce+0.494*1e-6*ce.^2) +...
        (0.074  -1.78*1e-5*ce -8.86*1e-10*ce.^2).*T + (-6.96*1e-5+2.8*1e-8*ce).*T.^2).^2);
    plot(ce,kappa_T); hold on;
%     legendCell = [legendCell cellstr(num2str(T', 'T=%5.2f'))];
end
% legend(legendCell,'location','northwest');
text(1500,0.35,[num2str(temp_vector(1)', '%5.2f') 'K']);
text(1500,0.82,[num2str(temp_vector(2)', '%5.2f') 'K']);
text(1500,1.10,[num2str(temp_vector(3)', '%5.2f') 'K']);
text(1500,1.45,[num2str(temp_vector(4)', '%5.2f') 'K']);

line([1000 1000], [0 1.19],'Color',color_brick,'LineStyle','--','LineWidth',0.5);
xlabel('$c_\mathrm{e}\, (\mathrm{mol}\, \mathrm{m}^{-3})$');
ylabel('$\kappa.\, (\mathrm{S}\, \mathrm{m}^{-1})$');
plot(1000,1.2,'Color',color_brick,'marker','o','MarkerFaceColor',color_orange,'MarkerEdgeColor',color_orange);

% figwidth_mm = 140; % mm elsevier 1.5 column size
width_scale = 0.75;
figwidth_mm = 157.4776*width_scale;     % scaling the textwidth reported by LaTeX doc

% custom_m2t_fcn('m2t_kappa_ce_parametric_T',figwidth_mm, false);
custom_m2t_fcn('m2t_kappa_ce_parametric_T',figwidth_mm,[],false);