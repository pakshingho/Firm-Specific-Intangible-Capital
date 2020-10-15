%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Collect IRFs values and plot them from DYNARE outputs. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear;

%% Generate IRFs from DYNARE (level-linearization)
dynare CD_v1 ;         % C-D
irfs_cd = oo_.irfs;
l1 = {irfs_cd};
%% Generate IRFs from DYNARE (log-linearization)
dynare CD_exp_v3 ;         % C-D
irfs_cd_exp = oo_.irfs;
l2 = {irfs_cd_exp};

%% level-linearization
close all
fig = figure;
subplot(2,2,1);
plot(-9:50, [zeros(1, 10), l1{1}.z1_e1], '-r', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l1{1}.z1_e1]) max([l1{1}.z1_e1])])
%xlabel('time');
title('Productivity Shock', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(2,2,2);
p1 = plot(-9:50, [zeros(1, 10), l1{1}.y1_e1], '-r', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l1{1}.y1_e1]) max([l1{1}.y1_e1])]);
%xlabel('time');
title('Output', 'fontweight', 'bold', 'FontSize', 14);
grid on
legend([p1], {'\theta_1=0.5'}, 'fontweight', 'bold', 'FontSize', 14, 'TextColor', 'black')
legend('boxoff')

subplot(2,2,3);
plot(-9:50, [zeros(1, 10), l1{1}.x_e1], '-r', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l1{1}.x_e1]) max([l1{1}.x_e1])]);
%xlabel('time');
title('Tangible Investment', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(2,2,4);
plot(-9:50, [zeros(1, 10), l1{1}.y2_e1], '-r', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l1{1}.y2_e1]) max([l1{1}.y2_e1])]);
%xlabel('time');
title('Intangible Investment', 'fontweight', 'bold', 'FontSize', 14);
grid on

han = axes(fig,'visible','off'); 
%han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Deviation','fontweight', 'bold','FontSize', 14);
xlabel(han,'Time','fontweight', 'bold','FontSize', 14);
%title(han,'yourTitle');

%% Generate IRFs from DYNARE (log-linearization)
close all
dynare CD_exp_v2 ;         % C-D post periods
irfs_cd_exp_post = oo_.irfs;

dynare CD_exp_v22 ;         % C-D pre 
irfs_cd_exp_pre = oo_.irfs;

l3 = {irfs_cd_exp_post, irfs_cd_exp_pre};
fig = figure;
subplot(2,2,1);
plot(-9:50, [zeros(1, 10), 100*l3{1}.z1_e1], '-xr', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), 100*l3{2}.z1_e1], '-b', 'LineWidth', 1);
xlim([-1 25]);
ylim([min([zeros(1, 60), 100*l3{1}.z1_e1, 100*l3{2}.z1_e1]) max([100*l3{1}.z1_e1, 100*l3{2}.z1_e1])])
%xlabel('time');
title('Productivity Shock', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(2,2,2);
p1 = plot(-9:50, [zeros(1, 10), 100*l3{1}.y1_e1], '-r', 'LineWidth', 1);
hold on 
p2 = plot(-9:50, [zeros(1, 10), 100*l3{2}.y1_e1], '-b', 'LineWidth', 1);
xlim([-1 25]);
ylim([min([zeros(1, 60), 100*l3{1}.y1_e1, 100*l3{2}.y1_e1]) max([100*l3{1}.y1_e1, 100*l3{2}.y1_e1])]);
%xlabel('time');
title('Output', 'fontweight', 'bold', 'FontSize', 14);
grid on
legend([p1, p2], {'post-periods', 'pre-periods'}, 'fontweight', 'bold', 'FontSize', 14, 'TextColor', 'black')
legend('boxoff')

subplot(2,2,3);
plot(-9:50, [zeros(1, 10), 100*l3{1}.x_e1], '-r', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), 100*l3{2}.x_e1], '-b', 'LineWidth', 1);
xlim([-1 25]);
ylim([min([zeros(1, 60), 100*l3{1}.x_e1, 100*l3{2}.x_e1]) max([100*l3{1}.x_e1, 100*l3{2}.x_e1])]);
%xlabel('time');
title('Tangible Investment', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(2,2,4);
plot(-9:50, [zeros(1, 10), 100*l3{1}.y2_e1], '-r', 'LineWidth', 1);
hold on 
plot(-9:50, [zeros(1, 10), 100*l3{2}.y2_e1], '-b', 'LineWidth', 1);
xlim([-1 25]);
ylim([min([zeros(1, 60), 100*l3{1}.y2_e1, 100*l3{2}.y2_e1]) max([100*l3{1}.y2_e1, 100*l3{2}.y2_e1])]);
%xlabel('time');
title('Intangible Investment', 'fontweight', 'bold', 'FontSize', 14);
grid on

han = axes(fig,'visible','off'); 
%han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'% Deviation','fontweight', 'bold','FontSize', 14);
xlabel(han,'Time','fontweight', 'bold','FontSize', 14);
%title(han,'yourTitle');

