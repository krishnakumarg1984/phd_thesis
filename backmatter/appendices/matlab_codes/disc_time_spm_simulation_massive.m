% Copyright (c) 2018 Gopalakrishnan, Krishnakumar <krishnak@vt.edu>
% Author: Gopalakrishnan, Krishnakumar <krishnak@vt.edu>

clear;clc; format short g; format compact; close all;

%% User-entered data
% case-sensitive string descriptive of cell to be simulated.
cellIdentifier = 'Northrop';

% string describing starting soc% and csv filename of load profile
% (time vs current through external circuit)
% a) 'cnst_dischg_soc_100_1C' b) 'cnst_chg_soc_100_1C' c) 'udds_soc_50' etc.
load_profile_name = 'cnst_dischg_soc_100_2C';

% Input CSV-profile setup. Note: Offsets use a 0-base numbering system
soc_col            = 1; % The starting SOC is in this column of top row
profile_row_offset = 2; % Load profile input data begins only from this row

Ts       = 1;  % sec (how often are results needed?)
tf_user  = 100;  % sec (user-entered desired simulation end-time)
% Simulation might prematurely end if voltage/soc cutoffs are hit

termination_choice = 'max'; % valid choices are 'max' and 'min'
% The 'min' choice is helpful for trials. Whilst retaining the characteristics
% of the load profile, the user may do a short time trial simulation.

%% Pre-Process user data
profile_filename  = [load_profile_name,'.csv'];

% Note: a positive C-rate implies discharge and vice-versa for charge
try
    C_rate_profile = csvread(profile_filename,profile_row_offset,0);
catch
    error('a) Error in specified file, OR  b)the load profile is not in PATH. Quitting simulation ...');
end

% Compute expected end-time for allocation of storage & maximum loop indices
if strcmp(termination_choice,'max')
    t_finish = max(tf_user,C_rate_profile(end,1)); % longer of the two prevails
    % If the last time-entry in the input csv file is shorter than user-entered
    % value, then the last C-rate from the csv file is held for rest of the
    % simulation.
elseif strcmp(termination_choice,'min')
    t_finish = min(tf_user,C_rate_profile(end,1)); % longer of the two prevails
else
    error("Invalid termination choice. Valid strings are: 'max' or 'min'.");
end

% Starting SoC percentage
soc_init_pct = csvread(profile_filename,0,soc_col,[0 soc_col 0 soc_col]);

% struct of cell parameters
spm_params = parameters_spm_basic(soc_init_pct,cellIdentifier);

I_1C = spm_params.I_1C;
clear tf_user profile_row_offset soc_col profile_filename termination_choice;

%% Pre-Compute the System and Input Matrices
clc;

F = param.F;
A = param.A;

R_pos  = param.R_p;
R_neg  = param.R_n;

Ds_pos = param.D_p;
Ds_neg = param.D_n;

a_pos  = param.a_p;
a_neg  = param.a_n;

L_pos  = param.len_p;
L_neg  = param.len_n;

%% System & Input matrices for continuous and discrete-time implementations

A_cts = [-30*Ds_pos/(R_pos^2),                    0, 0; ...
    0, -30*Ds_neg/(R_neg^2), 0; ...
    0,                    0, 0];

A_disc = expm(A_cts*Ts);

B_cts = [ (45/2)/(R_pos^2*a_pos*L_pos*F*A); ...
    (-45/2)/(R_neg^2*a_neg*L_neg*F*A); ...
    (-3/(R_neg*a_neg*L_neg*F*A))];

B_disc = nan(size(B_cts));
B_disc(1) = B_cts(1)*(exp(A_cts(1,1)*Ts)-1)/A_cts(1,1);
B_disc(2) = B_cts(2)*(exp(A_cts(2,2)*Ts)-1)/A_cts(2,2);
B_disc(3) = B_cts(3)*Ts;

% Through built-in 'c2d' command by the dummy system-method (tricking MATLAB
% to believe we have an LTI system). The output matrix,C is chosen so that the
% states-themselves are the outputs with no feed-through term involved.

C_dummy = [1, 1, 1]; D_dummy = 0;
sys_cts = ss(A_cts,B_cts,C_dummy,D_dummy);
sys_disc = c2d(sys_cts,Ts);

outputEqn  = @spm_three_states_battery_voltage;

