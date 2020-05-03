%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Collect IRFs values and plot them from DYNARE outputs. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear;

%% Generate IRFs from DYNARE (level-linearization, corner cases)

dynare intCapitalv3;            % CES
irfs_ces = oo_.irfs;

dynare intCapitalv3_1 ;         % C-D
irfs_cd = oo_.irfs;

dynare tangibleCapitalOnly; 
irfs_tan = oo_.irfs;

dynare intangibleCapitalOnly;
irfs_int = oo_.irfs;


l2 = {irfs_ces, irfs_tan, irfs_int};
l3 = {irfs_ces, irfs_tan, irfs_int, irfs_cd};

close all;
%% Generate IRFs from DYNARE (level-linearization, extreme cases)

dynare intCapitalv3;            % CES
irfs_ces = oo_.irfs;

dynare intCapitalv3_high; 
irfs_high = oo_.irfs;

dynare intCapitalv3_low;
irfs_low = oo_.irfs;

l5 = {irfs_ces, irfs_high, irfs_low};

close all;

%% Generate IRFs from DYNARE (log-linearization, corner cases)

dynare intCapital_exp_v3;
irfs_ces_exp = oo_.irfs;

dynare tangibleCapitalOnly_exp; 
irfs_tan_exp = oo_.irfs;

dynare intangibleCapitalOnly_exp;
irfs_int_exp = oo_.irfs;

l1 = {irfs_ces_exp, irfs_tan_exp, irfs_int_exp};

close all;

%% Generate IRFs from DYNARE (log-linearization, extreme cases)

dynare intCapital_exp_v3;
irfs_ces_exp = oo_.irfs;

dynare intCapital_exp_v3_high; 
irfs_high_exp = oo_.irfs;

dynare intCapital_exp_v3_low;
irfs_low_exp = oo_.irfs;

l4 = {irfs_ces_exp, irfs_high_exp, irfs_low_exp};

close all;

%% log-level corner
close all
fig = figure;
subplot(2,2,1);
plot(-9:50, [zeros(1, 10), l1{2}.z1_e1], '-bo', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l1{3}.z1_e1], '-go', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l1{1}.z1_e1], '-ro', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l1{1}.z1_e1, l1{2}.z1_e1, l1{3}.z1_e1]) max([l1{1}.z1_e1, l1{2}.z1_e1, l1{3}.z1_e1])])
%xlabel('time');
title('Productivity Shock', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(2,2,2);
p1 = plot(-9:50, [zeros(1, 10), l1{1}.y1_e1], '-ro', 'LineWidth', 1);
hold on
p2 = plot(-9:50, [zeros(1, 10), l1{2}.y1_e1], '-bo', 'LineWidth', 1);
hold on
p3 = plot(-9:50, [zeros(1, 10), l1{3}.y1_e1], '-go', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l1{1}.y1_e1, l1{2}.y1_e1, l1{3}.y1_e1]) max([l1{1}.y1_e1, l1{2}.y1_e1, l1{3}.y1_e1])]);
%xlabel('time');
title('Output', 'fontweight', 'bold', 'FontSize', 14);
grid on
legend([p1, p2, p3], {'\theta_1=0.5', '\theta_1=1', '\theta_1=0'}, 'fontweight', 'bold', 'FontSize', 14, 'TextColor', 'black')
legend('boxoff')

subplot(2,2,3);
plot(-9:50, [zeros(1, 10), l1{1}.x_e1], '-ro', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l1{2}.x_e1], '-bo', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l1{3}.x_e1], '-go', 'LineWidth', 1);
xlim([-2 10]);
ylim([min([zeros(1, 60), l1{1}.x_e1, l1{2}.x_e1, l1{3}.x_e1, -0.1]) max([l1{1}.x_e1, l1{2}.x_e1, l1{3}.x_e1])]);
%xlabel('time');
title('Tangible Investment', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(2,2,4);
plot(-9:50, [zeros(1, 10), l1{1}.y2_e1], '-ro', 'LineWidth', 1);
hold on
%plot(-9:50, [zeros(1, 10), l1{2}.y2_e1], '-bo', 'LineWidth', 1);
%hold on
plot(-9:50, zeros(1, 60), '-bo', 'LineWidth', 1.5);
hold on
plot(-9:50, [zeros(1, 10), l1{3}.y2_e1], '-go', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l1{1}.y2_e1, zeros(1, 60), l1{3}.y2_e1]) max([l1{1}.y2_e1, zeros(1, 60), l1{3}.y2_e1])]);
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

