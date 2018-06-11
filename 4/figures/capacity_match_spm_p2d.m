clear; close all; clc; format short g;
load('dischg_Cby100_soc100_p2d_basicspm');


%% Plots
close all;
figure(1);
plot(spm_sim_time_vector,v_cell_sim_results_spm); hold on;
plot(time_vector_p2d,cell_voltage_results_p2d); hold off;
ylim([spm_params.CutoffVoltage spm_params.CutoverVoltage]);
ylabel('Cell Voltage, $V_\mathrm{cell}$ [V]');
legend('SPM','P2d','location','best');

N = 2; % how many curves/lines on figure
cust_map = brewermap([],'*Greys');close;
% cust_map = brewermap([],'*PuOr');close;
cmap_stop_pts = length(cust_map);
c_map_factor = 1; % starting from the darkest, what fraction is needed
cmap_new_stop_pts = floor(c_map_factor*cmap_stop_pts);
cust_map_new = cust_map(1:cmap_new_stop_pts,:);
line_colors_indices = round(linspace(1,cmap_new_stop_pts,N));
line_colors = cust_map_new(line_colors_indices,:);

run('custom_colors');
line_colors(2,:) = color_imp_coolgrey;

plot(time_vector_p2d/3600,cell_voltage_results_p2d,'color',line_colors(2,:),'linewidth',4); 
hold on;
plot(spm_sim_time_vector/3600,v_cell_sim_results_spm,'color',line_colors(1,:),'linewidth',1); 
hold off;
y_min = 2.7; y_max=4.2;
ylim([y_min, y_max]);
xlabel('Time (hours)');
ylabel('Cell Voltage, $V_\mathrm{cell}$ (V)');
legend('P2d','SPM');
legend boxoff;
yticks([y_min:0.2:y_max]);

figwidth_mm = 140; % mm elsevier 1.5 column size
ppi = [2756, nan];
fig = gcf;
fig.PaperPositionMode = 'auto';
fig.PaperUnits = 'centimeters';

InSet = get(gca, 'TightInset');
set(gca, 'Position', [InSet(1:2), 1-InSet(1)-InSet(3), 1-InSet(2)-InSet(4)]);
old_pos = fig.PaperPosition;
fig.PaperPosition = [old_pos(1) old_pos(2) figwidth_mm/10 figwidth_mm/(10*1.618)];

%% Now export to Tikz
custom_m2t_fcn('capacity_match_spm_p2d',figwidth_mm, ppi, false);