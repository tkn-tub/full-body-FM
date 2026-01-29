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


%% DDE settings
% The calculation of the hormone rythmicallity was based on
% J. J. Walker, J. R. Terry, and S. L. Lightman, "Origin of Ultradian
% Pulsatility in the Hypothalamic–pituitary–adrenal Axis," Proceedings
% of the Royal Society of London B: Biological Sciences, vol. 277,
% no. 1688, pp. 1627–1633, Jun. 2010.

A = 10.0;
R = 10.0;
O = 0.0;
max_t = 1440*4;
tspan = [0 max_t];
delays = [30];
history = [A; R ; O];

%% DDE solution

sol = dde23(@ddefun_2,delays,history,tspan);
start_day = find(sol.x>=1440,1);
max_val = max(sol.y(3,start_day+1:start_day+start_day));

%% Plotting

figure;
hold on;
plot(sol.x(1,1:start_day)./60,sol.y(1,start_day+1:start_day+start_day)./max_val(1,1), '--', 'Color', colors{3},'LineWidth',2)
plot(sol.x(1,1:start_day)./60,sol.y(2,start_day+1:start_day+start_day)./max_val(1,1), ':', 'Color', colors{5},'LineWidth',2)
plot(sol.x(1,1:start_day)./60,sol.y(3,start_day+1:start_day+start_day)./max_val(1,1), '-', 'Color', colors{2},'LineWidth',2)
box off
axis tight
xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex'; % latex for x-axis
yaxisproperties= get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex'; % latex for y-axis
set(gca, 'YGrid', 'on', 'XGrid', 'on')
set(gca,'linewidth',2)
set(gca,'FontSize',fontsize);
xlabel('Time [h]','interpreter','latex');
ylabel('Hormone Levels ','interpreter','latex');
legend({['ACTH'], ['CRH'], ['CORT']},...
    'Location','northoutside','NumColumns',3,'Interpreter',"latex",'FontSize',legendfontsize)
legend boxoff;
