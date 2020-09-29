%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Collect GE IRFs values and plot them from DYNARE outputs. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear;

%% Generate IRFs from DYNARE (level-linearization, extreme cases)

dynare GE_CD_exp_v1;            % CD
irfs_cd = oo_.irfs;

dynare GE_CD_exp_v1_high; 
irfs_high = oo_.irfs;

dynare GE_CD_exp_v1_low;
irfs_low = oo_.irfs;

%dynare GE_exp_v1;            % CES
%irfs_ces = oo_.irfs;

dynare GE_CD_non_rival_exp_v1; % CD non rival intangible
irfs_nr = oo_.irfs;

l1 = {irfs_cd, irfs_nr};
l5 = {irfs_cd, irfs_high, irfs_low};
%l3 = {irfs_cd, irfs_high, irfs_low, irfs_ces};
close all;

%% level cd extreme
close all
fig = figure;
subplot(2,2,1);
plot(-9:50, [zeros(1, 10), l5{2}.z1_e1], '-bo', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{3}.z1_e1], '-go', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{1}.z1_e1], '-ro', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l5{1}.z1_e1, l5{2}.z1_e1, l5{3}.z1_e1]) max([l5{1}.z1_e1, l5{2}.z1_e1, l5{3}.z1_e1])])
%xlabel('time');
title('Productivity Shock', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(2,2,2);
p1 = plot(-9:50, [zeros(1, 10), l5{1}.y1_e1], '-ro', 'LineWidth', 1);
hold on
p2 = plot(-9:50, [zeros(1, 10), l5{2}.y1_e1], '-bo', 'LineWidth', 1);
hold on
p3 = plot(-9:50, [zeros(1, 10), l5{3}.y1_e1], '-go', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l5{1}.y1_e1, l5{2}.y1_e1, l5{3}.y1_e1]) max([l5{1}.y1_e1, l5{2}.y1_e1, l5{3}.y1_e1])]);
%xlabel('time');
title('Output', 'fontweight', 'bold', 'FontSize', 14);
grid on
legend([p1, p2, p3], {'\theta_1=0.5', '\theta_1=0.99', '\theta_1=0.01'}, 'fontweight', 'bold', 'FontSize', 14, 'TextColor', 'black')
legend('boxoff')

subplot(2,2,3);
plot(-9:50, [zeros(1, 10), l5{1}.i_e1], '-ro', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{2}.i_e1], '-bo', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{3}.i_e1], '-go', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l5{1}.i_e1, l5{2}.i_e1, l5{3}.i_e1]) max([l5{1}.i_e1, l5{2}.i_e1, l5{3}.i_e1])]);
%xlabel('time');
title('Tangible Investment', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(2,2,4);
plot(-9:50, [zeros(1, 10), l5{1}.y2_e1], '-ro', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{2}.y2_e1], '-bo', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{3}.y2_e1], '-go', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l5{1}.y2_e1, l5{2}.y2_e1, l5{3}.y2_e1]) max([l5{1}.y2_e1, l5{2}.y2_e1, l5{3}.y2_e1])]);
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

%% level cd extreme 3 x 3
close all
fig = figure;
subplot(3,3,1);
plot(-9:50, [zeros(1, 10), l5{2}.z1_e1], '-bo', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{3}.z1_e1], '-go', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{1}.z1_e1], '-ro', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l5{1}.z1_e1, l5{2}.z1_e1, l5{3}.z1_e1]) max([l5{1}.z1_e1, l5{2}.z1_e1, l5{3}.z1_e1])])
%xlabel('time');
title('Productivity Shock', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(3,3,2);
plot(-9:50, [zeros(1, 10), l5{1}.y1_e1], '-ro', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{2}.y1_e1], '-bo', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{3}.y1_e1], '-go', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l5{1}.y1_e1, l5{2}.y1_e1, l5{3}.y1_e1]) max([l5{1}.y1_e1, l5{2}.y1_e1, l5{3}.y1_e1])]);
%xlabel('time');
title('Output', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(3,3,3);
p1 = plot(-9:50, [zeros(1, 10), l5{1}.c_e1], '-ro', 'LineWidth', 1);
hold on
p2 = plot(-9:50, [zeros(1, 10), l5{2}.c_e1], '-bo', 'LineWidth', 1);
hold on
p3 = plot(-9:50, [zeros(1, 10), l5{3}.c_e1], '-go', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l5{1}.c_e1, l5{2}.c_e1, l5{3}.c_e1]) max([l5{1}.c_e1, l5{2}.c_e1, l5{3}.c_e1])]);
%xlabel('time');
title('Consumption', 'fontweight', 'bold', 'FontSize', 14);
grid on
legend([p1, p2, p3], {'\theta_1=0.5', '\theta_1=0.99', '\theta_1=0.01'}, 'fontweight', 'bold', 'FontSize', 14, 'TextColor', 'black')
legend('boxoff')

