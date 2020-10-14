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

%% log-linearization
close all
fig = figure;
subplot(2,2,1);
plot(-9:50, [zeros(1, 10), 100*l2{1}.z1_e1], '-r', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), 100*l2{1}.z1_e1]) max([100*l2{1}.z1_e1])])
%xlabel('time');
title('Productivity Shock', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(2,2,2);
p1 = plot(-9:50, [zeros(1, 10), 100*l2{1}.y1_e1], '-r', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), 100*l2{1}.y1_e1]) max([100*l2{1}.y1_e1])]);
%xlabel('time');
title('Output', 'fontweight', 'bold', 'FontSize', 14);
grid on
legend([p1], {'\theta_1=0.5'}, 'fontweight', 'bold', 'FontSize', 14, 'TextColor', 'black')
legend('boxoff')

subplot(2,2,3);
plot(-9:50, [zeros(1, 10), 100*l2{1}.x_e1], '-r', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), 100*l2{1}.x_e1]) max([100*l2{1}.x_e1])]);
%xlabel('time');
title('Tangible Investment', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(2,2,4);
plot(-9:50, [zeros(1, 10), 100*l2{1}.y2_e1], '-r', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), 100*l2{1}.y2_e1]) max([100*l2{1}.y2_e1])]);
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