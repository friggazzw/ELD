clear;
clc;
global penalty_coefficient Load Fuel_data pmin

%% Read the data
unit_data_10 = xlsread('10 unit.xlsx');
unit_data_40 = xlsread('40 unit.xlsx');
unit_data_80 = xlsread('80 unit.xlsx');
penalty_data = xlsread('penalty.xlsx');

%% Input parameters
UNIT = 80;      % input 10, 40, 80, which correspond to the respective units.

%% Initialization
if UNIT == 10
    pmin = unit_data_10(:,2)';
    pmax = unit_data_10(:,3)';
    Fuel_data = unit_data_10(:,4:8);
    Load = 2700;
    penalty = penalty_data(1,:);
end
if UNIT == 40
    pmin = unit_data_40(:,2)';
    pmax = unit_data_40(:,3)';
    Fuel_data = unit_data_40(:,4:8);
    Load = 10500;
    penalty = penalty_data(2,:);
end
if UNIT == 80
    pmin = unit_data_80(:,2)';
    pmax = unit_data_80(:,3)';
    Fuel_data = unit_data_80(:,4:8);
    Load = 21000;
    penalty = penalty_data(3,:);
end
popsize = 30;
maxgen =1000;
dim=size(pmin,2);
X=initialization(popsize,dim,pmax,pmin); 

%% Iteration
for Algorithm = 1:5   % 1 represents IPOA. 2 represents POA. 3 represents HHO. 4 represents SSA. 5 represents WOA.
    if Algorithm == 1
       penalty_coefficient = penalty(:,2);
       [IPOA_Best_score,IPOA_Best_pos,IPOA_curve]=IPOA(popsize,maxgen,pmin,pmax,dim,X);
    end
    if Algorithm == 2
       penalty_coefficient = penalty(:,3);
       [POA_Best_score,POA_Best_pos,POA_curve]=POA(popsize,maxgen,pmin,pmax,dim,X); 
    end
    if Algorithm == 3
       penalty_coefficient = penalty(:,4);
       [HHO_Best_score,HHO_Best_pos,HHO_curve]=HHO(popsize,maxgen,pmin,pmax,dim,X);
    end
    if Algorithm == 4
       penalty_coefficient = penalty(:,5);
       [SSA_Best_score,SSA_Best_pos,SSA_curve]=SSA(popsize,maxgen,pmin,pmax,dim,X); 
    end
    if Algorithm == 5
        penalty_coefficient = penalty(:,6);
       [WOA_Best_score,WOA_Best_pos,WOA_curve]=WOA(popsize,maxgen,pmin,pmax,dim,X); 
    end
end

%% Output result
display(['Optimal solution for IPOA: ', num2str(min(IPOA_Best_score))])
display(['Optimal output for IPOA: ', num2str(IPOA_Best_pos)])
display(['Optimal solution for POA: ', num2str(min(POA_Best_score))])
display(['Optimal output for POA: ', num2str(POA_Best_pos)])
display(['Optimal solution for HHO: ', num2str(min(HHO_Best_score))])
display(['Optimal output for HHO: ', num2str(HHO_Best_pos)])
display(['Optimal solution for SSA: ', num2str(min(SSA_Best_score))])
display(['Optimal output for SSA: ', num2str(SSA_Best_pos)])
display(['Optimal solution for WOA: ', num2str(min(WOA_Best_score))])
display(['Optimal output for WOA: ', num2str(WOA_Best_pos)])

%% Plot iteration curve
% Make them start from the same point
max_value = max([IPOA_curve(1), POA_curve(1), HHO_curve(1), SSA_curve(1), WOA_curve(1)]);
IPOA_curve(1) = max_value;
POA_curve(1) = max_value;
HHO_curve(1) = max_value;
SSA_curve(1) = max_value;
WOA_curve(1) = max_value;

% Plot
maker_idx = [1 2 5 10 20 50 100 200 500 900];
semilogx(IPOA_curve,'Color','r','linewidth',1.5,'LineStyle','-','marker','o','MarkerSize',7,'MarkerIndices',maker_idx)
hold on
semilogx(POA_curve,'Color','b','linewidth',1.5,'LineStyle','--','marker','+','MarkerSize',7,'MarkerIndices',maker_idx)
semilogx(HHO_curve,'Color','y','linewidth',1.5,'LineStyle','-','marker','*','MarkerSize',7,'MarkerIndices',maker_idx)
semilogx(SSA_curve,'Color','g','linewidth',1.5,'LineStyle','--','marker','d','MarkerSize',7,'MarkerIndices',maker_idx)
semilogx(WOA_curve,'Color','m','linewidth',1.5,'LineStyle','-','marker','v','MarkerSize',7,'MarkerIndices',maker_idx)

% Set labels
xlabel('Iterations');
ylabel('Cost');
axis tight
grid on
box on
legend('IPOA','POA','HHO','SSA','WOA')


