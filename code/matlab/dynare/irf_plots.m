%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Collect IRFs values and plot them from DYNARE outputs. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Generate IRFs from DYNARE

dynare intCapitalv3;            % CES
irfs_ces = oo_.irfs;

dynare intCapitalv3_1 ;         % C-D
irfs_cd = oo_.irfs;

dynare tangibleCapitalOnly; 
irfs_tan = oo_.irfs;

dynare intangibleCapitalOnly;
irfs_int = oo_.irfs;

close all;

%% Generate IRFs from DYNARE exp version

dynare intCapital_exp_v3;
irfs_exp_ces = oo_.irfs;

dynare tangibleCapitalOnly_exp; 
irfs_exp_tan = oo_.irfs;

dynare intangibleCapitalOnly_exp;
irfs_int_exp = oo_.irfs;

close all;

%%
struct2table(oo_.irfs)

fieldnames(oo_.irfs)

struct2cell(oo_.irfs)


S = oo_.irfs;
fNames = fieldnames(S);
for n = 1:length(fNames)
    disp(S.(fNames{n}))
end

%%
subplot(2,2,1);
plot(pi_t_eps_i, 'r', 'LineWidth', 2.5);
title('Inflation', 'fontweight', 'bold');

subplot(2,2,2);
plot(xgap_t_eps_i, 'r', 'LineWidth', 2.5);
title('Output Gap', 'fontweight', 'bold');

subplot(2,2,3);
plot(int_t_eps_i, 'r', 'LineWidth', 2.5);
title('Nominal Interest Rate', 'fontweight', 'bold');

subplot(2,2,4);
plot(e_t_eps_i, 'r', 'LineWidth', 2.5);
title('Policy Shock', 'fontweight', 'bold');

%% check ss in logs
exp(-4.16524)*oo_.irfs.kT2_e1(2) + exp(-2.42005)*oo_.irfs.kT1_e1(2)
exp(-2.25911)*oo_.irfs.kT_e1(1)

