%----------------------------------------------------------------
% 0. Housekeeping
%----------------------------------------------------------------

close all;

%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

var y k kT kI IT II l z1;
varexo e1;

parameters lambda theta alpha gamma deltaT deltaI ri r w rho1 sigma1;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------
lambda = 1.1;
theta  = 0.5;
alpha   = 0.3;
gamma   = 0.6;
deltaT  = 0.1;
deltaI  = 0.15;
ri      = 0.025;
r       = 0.03;
w       = 1;
rho1    = 0.95; 
sigma1  = 0.05;

%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------

model;
    y     = k ^ alpha * (exp(z1) * l) ^ gamma;
    k = ( theta * kT(-1) ^ ((lambda - 1) / lambda) + (1 - theta) * kI(-1) ^ ((lambda - 1) / lambda) ) ^ (lambda / (lambda - 1));
    
    alpha * theta * y(+1) / k(+1) * (kT / k(+1)) ^ (- 1 / lambda) = ri + deltaT;
    alpha * (1 - theta) * y(+1) / k(+1) * (kI / k(+1)) ^ (- 1 / lambda) = ri + deltaI;
    IT = kT - (1 - deltaT) * kT(-1);
    II = kI - (1 - deltaI) * kI(-1);
    w = gamma * y / l;
    z1 = rho1 * z1(-1) + e1;
end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------

initval;
    kT  = 0.5;
    l  = 0.386981;
    kI = 0.5;
    z1 = 0;
    k = ( theta * kT ^ ((lambda - 1) / lambda) + (1 - theta) * kI ^ ((lambda - 1) / lambda) ) ^ (lambda / (lambda - 1));
    y = k ^ alpha * (exp(z1) * l) ^ gamma;
end;

shocks;
var e1 = sigma1^2;
end;

steady;

stoch_simul(irf = 50, order = 1);