%% Allocate storage for simulated quantities
num_iterations = ceil(t_finish/Ts) + 1; % max no. of steps (assuming no cutoff)

spm_sim_time_vector        = nan(num_iterations,1);
load_current_vector        = nan(num_iterations,1);
v_cell_sim_results_spm     = nan(num_iterations,1);
soc_pct_results_spm        = nan(num_iterations,1);
cs_avg_neg_sim_results_spm = nan(num_iterations,1);
q_pos_sim_results_spm      = nan(num_iterations,1);
q_neg_sim_results_spm      = nan(num_iterations,1);

%% Initialise SPM state vector and all other simulated quantities
spm_sim_time_vector(1)        = 0;
soc_pct_results_spm(1)        = soc_init_pct;
cs_avg_neg_sim_results_spm(1) = spm_params.cs_n_init;
q_pos_sim_results_spm(1)      = 0;
q_neg_sim_results_spm(1)      = 0;

% load current applied at t = t0
load_current_vector(1) = I_1C*interp1(C_rate_profile(:,1),C_rate_profile(:,2),spm_sim_time_vector(1),'previous','extrap');

x_spm_init = [q_pos_sim_results_spm(1); ...
    q_neg_sim_results_spm(1); ...
    cs_avg_neg_sim_results_spm(1)];

v_cell_sim_results_spm(1) = outputEqn(x_spm_init,load_current_vector(1),spm_params);

t_local_finish     = Ts;
x_spm_local_finish = x_spm_init;

clear x_init q_pos_init q_neg_init;

%% Simulate the SPM
progressbarText(0);

for k = 2:num_iterations  % Need solution at k-th time-step
    load_current_vector(k)        = I_1C*interp1(C_rate_profile(:,1),C_rate_profile(:,2),spm_sim_time_vector(k-1),'previous','extrap'); % load current that was held constant from (k-1) to (k)
    x_spm_local_finish            = A_disc*x_spm_local_finish + B_disc*load_current_vector(k);

    q_pos_sim_results_spm(k)      = x_spm_local_finish(1);
    q_neg_sim_results_spm(k)      = x_spm_local_finish(2);
    cs_avg_neg_sim_results_spm(k) = x_spm_local_finish(3);

    soc_pct_results_spm(k)        = 100*((cs_avg_neg_sim_results_spm(k)/spm_params.cs_max_n) - spm_params.theta_min_neg)/(spm_params.theta_max_neg - spm_params.theta_min_neg);
    v_cell_sim_results_spm(k)     = outputEqn(x_spm_local_finish,load_current_vector(k),spm_params);

    overall_exit_status = check_termination(soc_pct_results_spm(k),v_cell_sim_results_spm(k),spm_params);
    if overall_exit_status ~= 0 % check for violation of cut-off conditions
        k = k - 1; % Values in the last simulated index are incorrect.
        fprintf('Exiting simulation ...\n');
        break;
    end

    spm_sim_time_vector(k) = t_local_finish;
    t_local_start          = t_local_finish;
    t_local_finish         = t_local_start + Ts;
    progressbarText((k-1)/num_iterations);
end
fprintf('\n');

spm_sim_time_vector        = spm_sim_time_vector(1:k);
load_current_vector        = load_current_vector(1:k);
q_pos_sim_results_spm      = q_pos_sim_results_spm(1:k);
q_neg_sim_results_spm      = q_neg_sim_results_spm(1:k);
cs_avg_neg_sim_results_spm = cs_avg_neg_sim_results_spm(1:k);
soc_pct_results_spm        = soc_pct_results_spm(1:k);
v_cell_sim_results_spm     = v_cell_sim_results_spm(1:k);

%% Save results to disk
save_foldername = ['spm_results/', cellIdentifier, '/', load_profile_name];
if exist(save_foldername,'dir')==0
    mkdir(save_foldername);
end

% Replace decimal point chars in soc% string with 'p' (stands for point)
soc_init_pct_savestr = strrep(num2str(soc_init_pct),'.','p');

clear soc_init_pct C_rate_profile I_1C k num_iterations; % redundant info
clear x_spm_init x_spm_local_finish t_local_finish t_local_start;
save([save_foldername, '/disc_sim_', ...
    datestr(now, 'mmm_dd_yyyy_HH_MM_SS')]); % save workspace to file