subplot(3,3,4);
plot(-9:50, [zeros(1, 10), l5{1}.i_e1], '-ro', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{2}.i_e1], '-bo', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{3}.i_e1], '-go', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l5{1}.i_e1, l5{2}.i_e1, l5{3}.i_e1]) max([l5{1}.i_e1, l5{2}.i_e1, l5{3}.i_e1])]);
%xlabel('time');
title('Tangible Investment', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(3,3,5);
plot(-9:50, [zeros(1, 10), l5{1}.y2_e1], '-ro', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{2}.y2_e1], '-bo', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{3}.y2_e1], '-go', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l5{1}.y2_e1, l5{2}.y2_e1, l5{3}.y2_e1]) max([l5{1}.y2_e1, l5{2}.y2_e1, l5{3}.y2_e1])]);
%xlabel('time');
title('Intangible Investment', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(3,3,6);
plot(-9:50, [zeros(1, 10), l5{1}.n_e1], '-ro', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{2}.n_e1], '-bo', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{3}.n_e1], '-go', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l5{1}.n_e1, l5{2}.n_e1, l5{3}.n_e1]) max([l5{1}.n_e1, l5{2}.n_e1, l5{3}.n_e1])]);
%xlabel('time');
title('Labor', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(3,3,7);
plot(-9:50, [zeros(1, 10), l5{1}.w_e1], '-ro', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{2}.w_e1], '-bo', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{3}.w_e1], '-go', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l5{1}.w_e1, l5{2}.w_e1, l5{3}.w_e1]) max([l5{1}.w_e1, l5{2}.w_e1, l5{3}.w_e1])]);
%xlabel('time');
title('Wage', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(3,3,8);
plot(-9:50, [zeros(1, 10), l5{1}.rk_e1], '-ro', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{2}.rk_e1], '-bo', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{3}.rk_e1], '-go', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l5{1}.rk_e1, l5{2}.rk_e1, l5{3}.rk_e1]) max([l5{1}.rk_e1, l5{2}.rk_e1, l5{3}.rk_e1])]);
%xlabel('time');
title('Capital Return', 'fontweight', 'bold', 'FontSize', 14);
grid on

han = axes(fig,'visible','off'); 
%han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Deviation','fontweight', 'bold','FontSize', 14);
xlabel(han,'Time','fontweight', 'bold','FontSize', 14);
%title(han,'yourTitle');

%% level cd extreme incl. ces
close all
fig = figure;
subplot(2,2,1);
plot(-9:50, [zeros(1, 10), l3{2}.z1_e1], '-bo', 'LineWidth', 1.5);
hold on
plot(-9:50, [zeros(1, 10), l3{3}.z1_e1], '-go', 'LineWidth', 1.5);
hold on
plot(-9:50, [zeros(1, 10), l3{4}.z1_e1], '-kx', 'LineWidth', 1.5);
hold on
plot(-9:50, [zeros(1, 10), l3{1}.z1_e1], '-ro', 'LineWidth', 1.5);
xlim([-10 50]);
ylim([min([zeros(1, 60), l3{1}.z1_e1, l3{2}.z1_e1, l3{3}.z1_e1]) max([l3{1}.z1_e1, l3{2}.z1_e1, l3{3}.z1_e1])])
%xlabel('time');
title('Productivity Shock', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(2,2,2);
p1 = plot(-9:50, [zeros(1, 10), l3{1}.y1_e1], '-ro', 'LineWidth', 1);
hold on
p2 = plot(-9:50, [zeros(1, 10), l3{2}.y1_e1], '-bo', 'LineWidth', 1);
hold on
p3 = plot(-9:50, [zeros(1, 10), l3{3}.y1_e1], '-go', 'LineWidth', 1);
hold on
p4 = plot(-9:50, [zeros(1, 10), l3{4}.y1_e1], '-kx', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l3{1}.y1_e1, l3{2}.y1_e1, l3{3}.y1_e1, l3{4}.y1_e1]) max([l3{1}.y1_e1, l3{2}.y1_e1, l3{3}.y1_e1, l3{4}.y1_e1])]);
%xlabel('time');
title('Output', 'fontweight', 'bold', 'FontSize', 14);
grid on
legend([p1, p2, p3, p4], {'\theta_1=0.5', '\theta_1=1', '\theta_1=0', 'CES'}, 'FontSize', 14, 'TextColor', 'black')
legend('boxoff')