%% log-level extreme cases
close all
fig = figure;
subplot(2,2,1);
plot(-9:50, [zeros(1, 10), l4{2}.z1_e1], '-bo', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l4{3}.z1_e1], '-go', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l4{1}.z1_e1], '-ro', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l4{1}.z1_e1, l4{2}.z1_e1, l4{3}.z1_e1]) max([l4{1}.z1_e1, l4{2}.z1_e1, l4{3}.z1_e1])])
%xlabel('time');
title('Productivity Shock', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(2,2,2);
p1 = plot(-9:50, [zeros(1, 10), l4{1}.y1_e1], '-ro', 'LineWidth', 1);
hold on
p2 = plot(-9:50, [zeros(1, 10), l4{2}.y1_e1], '-bo', 'LineWidth', 1);
hold on
p3 = plot(-9:50, [zeros(1, 10), l4{3}.y1_e1], '-go', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l4{1}.y1_e1, l4{2}.y1_e1, l4{3}.y1_e1]) max([l4{1}.y1_e1, l4{2}.y1_e1, l4{3}.y1_e1])]);
%xlabel('time');
title('Output', 'fontweight', 'bold', 'FontSize', 14);
grid on
legend([p1, p2, p3], {'\theta_1=0.5', '\theta_1=0.99', '\theta_1=0.01'}, 'fontweight', 'bold', 'FontSize', 14, 'TextColor', 'black')
legend('boxoff')

subplot(2,2,3);
plot(-9:50, [zeros(1, 10), l4{1}.x_e1], '-ro', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l4{2}.x_e1], '-bo', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l4{3}.x_e1], '-go', 'LineWidth', 1);
xlim([-2 10]);
ylim([min([zeros(1, 60), l4{1}.x_e1, l4{2}.x_e1, l4{3}.x_e1]) max([l4{1}.x_e1, l4{2}.x_e1, l4{3}.x_e1])]);
%xlabel('time');
title('Tangible Investment', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(2,2,4);
plot(-9:50, [zeros(1, 10), l4{1}.y2_e1], '-ro', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l4{2}.y2_e1], '-bo', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l4{3}.y2_e1], '-go', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l4{1}.y2_e1, l4{2}.y2_e1, l4{3}.y2_e1]) max([l4{1}.y2_e1, l4{2}.y2_e1, l4{3}.y2_e1])]);
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

%% level excl. c-d corner
close all
fig = figure;
subplot(2,2,1);
plot(-9:50, [zeros(1, 10), l2{2}.z1_e1], '-bo', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l2{3}.z1_e1], '-go', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l2{1}.z1_e1], '-ro', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l2{1}.z1_e1, l2{2}.z1_e1, l2{3}.z1_e1]) max([l2{1}.z1_e1, l2{2}.z1_e1, l2{3}.z1_e1])])
%xlabel('time');
title('Productivity Shock', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(2,2,2);
p1 = plot(-9:50, [zeros(1, 10), l2{1}.y1_e1], '-ro', 'LineWidth', 1);
hold on
p2 = plot(-9:50, [zeros(1, 10), l2{2}.y1_e1], '-bo', 'LineWidth', 1);
hold on
p3 = plot(-9:50, [zeros(1, 10), l2{3}.y1_e1], '-go', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l2{1}.y1_e1, l2{2}.y1_e1, l2{3}.y1_e1]) max([l2{1}.y1_e1, l2{2}.y1_e1, l2{3}.y1_e1])]);
%xlabel('time');
title('Output', 'fontweight', 'bold', 'FontSize', 14);
grid on
legend([p1, p2, p3], {'\theta_1=0.5', '\theta_1=1', '\theta_1=0'}, 'fontweight', 'bold', 'FontSize', 14, 'TextColor', 'black')
legend('boxoff')

