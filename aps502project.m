% read the datas
SPY = readmatrix('SPY.csv');
GOVT = readmatrix('GOVT.csv');
EEMV = readmatrix('EEMV.csv');
SPY2 = readmatrix('SPY_next.csv');
GOVT2 = readmatrix('GOVT_next.csv');
EEMV2 = readmatrix('EEMV_next.csv');

% calculate monthly return and expected return
SPY_close_1 = SPY(:, 6);
SPY_close_2 = SPY2(:, 6);
SPY_monthly_return = (SPY_close_2-SPY_close_1)./SPY_close_1;
SPY_expected_return = mean(SPY_monthly_return);

GOVT_close_1 = GOVT(:, 6);
GOTV_close_2 = GOVT2(:, 6);
GOVT_monthly_return = (GOTV_close_2-GOVT_close_1)./GOVT_close_1;
GOVT_expected_return = mean(GOVT_monthly_return);

EEMV_close_1 = EEMV(:, 6);
EEMV_close_2 = EEMV2(:, 6);
EEMV_monthly_return = (EEMV_close_2-EEMV_close_1)./EEMV_close_1;
EEMV_expected_return = mean(EEMV_monthly_return);

% calculate standard deviation & cov
cov_1_1 = ((SPY_monthly_return - SPY_expected_return).') * (SPY_monthly_return - SPY_expected_return);
cov_1_1 = cov_1_1 / size(SPY_monthly_return, 1);
std_1 = sqrt(cov_1_1);

cov_1_2 = ((SPY_monthly_return - SPY_expected_return).') * (GOVT_monthly_return - GOVT_expected_return);
cov_1_2 = cov_1_2 / size(SPY_monthly_return, 1);

cov_1_3 = ((SPY_monthly_return - SPY_expected_return).') * (EEMV_monthly_return - EEMV_expected_return);
cov_1_3 = cov_1_3 / size(SPY_monthly_return, 1);

cov_2_2 = ((GOVT_monthly_return - GOVT_expected_return).') * (GOVT_monthly_return - GOVT_expected_return);
cov_2_2 = cov_2_2 / size(GOVT_monthly_return, 1);
std_2 = sqrt(cov_2_2);

cov_2_3 = ((GOVT_monthly_return - GOVT_expected_return).') * (EEMV_monthly_return - EEMV_expected_return);
cov_2_3 = cov_2_3 / size(GOVT_monthly_return, 1);

cov_3_3 = ((EEMV_monthly_return - EEMV_expected_return).') * (EEMV_monthly_return - EEMV_expected_return);
cov_3_3 = cov_3_3 / size(EEMV_monthly_return, 1);
std_3 = sqrt(cov_3_3);

% calculate geometric expected return
g_SPY_return = 1;
g_GOVT_return = 1;
g_EEMV_return = 1;

for index = 1:72
    g_SPY_return = (1 + SPY_monthly_return(index,:)) * g_SPY_return;
    g_GOVT_return = (1 + GOVT_monthly_return(index,:)) * g_GOVT_return;
    g_EEMV_return = (1 + EEMV_monthly_return(index,:)) * g_EEMV_return;
end

g_SPY_return = g_SPY_return ^ (1/72) - 1;
g_GOVT_return = g_GOVT_return ^ (1/72) - 1;
g_EEMV_return = g_EEMV_return ^ (1/72) - 1;

Q = [cov_1_1, cov_1_2, cov_1_3;
     cov_1_2, cov_2_2, cov_2_3;
     cov_1_3, cov_2_3, cov_3_3];
c = [0, 0, 0]';
A = -[g_SPY_return, g_GOVT_return, g_EEMV_return];
port_return = -(0.01: 0.01: 0.1);
Aeq = [1 1 1];
beq = 1;
ub = [inf; inf; inf];
lb = [-inf; -inf; -inf];
x = zeros(3, 10);
port_cov = zeros(10, 1);


for index = 1:10
    [x(:,index), port_cov(index)] = quadprog(Q, c, A, port_return(index), Aeq, beq, lb, ub);
end

figure('Name','Efficient Frontier');
plot(port_cov, -port_return)
title('Efficient Frontier consisting of 3 assets');
xlabel('portfolio covariance');
ylabel('expected portfolio return');

% output print
fprintf('SPY arithmetic expected return is: %.4f\n', SPY_expected_return);
fprintf('SPY geometric expected return is: %.4f\n\n', g_SPY_return);
fprintf('GOVT arithmetic expected return is: %.4f\n', GOVT_expected_return);
fprintf('GOVT geometric expected return is: %.4f\n\n', g_GOVT_return);
fprintf('EEMV arithmetic expected return is: %.4f\n', EEMV_expected_return);
fprintf('EEMV geometric expected return is: %.4f\n\n', g_EEMV_return);

fprintf('SPY standard deviation is: %.4f\n', std_1);
fprintf('GOVT standard deviation is: %.4f\n', std_2);
fprintf('EEMV standard deviation is: %.4f\n\n', std_3);

fprintf('cov between SPY and GOVT is: %.4f\n', cov_1_2);
fprintf('cov between SPY and EEMV is: %.4f\n', cov_1_3);
fprintf('cov between GOVT and EEMV is: %.4f\n', cov_2_3);

fprintf('\nfirst column is the expected return, second is covariance, last three are weights of asset 1, 2 and 3');
table = [-port_return' port_cov x']

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% part 2 begins here
CME = readmatrix('CME.csv');
BR = readmatrix('BR.csv');
CBOE = readmatrix('CBOE.csv');
ICE = readmatrix('ICE.csv');
ACN = readmatrix('ACN.csv');
CME2 = readmatrix('CME_next.csv');
BR2 = readmatrix('BR_next.csv');
CBOE2 = readmatrix('CBOE_next.csv');
ICE2 = readmatrix('ICE_next.csv');
ACN2 = readmatrix('ACN_next.csv');

% calculate monthly return and expected return
CME_close_1 = CME(:, 6);
CME_close_2 = CME2(:, 6);
CME_monthly_return = (CME_close_2-CME_close_1)./CME_close_1;
CME_expected_return = mean(CME_monthly_return);

BR_close_1 = BR(:, 6);
BR_close_2 = BR2(:, 6);
BR_monthly_return = (BR_close_2-BR_close_1)./BR_close_1;
BR_expected_return = mean(BR_monthly_return);

CBOE_close_1 = CBOE(:, 6);
CBOE_close_2 = CBOE2(:, 6);
CBOE_monthly_return = (CBOE_close_2-CBOE_close_1)./CBOE_close_1;
CBOE_expected_return = mean(CBOE_monthly_return);

ICE_close_1 = ICE(:, 6);
ICE_close_2 = ICE2(:, 6);
ICE_monthly_return = (ICE_close_2-ICE_close_1)./ICE_close_1;
ICE_expected_return = mean(ICE_monthly_return);

ACN_close_1 = ACN(:, 6);
ACN_close_2 = ACN2(:, 6);
ACN_monthly_return = (ACN_close_2-ACN_close_1)./ACN_close_1;
ACN_expected_return = mean(ACN_monthly_return);

% calculate standard deviation & cov
cov_1_4 = ((SPY_monthly_return - SPY_expected_return).') * (CME_monthly_return - CME_expected_return);
cov_1_4 = cov_1_4 / size(SPY_monthly_return, 1);

cov_1_5 = ((SPY_monthly_return - SPY_expected_return).') * (BR_monthly_return - BR_expected_return);
cov_1_5 = cov_1_5 / size(SPY_monthly_return, 1);

cov_1_6 = ((SPY_monthly_return - SPY_expected_return).') * (CBOE_monthly_return - CBOE_expected_return);
cov_1_6 = cov_1_6 / size(SPY_monthly_return, 1);

cov_1_7 = ((SPY_monthly_return - SPY_expected_return).') * (ICE_monthly_return - ICE_expected_return);
cov_1_7 = cov_1_7 / size(SPY_monthly_return, 1);

cov_1_8 = ((SPY_monthly_return - SPY_expected_return).') * (ACN_monthly_return - ACN_expected_return);
cov_1_8 = cov_1_8 / size(SPY_monthly_return, 1);

cov_2_4 = ((GOVT_monthly_return - GOVT_expected_return).') * (CME_monthly_return - CME_expected_return);
cov_2_4 = cov_2_4 / size(GOVT_monthly_return, 1);

cov_2_5 = ((GOVT_monthly_return - GOVT_expected_return).') * (BR_monthly_return - BR_expected_return);
cov_2_5 = cov_2_5 / size(GOVT_monthly_return, 1);

cov_2_6 = ((GOVT_monthly_return - GOVT_expected_return).') * (CBOE_monthly_return - CBOE_expected_return);
cov_2_6 = cov_2_6 / size(GOVT_monthly_return, 1);

cov_2_7 = ((GOVT_monthly_return - GOVT_expected_return).') * (ICE_monthly_return - ICE_expected_return);
cov_2_7 = cov_2_7 / size(GOVT_monthly_return, 1);

cov_2_8 = ((GOVT_monthly_return - GOVT_expected_return).') * (ACN_monthly_return - ACN_expected_return);
cov_2_8 = cov_2_8 / size(GOVT_monthly_return, 1);

cov_3_4 = ((EEMV_monthly_return - EEMV_expected_return).') * (CME_monthly_return - CME_expected_return);
cov_3_4 = cov_3_4 / size(EEMV_monthly_return, 1);

cov_3_5 = ((EEMV_monthly_return - EEMV_expected_return).') * (BR_monthly_return - BR_expected_return);
cov_3_5 = cov_3_5 / size(EEMV_monthly_return, 1);

cov_3_6 = ((EEMV_monthly_return - EEMV_expected_return).') * (CBOE_monthly_return - CBOE_expected_return);
cov_3_6 = cov_3_6 / size(EEMV_monthly_return, 1);

cov_3_7 = ((EEMV_monthly_return - EEMV_expected_return).') * (ICE_monthly_return - ICE_expected_return);
cov_3_7 = cov_3_7 / size(EEMV_monthly_return, 1);

cov_3_8 = ((EEMV_monthly_return - EEMV_expected_return).') * (ACN_monthly_return - ACN_expected_return);
cov_3_8 = cov_3_8 / size(CME_monthly_return, 1);

cov_4_4 = ((CME_monthly_return - CME_expected_return).') * (CME_monthly_return - CME_expected_return);
cov_4_4 = cov_4_4 / size(CME_monthly_return, 1);
std_4 = sqrt(cov_4_4);

cov_4_5 = ((CME_monthly_return - CME_expected_return).') * (BR_monthly_return - BR_expected_return);
cov_4_5 = cov_4_5 / size(CME_monthly_return, 1);

cov_4_6 = ((CME_monthly_return - CME_expected_return).') * (CBOE_monthly_return - CBOE_expected_return);
cov_4_6 = cov_4_6 / size(CME_monthly_return, 1);

cov_4_7 = ((CME_monthly_return - CME_expected_return).') * (ICE_monthly_return - ICE_expected_return);
cov_4_7 = cov_4_7 / size(CME_monthly_return, 1);

cov_4_8 = ((CME_monthly_return - CME_expected_return).') * (ACN_monthly_return - ACN_expected_return);
cov_4_8 = cov_4_8 / size(CME_monthly_return, 1);

cov_5_5 = ((BR_monthly_return - BR_expected_return).') * (BR_monthly_return - BR_expected_return);
cov_5_5 = cov_5_5 / size(BR_monthly_return, 1);
std_5 = sqrt(cov_5_5);

cov_5_6 = ((BR_monthly_return - BR_expected_return).') * (CBOE_monthly_return - CBOE_expected_return);
cov_5_6 = cov_5_6 / size(BR_monthly_return, 1);

cov_5_7 = ((BR_monthly_return - BR_expected_return).') * (ICE_monthly_return - ICE_expected_return);
cov_5_7 = cov_5_7 / size(BR_monthly_return, 1);

cov_5_8 = ((BR_monthly_return - BR_expected_return).') * (ACN_monthly_return - ACN_expected_return);
cov_5_8 = cov_5_8 / size(BR_monthly_return, 1);

cov_6_6 = ((CBOE_monthly_return - CBOE_expected_return).') * (CBOE_monthly_return - CBOE_expected_return);
cov_6_6 = cov_6_6 / size(CBOE_monthly_return, 1);
std_6 = sqrt(cov_6_6);

cov_6_7 = ((CBOE_monthly_return - CBOE_expected_return).') * (ICE_monthly_return - ICE_expected_return);
cov_6_7 = cov_6_7 / size(CBOE_monthly_return, 1);

cov_6_8 = ((CBOE_monthly_return - CBOE_expected_return).') * (ACN_monthly_return - ACN_expected_return);
cov_6_8 = cov_6_8 / size(CBOE_monthly_return, 1);

cov_7_7 = ((ICE_monthly_return - ICE_expected_return).') * (ICE_monthly_return - ICE_expected_return);
cov_7_7 = cov_7_7 / size(ICE_monthly_return, 1);
std_7 = sqrt(cov_7_7);

cov_7_8 = ((ICE_monthly_return - ICE_expected_return).') * (ACN_monthly_return - ACN_expected_return);
cov_7_8 = cov_7_8 / size(ICE_monthly_return, 1);

cov_8_8 = ((ACN_monthly_return - ACN_expected_return).') * (ACN_monthly_return - ACN_expected_return);
cov_8_8 = cov_8_8 / size(ACN_monthly_return, 1);
std_8 = sqrt(cov_8_8);

% calculate geometric expected return
g_CME_return = 1;
g_BR_return = 1;
g_CBOE_return = 1;
g_ICE_return = 1;
g_ACN_return = 1;

for index = 1:72
    g_CME_return = (1 + CME_monthly_return(index,:)) * g_CME_return;
    g_BR_return = (1 + BR_monthly_return(index,:)) * g_BR_return;
    g_CBOE_return = (1 + CBOE_monthly_return(index,:)) * g_CBOE_return;
    g_ICE_return = (1 + ICE_monthly_return(index,:)) * g_ICE_return;
    g_ACN_return = (1 + ACN_monthly_return(index,:)) * g_ACN_return;
end

g_CME_return = g_CME_return ^ (1/72) - 1;
g_BR_return = g_BR_return ^ (1/72) - 1;
g_CBOE_return = g_CBOE_return ^ (1/72) - 1;
g_ICE_return = g_ICE_return ^ (1/72) - 1;
g_ACN_return = g_ACN_return ^ (1/72) - 1;

Q_2 = [cov_1_1, cov_1_2, cov_1_3, cov_1_4, cov_1_5, cov_1_6, cov_1_7, cov_1_8;
       cov_1_2, cov_2_2, cov_2_3, cov_2_4, cov_2_5, cov_2_6, cov_2_7, cov_2_8;
       cov_1_3, cov_2_3, cov_3_3, cov_3_4, cov_3_5, cov_3_6, cov_3_7, cov_3_8;
       cov_1_4, cov_2_4, cov_3_4, cov_4_4, cov_4_5, cov_4_6, cov_4_7, cov_4_8;
       cov_1_5, cov_2_5, cov_3_5, cov_4_5, cov_5_5, cov_5_6, cov_5_7, cov_5_8;
       cov_1_6, cov_2_6, cov_3_6, cov_4_6, cov_5_6, cov_6_6, cov_6_7, cov_6_8;
       cov_1_7, cov_2_7, cov_3_7, cov_4_7, cov_5_7, cov_6_7, cov_7_7, cov_7_8;
       cov_1_8, cov_2_8, cov_3_8, cov_4_8, cov_5_8, cov_6_8, cov_7_8, cov_8_8];
   
c_2 = [0, 0, 0, 0, 0, 0, 0, 0]';
A_2 = -[g_SPY_return, g_GOVT_return, g_EEMV_return, g_CME_return, g_BR_return, g_CBOE_return, g_ICE_return, g_ACN_return];
port_return_2 = -(0.01: 0.01: 0.1);
Aeq_2 = [1 1 1 1 1 1 1 1];
beq_2 = 1;
ub_2 = [inf; inf; inf; inf; inf; inf; inf; inf];
lb_2 = [-inf; -inf; -inf; -inf; -inf; -inf; -inf; -inf];
x_2 = zeros(8, 10);
port_cov_2 = zeros(10, 1);


for index = 1:10
    [x_2(:,index), port_cov_2(index)] = quadprog(Q_2, c_2, A_2, port_return_2(index), Aeq_2, beq_2, lb_2, ub_2);
end

figure('Name','Efficient Frontier');
plot(port_cov_2, -port_return_2)
title('Efficient Frontier consisting of 8 assets');
xlabel('portfolio covariance');
ylabel('expected portfolio return');

fprintf('\nfirst column is the expected return, second is covariance, last eight are weights of asset 1 to 8');
table_2 = [-port_return_2' port_cov_2 x_2']