function v_cell = spm_three_states_battery_voltage(x,u,param)
    % returns v_cell given the vector x and input u at any given time-step
    % x(1) = q_pos, x(2) = q_neg, x(3) = cs_avg_neg
    % u = load current (A). Positive implies discharge.

    % Copyright (c) 2018 Gopalakrishnan, Krishnakumar <krishnak@vt.edu>
    % Author: Gopalakrishnan, Krishnakumar <krishnak@vt.edu>

    R      = param.R;
    T      = param.Tref;
    F      = param.F;

    R_pos  = param.R_p;
    R_neg  = param.R_n;

    Ds_pos = param.D_p;
    Ds_neg = param.D_n;

    a_pos  = param.a_p;
    a_neg  = param.a_n;

    L_pos  = param.len_p;
    L_neg  = param.len_n;

    k_p    = param.k_p;
    k_n    = param.k_n;

    ce     = param.ce_init;
    A      = param.A;

    cs_max_n = param.cs_max_n;
    cs_max_p = param.cs_max_p;

    theta_min_neg = param.theta_min_neg;
    theta_min_pos = param.theta_min_pos;
    theta_max_neg = param.theta_max_neg;
    theta_max_pos = param.theta_max_pos;

    % Extract permissible bounds for solid concentrations
    cs_surf_pos_lb = param.theta_max_pos*param.cs_max_p;
    cs_surf_pos_ub = param.theta_min_pos*param.cs_max_p;
    cs_surf_neg_lb = param.theta_min_neg*param.cs_max_n;
    cs_surf_neg_ub = param.theta_max_neg*param.cs_max_n;

    % Extract the function handles for Uocp_pos and Uocp_neg
    compute_Uocp_pos = param.compute_Uocp_pos;
    compute_Uocp_neg = param.compute_Uocp_neg;

    %% Compute surface concentrations
    cs_surf_neg = x(3) + (8*R_neg/35)*x(2) - (R_neg/(35*Ds_neg*a_neg*L_neg*F*A))*u;
    cs_surf_neg = min(cs_surf_neg_ub, max(cs_surf_neg_lb, cs_surf_neg)); % saturation

    cs_avg_pos = cs_max_p*(theta_min_pos + ((x(3) - theta_min_neg*cs_max_n)./((theta_max_neg - theta_min_neg)*cs_max_n))*(theta_max_pos - theta_min_pos));  % average concentration in pos electrodue (analytical expn using conservation of Li)
    cs_surf_pos = cs_avg_pos + (8*R_pos/35)*x(1) + (R_pos/(35*Ds_pos*a_pos*L_pos*F*A))*u; % surface concentration of pos electrode
    cs_surf_pos = min(cs_surf_pos_ub, max(cs_surf_pos_lb, cs_surf_pos)); % saturation

    %% Compute overpotentials
    eta_p = (2*R*T/F)*asinh(-u/(2*A*F*a_pos*L_pos*k_p*sqrt(ce*cs_surf_pos*(cs_max_p - cs_surf_pos))));
    eta_n = (2*R*T/F)*asinh(u/(2*A*F*a_neg*L_neg*k_n*sqrt(ce*cs_surf_neg*(cs_max_n - cs_surf_neg))));

    %% Compute OCPs
    surf_theta_p  = cs_surf_pos/param.cs_max_p;
    surf_theta_n  = cs_surf_neg/param.cs_max_n;

    U_p = compute_Uocp_pos(surf_theta_p);
    U_n = compute_Uocp_neg(surf_theta_n);

    phi_pos = eta_p + U_p;
    phi_neg = eta_n + U_n;

    v_cell = phi_pos - phi_neg;

end

function U_p = compute_Uocp_pos(theta_p)

    U_p = (-4.656+88.669*theta_p.^2 - 401.119*theta_p.^4 + 342.909*theta_p.^6 - 462.471*theta_p.^8 + 433.434*theta_p.^10);
    U_p = U_p./(-1+18.933*theta_p.^2-79.532*theta_p.^4+37.311*theta_p.^6-73.083*theta_p.^8+95.96*theta_p.^10);

end

function U_n = compute_Uocp_neg(theta_n)

    U_n   = 0.7222 + 0.1387*theta_n + 0.029*theta_n.^0.5 - 0.0172./theta_n + 0.0019./theta_n.^1.5 + 0.2808*exp(0.9-15*theta_n)-0.7984*exp(0.4465*theta_n - 0.4108);

end

