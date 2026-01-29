clc;
clear all;
close all;


%% Figure settings

paper_figs = true;
fontsize=25;
legendfontsize=24;
line_width=linspace(0.5,2.5,7);
set(groot,'defaultfigureposition',[400, 250, 1200, 400])
colors = {'#141d2e', '#334f83', '#7e95d4','#2e6233', '#70ab63', '#dbe69b', '#ded9ff', '#142716'};
load("tofino.mat");

%% DDE settings

% input values
G_1 = 5.0;
G_2 = 5.0;
S = 0.0;
history = [G_1; G_2; S];
max_t = 1440*100;
tspan = [0 max_t];
gamma_amp_input = 20;
gamma_period_input = 1440;
p1_amp_input = 10;
p1_period_input = 1440;
is_noisy_input = false;
delays = 5:55;
% generation of changing delta and gamma states
delta_list_input = create_delta_list(max_t, 4);
gamma_list_input = create_gamma_list(max_t, 1);

%% DDE solution

sol = dde_body(delays, history, tspan, ...
    gamma_amp_input, gamma_period_input, p1_amp_input, p1_period_input, is_noisy_input, ...
    delta_list_input, gamma_list_input);

%% Body distortion

% transition probabilities
trans_p_r_hand = 1 * 0.12 * 0.45 * 0.75 * 0.67 * 0.5;
trans_p_r_upperarm = 1 * 0.12 * 0.45 * 0.75 * 0.33;
trans_p_r_shoulder = 1 * 0.12 * 0.45 * 0.25;
trans_p_l_hand = 1 * 0.88 * 0.89 * 0.07 * 0.75 * 0.67 * 0.5;
trans_p_l_foot = 1 * 0.88 * 0.89 * 0.93 * 0.98 * 0.85 * 0.83 * 0.69 * 0.4 * 0.5 * 0.75 * 0.67 * 0.5;
% noise
snr_body = 30;
sol_original = sol.y;
sol.y = sol.y .* trans_p_r_hand;
sol_unnoisy = sol.y;
sol.y = awgn(sol.y,snr_body,'measured');

%% Signal plotting

start_day = find(sol.x>=1440,1); % throw away the first few hours because the dde has to settle in first

% the following figure shows the full simulation time, 
% in the paper, a zoomed in excerpt at 500 seconds is shown
figure;
hold on;
start_idx_day = 1;
end_idx_day = length(sol.y(1,:));
plot(sol.x(1,start_idx_day:end_idx_day)./60,sol.y(3,start_idx_day:end_idx_day), '-', 'Color', colors{1},'LineWidth',2)
plot(sol.x(1,start_idx_day:end_idx_day)./60,sol.y(1,start_idx_day:end_idx_day), '--', 'Color', colors{5},'LineWidth',2)
plot(sol.x(1,start_idx_day:end_idx_day)./60,sol.y(2,start_idx_day:end_idx_day), ':', 'Color', colors{3},'LineWidth',2)
box off
axis tight
xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex'; 
yaxisproperties= get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex'; 
set(gca, 'YGrid', 'on', 'XGrid', 'on')
set(gca,'linewidth',2)
set(gca,'FontSize',fontsize);
xlabel('Time [h]','interpreter','latex','FontSize',fontsize);
ylabel('Particle Levels ','interpreter','latex','FontSize',fontsize);
legend({['$S$'],['$G_2$'], ['$G_1$']},...
    'Location','northoutside','NumColumns',3,'Interpreter',"latex",'FontSize',legendfontsize)
legend boxoff;

%% Signal processing