subplot(2,2,3);
plot(-9:50, [zeros(1, 10), l3{1}.i_e1], '-ro', 'LineWidth', 1.5);
hold on
plot(-9:50, [zeros(1, 10), l3{2}.i_e1], '-bo', 'LineWidth', 1.5);
hold on
plot(-9:50, [zeros(1, 10), l3{3}.i_e1], '-go', 'LineWidth', 1.5);
hold on
plot(-9:50, [zeros(1, 10), l3{4}.i_e1], '-kx', 'LineWidth', 1.5);
xlim([-10 50]);
ylim([min([zeros(1, 60), l3{1}.i_e1, l3{2}.i_e1, l3{3}.i_e1, l3{4}.i_e1]) max([l3{1}.i_e1, l3{2}.i_e1, l3{3}.i_e1, l3{4}.i_e1])]);
%xlabel('time');
title('Tangible Investment', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(2,2,4);
plot(-9:50, [zeros(1, 10), l3{1}.y2_e1], '-ro', 'LineWidth', 1);
hold on
%plot(-9:50, [zeros(1, 10), l3{2}.y2_e1], '-bo', 'LineWidth', 1);
%hold on
plot(-9:50, zeros(1, 60), '-bo', 'LineWidth', 1.5);
hold on
plot(-9:50, [zeros(1, 10), l3{3}.y2_e1], '-go', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l3{4}.y2_e1], '-kx', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l3{1}.y2_e1, zeros(1, 60), l3{3}.y2_e1, l3{4}.y2_e1]) max([l3{1}.y2_e1, zeros(1, 60), l3{3}.y2_e1, l3{4}.y2_e1])]);
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

%% level cd vs cd non-rival 3 x 3
close all
fig = figure;
subplot(3,3,1);
plot(-9:50, [zeros(1, 10), l1{2}.z1_e1], '-bo', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l1{1}.z1_e1], '-ro', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l1{1}.z1_e1, l1{2}.z1_e1]) max([l1{1}.z1_e1, l1{2}.z1_e1])])
%xlabel('time');
title('Productivity Shock', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(3,3,2);
plot(-9:50, [zeros(1, 10), l1{1}.y1_e1], '-ro', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l1{2}.y1_e1], '-bo', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l1{1}.y1_e1, l1{2}.y1_e1]) max([l1{1}.y1_e1, l1{2}.y1_e1])]);
%xlabel('time');
title('Output', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(3,3,3);
p1 = plot(-9:50, [zeros(1, 10), l1{1}.c_e1], '-ro', 'LineWidth', 1);
hold on
p2 = plot(-9:50, [zeros(1, 10), l1{2}.c_e1], '-bo', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l1{1}.c_e1, l1{2}.c_e1]) max([l1{1}.c_e1, l1{2}.c_e1])]);
%xlabel('time');
title('Consumption', 'fontweight', 'bold', 'FontSize', 14);
grid on
legend([p1, p2], {'Rival', 'Non-rival'}, 'fontweight', 'bold', 'FontSize', 14, 'TextColor', 'black')
legend('boxoff')

subplot(3,3,4);
plot(-9:50, [zeros(1, 10), l1{1}.i_e1], '-ro', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l1{2}.i_e1], '-bo', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l1{1}.i_e1, l1{2}.i_e1]) max([l1{1}.i_e1, l1{2}.i_e1])]);
%xlabel('time');
title('Tangible Investment', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(3,3,5);
plot(-9:50, [zeros(1, 10), l1{1}.y2_e1], '-ro', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l1{2}.y2_e1], '-bo', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l1{1}.y2_e1, l1{2}.y2_e1]) max([l1{1}.y2_e1, l1{2}.y2_e1])]);
%xlabel('time');
title('Intangible Investment', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(3,3,6);
plot(-9:50, [zeros(1, 10), l1{1}.n_e1], '-ro', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l1{2}.n_e1], '-bo', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l1{1}.n_e1, l1{2}.n_e1]) max([l1{1}.n_e1, l1{2}.n_e1])]);
%xlabel('time');
title('Labor', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(3,3,7);
plot(-9:50, [zeros(1, 10), l1{1}.w_e1], '-ro', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l1{2}.w_e1], '-bo', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l1{1}.w_e1, l1{2}.w_e1]) max([l1{1}.w_e1, l1{2}.w_e1])]);
%xlabel('time');
title('Wage', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(3,3,8);
plot(-9:50, [zeros(1, 10), l1{1}.rk_e1], '-ro', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l1{2}.rk_e1], '-bo', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l1{1}.rk_e1, l1{2}.rk_e1]) max([l1{1}.rk_e1, l1{2}.rk_e1])]);
%xlabel('time');
title('Capital Return', 'fontweight', 'bold', 'FontSize', 14);
grid on

han = axes(fig,'visible','off'); 
%han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Deviation','fontweight', 'bold','FontSize', 14);
xlabel(han,'Time','fontweight', 'bold','FontSize', 14);
%title(han,'yourTitle');