%% Generate IRFs from DYNARE (log-linearization, extreme cases)
close all;

dynare CD_exp_v2;
irfs_cd_exp = oo_.irfs;

dynare CD_exp_high_v2; 
irfs_high_exp = oo_.irfs;

dynare CD_exp_low_v2;
irfs_low_exp = oo_.irfs;

l4 = {irfs_cd_exp, irfs_high_exp, irfs_low_exp};

fig = figure;
subplot(2,2,1);
plot(-9:50, [zeros(1, 10), 100*l4{2}.z1_e1], '-b', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), 100*l4{3}.z1_e1], '-g', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), 100*l4{1}.z1_e1], '-r', 'LineWidth', 1);
xlim([-1 25]);
ylim([min([zeros(1, 60), 100*l4{1}.z1_e1, 100*l4{2}.z1_e1, 100*l4{3}.z1_e1]) max([100*l4{1}.z1_e1, 100*l4{2}.z1_e1, 100*l4{3}.z1_e1])])
%xlabel('time');
title('Productivity Shock', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(2,2,2);
p1 = plot(-9:50, [zeros(1, 10), 100*l4{1}.y1_e1], '-r', 'LineWidth', 1);
hold on
p2 = plot(-9:50, [zeros(1, 10), 100*l4{2}.y1_e1], '-b', 'LineWidth', 1);
hold on
p3 = plot(-9:50, [zeros(1, 10), 100*l4{3}.y1_e1], '-g', 'LineWidth', 1);
xlim([-1 25]);
ylim([min([zeros(1, 60), 100*l4{1}.y1_e1, 100*l4{2}.y1_e1, 100*l4{3}.y1_e1]) max([100*l4{1}.y1_e1, 100*l4{2}.y1_e1, 100*l4{3}.y1_e1])]);
%xlabel('time');
title('Output', 'fontweight', 'bold', 'FontSize', 14);
grid on
legend([p1, p2, p3], {'\theta_1=0.5', '\theta_1=0.7', '\theta_1=0.1'}, 'fontweight', 'bold', 'FontSize', 14, 'TextColor', 'black')
legend('boxoff')

subplot(2,2,3);
plot(-9:50, [zeros(1, 10), 100*l4{1}.x_e1], '-r', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), 100*l4{2}.x_e1], '-b', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), 100*l4{3}.x_e1], '-g', 'LineWidth', 1);
xlim([-1 25]);
ylim([min([zeros(1, 60), 100*l4{1}.x_e1, 100*l4{2}.x_e1, 100*l4{3}.x_e1]) max([100*l4{1}.x_e1, 100*l4{2}.x_e1, 100*l4{3}.x_e1])]);
%xlabel('time');
title('Tangible Investment', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(2,2,4);
plot(-9:50, [zeros(1, 10), 100*l4{1}.y2_e1], '-r', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), 100*l4{2}.y2_e1], '-b', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), 100*l4{3}.y2_e1], '-g', 'LineWidth', 1);
xlim([-1 25]);
ylim([min([zeros(1, 60), 100*l4{1}.y2_e1, 100*l4{2}.y2_e1, 100*l4{3}.y2_e1]) max([100*l4{1}.y2_e1, 100*l4{2}.y2_e1, 100*l4{3}.y2_e1])]);
%xlabel('time');
title('Intangible Investment', 'fontweight', 'bold', 'FontSize', 14);
grid on

han = axes(fig,'visible','off'); 
%han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'% Deviation','fontweight', 'bold','FontSize', 14);
xlabel(han,'Time','fontweight', 'bold','FontSize', 14);
%title(han,'yourTitle');