vals = linspace(0,max_t, max_t+1);
idxs = dsearchn(sol.x(1,:)', vals(:));
signal_full = sol.y(3,idxs);

Fs = 1;                  
L = 1440*2;
signal_day = signal_full(1440+1:1440*3);
freq_day = fft(signal_day);
freq_shift = abs(fftshift(freq_day));

f_start = 1441;
L_2 = 24*60;
n_step_size = 60;
f_scale = Fs/L_2*(-L_2/2:(L_2/2-1)).*L_2;
f_response = zeros(max_t - f_start + 2, L_2/2 + 1);
n = 1;
while f_start < max_t
    signal_interval = signal_full(f_start - L_2:f_start);
    freq_interval = fft(signal_interval);
    freq_interval_shift = abs(fftshift(freq_interval));
    f_response(n,:) = freq_interval_shift(L_2/2+1:end);
    n = n + n_step_size;
    f_start = f_start + n_step_size;
end

% note: for me the following figure always opens to a view from below, 
% try flipping it upside down if you onyl see a black box
figure;
hold on;
h = surf(f_scale(L_2/2+1:L_2/2+91), (1440:n_step_size:max_t)./60, flip(f_response((1:n_step_size:end),1:91),1));
colormap(tofino);
box off
axis tight
xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex';
yaxisproperties= get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex';
zaxisproperties= get(gca, 'ZAxis');
zaxisproperties.TickLabelInterpreter = 'latex';
set(gca,'FontSize',fontsize);
xlabel('Frequency [1/day]','interpreter','latex');
ylabel('Time [h]','interpreter','latex');
zlabel('$S(j\omega)$','interpreter','latex');


%% Comparative evaluation

vals = linspace(0,max_t, max_t+1);
amp_sol = calc_amp_sol(max_t, gamma_list_input, delta_list_input);
amp_sol_original = amp_sol;
amp_sol = amp_sol .* trans_p_r_hand;
amp_sol_unnoisy = amp_sol;
amp_sol = awgn(amp_sol,snr_body,'measured');

% the following figure was not shown in the paper because there was not
% enough space,. unsomment it if you would like to see the detected number
% of S particles over time for AM

% figure;
% hold on;
% plot(vals./60,amp_sol, '-', 'Color', colors{1},'LineWidth',2)
% box off
% axis tight
% xaxisproperties= get(gca, 'XAxis');
% xaxisproperties.TickLabelInterpreter = 'latex';
% yaxisproperties= get(gca, 'YAxis');
% yaxisproperties.TickLabelInterpreter = 'latex';
% set(gca, 'YGrid', 'on', 'XGrid', 'on')
% set(gca,'linewidth',2)
% set(gca,'FontSize',fontsize);
% xlabel('Time [h]','interpreter','latex','FontSize',fontsize);
% ylabel('Particle Levels ','interpreter','latex','FontSize',fontsize);
% legend({['$S$']},...
%     'Location','northoutside','NumColumns',1,'Interpreter',"latex",'FontSize',legendfontsize)
% legend boxoff;

figure;
hold on;
plot(vals./60,delta_list_input, '-', 'Color', colors{4},'LineWidth',2)
plot(vals./60,gamma_list_input, '--', 'Color', colors{1},'LineWidth',2)
box off
axis tight
xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex';
yaxisproperties= get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex';
set(gca, 'YGrid', 'on', 'XGrid', 'on')
set(gca,'linewidth',2)
set(gca,'FontSize',fontsize);
xlabel('Time [h]','interpreter','latex','FontSize',fontsize);
ylabel('Implant State','interpreter','latex','FontSize',fontsize);
legend({['$\Delta$ State'], ['$\Gamma$ State'] },...
    'Location','northoutside','NumColumns',2,'Interpreter',"latex",'FontSize',legendfontsize)
legend boxoff;

% propagation to extremities
amp_sol_r_hand = awgn(amp_sol.*trans_p_r_hand,snr_body,'measured').*1;
amp_sol_l_hand = awgn(amp_sol.*trans_p_l_hand,snr_body,'measured').*1;
amp_sol_l_foot = awgn(amp_sol.*trans_p_l_foot,snr_body,'measured').*1;
sol_r_hand = awgn(sol_original(3,:).*trans_p_r_hand,snr_body,'measured');
sol_l_hand = awgn(sol_original(3,:).*trans_p_l_hand,snr_body,'measured');
sol_l_foot = awgn(sol_original(3,:).*trans_p_l_foot,snr_body,'measured');

% set example evaluation time 
% the chosen time shows both states changing
end_time = 408;
eval_l = 48*60;
end_idx_eval = end_time*60;
start_idx_eval = end_idx_eval - eval_l + 1;
fft_start_idx = find(sol.x>=(start_idx_eval),1);
fft_start_idx = fft_start_idx(1,1);
fft_end_idx = find(sol.x>=end_idx_eval,1);

max_amp_r_hand = max(amp_sol_r_hand(start_idx_eval:end_idx_eval));
max_amp_l_foot = max(amp_sol_l_foot(start_idx_eval:end_idx_eval));
max_amp = max([max_amp_l_foot; max_amp_r_hand]);
max_fre_r_hand = max(sol_r_hand(fft_start_idx:fft_end_idx));
max_fre_l_foot = max(sol_l_foot(fft_start_idx:fft_end_idx));
max_fre = max([max_fre_r_hand; max_fre_l_foot]);

figure;
hold on;
plot(vals(start_idx_eval:end_idx_eval)./60,amp_sol_r_hand(start_idx_eval:end_idx_eval)./max_amp, ':', 'Color', colors{5},'LineWidth',2)
plot(vals(start_idx_eval:end_idx_eval)./60,amp_sol_l_foot(start_idx_eval:end_idx_eval)./max_amp, '--', 'Color', colors{1},'LineWidth',2)
box off
axis tight
xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex';
yaxisproperties= get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex';
set(gca, 'YGrid', 'on', 'XGrid', 'on')
set(gca,'linewidth',2)
set(gca,'FontSize',fontsize);
xlim([end_time-48,end_time]);
ylim([0,1.1]);
xlabel('Time [h]','interpreter','latex','FontSize',fontsize);
ylabel('Normalized Particle Levels ','interpreter','latex','FontSize',fontsize);
legend({['AM signal at right hand'], ['AM signal at left foot']},...
    'Location','northoutside','NumColumns',2,'Interpreter',"latex",'FontSize',legendfontsize)
legend boxoff;

figure;
hold on;
plot(sol.x(1,fft_start_idx:fft_end_idx)./60,sol_r_hand(fft_start_idx:fft_end_idx)./max_fre, ':', 'Color', colors{5},'LineWidth',2)
plot(sol.x(1,fft_start_idx:fft_end_idx)./60,sol_l_foot(fft_start_idx:fft_end_idx)./max_fre, '--', 'Color', colors{1},'LineWidth',2)
box off
axis tight
xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex';
yaxisproperties= get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex';
set(gca, 'YGrid', 'on', 'XGrid', 'on')
set(gca,'linewidth',2)
set(gca,'FontSize',fontsize);
xlim([end_time-48,end_time]);
ylim([0,1.1]);
xlabel('Time [h]','interpreter','latex','FontSize',fontsize);
ylabel('Normalized Particle Levels ','interpreter','latex','FontSize',fontsize);
legend({['FM signal at right hand'], ['FM signal at left foot']},...
    'Location','northoutside','NumColumns',2,'Interpreter',"latex",'FontSize',legendfontsize)
legend boxoff;

% evaluation of received signal
sol_r_hand = sol_r_hand(1,idxs);
signal_interval_r_hand = sol_r_hand(end_idx_eval - L_2:end_idx_eval);
freq_interval_r_hand = fft(signal_interval_r_hand);
freq_interval_shift_r_hand = abs(fftshift(freq_interval_r_hand));
f_response_r_hand = freq_interval_shift_r_hand(L_2/2+1:end);

sol_l_hand = sol_l_hand(1,idxs);
signal_interval_l_hand = sol_l_hand(end_idx_eval - L_2:end_idx_eval);
freq_interval_l_hand = fft(signal_interval_l_hand);
freq_interval_shift_l_hand = abs(fftshift(freq_interval_l_hand));
f_response_l_hand = freq_interval_shift_l_hand(L_2/2+1:end);

sol_l_foot = sol_l_foot(1,idxs);
signal_interval_l_foot = sol_l_foot(end_idx_eval - L_2:end_idx_eval);
freq_interval_l_foot = fft(signal_interval_l_foot);
freq_interval_shift_l_foot = abs(fftshift(freq_interval_l_foot));
f_response_l_foot = freq_interval_shift_l_foot(L_2/2+1:end);

figure;
hold on;
plot(f_scale(L_2/2+1:L_2/2+41),f_response_r_hand(1:41), '--', 'Color', colors{5},'LineWidth',2)
plot(f_scale(L_2/2+1:L_2/2+41),f_response_l_foot(1:41), '--', 'Color', colors{1},'LineWidth',2)

first_end = 383 * 60;
signal_interval_r_hand = sol_r_hand(first_end - L_2:first_end);
freq_interval_r_hand = fft(signal_interval_r_hand);
freq_interval_shift_r_hand = abs(fftshift(freq_interval_r_hand));
f_response_r_hand = freq_interval_shift_r_hand(L_2/2+1:end);

signal_interval_l_hand = sol_l_hand(first_end - L_2:first_end);
freq_interval_l_hand = fft(signal_interval_l_hand);
freq_interval_shift_l_hand = abs(fftshift(freq_interval_l_hand));
f_response_l_hand = freq_interval_shift_l_hand(L_2/2+1:end);


signal_interval_l_foot = sol_l_foot(first_end - L_2:first_end);
freq_interval_l_foot = fft(signal_interval_l_foot);
freq_interval_shift_l_foot = abs(fftshift(freq_interval_l_foot));
f_response_l_foot = freq_interval_shift_l_foot(L_2/2+1:end);

plot(f_scale(L_2/2+1:L_2/2+41),f_response_r_hand(1:41), ':', 'Color', colors{5},'LineWidth',2)
plot(f_scale(L_2/2+1:L_2/2+41),f_response_l_foot(1:41), ':', 'Color', colors{1},'LineWidth',2)

box off
axis tight
xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex';
yaxisproperties= get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex';
set(gca, 'YGrid', 'on', 'XGrid', 'on')
set(gca,'linewidth',2)
set(gca,'FontSize',fontsize);
xlabel('Frequency [1/day]','interpreter','latex','FontSize',fontsize);
ylabel('$S(j\omega)$','interpreter','latex','FontSize',fontsize);
legend({['FM signal at right hand, t = 408'], ['FM signal at left foot, t = 408'],...
    ['FM signal at right hand, t = 384'], ['FM signal at left foot, t = 384']},...
    'Location','northoutside','NumColumns',2,'Interpreter',"latex",'FontSize',legendfontsize)
legend boxoff;

figure;
hold on;
plot(vals(start_idx_eval:end_idx_eval)./60,delta_list_input(start_idx_eval:end_idx_eval), '-', 'Color', colors{4},'LineWidth',2)
plot(vals(start_idx_eval:end_idx_eval)./60,gamma_list_input(start_idx_eval:end_idx_eval), '--', 'Color', colors{1},'LineWidth',2)
box off
axis tight
xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex';
yaxisproperties= get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex';
ylim([0;20]);
set(gca, 'YGrid', 'on', 'XGrid', 'on')
set(gca,'linewidth',2)
set(gca,'FontSize',fontsize);
xlabel('Time [h]','interpreter','latex','FontSize',fontsize);
ylabel('Implant State','interpreter','latex','FontSize',fontsize);
legend({['$\Delta$ State'], ['$\Gamma$ State'] },...
    'Location','northoutside','NumColumns',2,'Interpreter',"latex",'FontSize',legendfontsize)
legend boxoff;