subplot(2,2,3);
plot(-9:50, [zeros(1, 10), l2{1}.x_e1], '-ro', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l2{2}.x_e1], '-bo', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l2{3}.x_e1], '-go', 'LineWidth', 1);
xlim([-2 10]);
ylim([min([zeros(1, 60), l2{1}.x_e1, l2{2}.x_e1, l2{3}.x_e1, -0.1]) max([l2{1}.x_e1, l2{2}.x_e1, l2{3}.x_e1])]);
%xlabel('time');
title('Tangible Investment', 'fontweight', 'bold', 'FontSize', 14);
grid on

subplot(2,2,4);
plot(-9:50, [zeros(1, 10), l2{1}.y2_e1], '-ro', 'LineWidth', 1);
hold on
%plot(-9:50, [zeros(1, 10), l2{2}.y2_e1], '-bo', 'LineWidth', 1);
%hold on
plot(-9:50, zeros(1, 60), '-bo', 'LineWidth', 1.5);
hold on
plot(-9:50, [zeros(1, 10), l2{3}.y2_e1], '-go', 'LineWidth', 1);
xlim([-10 50]);
ylim([min([zeros(1, 60), l2{1}.y2_e1, zeros(1, 60), l2{3}.y2_e1]) max([l2{1}.y2_e1, zeros(1, 60), l2{3}.y2_e1])]);
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

%% level incl. c-d corner
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
legend([p1, p2, p3, p4], {'\theta_1=0.5', '\theta_1=1', '\theta_1=0', 'CD'}, 'FontSize', 14, 'TextColor', 'black')
legend('boxoff')

subplot(2,2,3);
plot(-9:50, [zeros(1, 10), l3{1}.x_e1], '-ro', 'LineWidth', 1.5);
hold on
plot(-9:50, [zeros(1, 10), l3{2}.x_e1], '-bo', 'LineWidth', 1.5);
hold on
plot(-9:50, [zeros(1, 10), l3{3}.x_e1], '-go', 'LineWidth', 1.5);
hold on
plot(-9:50, [zeros(1, 10), l3{4}.x_e1], '-kx', 'LineWidth', 1.5);
xlim([-2 10]);
ylim([min([zeros(1, 60), l3{1}.x_e1, l3{2}.x_e1, l3{3}.x_e1, l3{4}.x_e1, -0.1]) max([l3{1}.x_e1, l3{2}.x_e1, l3{3}.x_e1, l3{4}.x_e1])]);
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

%% level excl. c-d extreme
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
plot(-9:50, [zeros(1, 10), l5{1}.x_e1], '-ro', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{2}.x_e1], '-bo', 'LineWidth', 1);
hold on
plot(-9:50, [zeros(1, 10), l5{3}.x_e1], '-go', 'LineWidth', 1);
xlim([-2 10]);
ylim([min([zeros(1, 60), l5{1}.x_e1, l5{2}.x_e1, l5{3}.x_e1, -0.1]) max([l5{1}.x_e1, l5{2}.x_e1, l5{3}.x_e1])]);
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

%%
% struct2table(oo_.irfs)
% 
% fieldnames(oo_.irfs)
% 
% struct2cell(oo_.irfs)
% 
% 
% S = irfs_ces_exp;
% fNames = fieldnames(S);
% for n = 1:length(fNames)
%     disp(S.(fNames{n}))
% end
% 
% p.Color(4) = 0.25

%% check ss in logs
% exp(-4.16524)*oo_.irfs.kT2_e1(2) + exp(-2.42005)*oo_.irfs.kT1_e1(2)
% exp(-2.25911)*oo_.irfs.kT_e1(1)

