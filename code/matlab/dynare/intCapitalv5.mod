%----------------------------------------------------------------
% CES version without l1 l2 z2 and 
% alpha1 = alpha1/(1-gamma1), alpha2 = alpha2/(1-gamma2)
%----------------------------------------------------------------

%----------------------------------------------------------------
% 0. Housekeeping
%----------------------------------------------------------------

close all;

%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

// 1. Endogenous variables

var

// Allocation variables 
y1 k1
kT1 kI1
y2 k2
kT2 kI2
kT kI
x
q

// Productivity shocks
z1;

// 2. Exogenous variables

varexo

e1;

// 3. Parameters

parameters

// Technology 1
lambda1 theta1 alpha1 deltaT rho1 sigma1

// Technology 2
lambda2 theta2 alpha2 deltaI

// Exogenous prices
ri;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------

// Technology 1
lambda1 = 1.1;
theta1  = 0.5;
alpha1  = 0.3/0.4;
deltaT  = 0.1;
rho1    = 0.95; 
sigma1  = 0.05;

// Technology 2
lambda2 = 0.9;
theta2  = 0.4;
alpha2  = 0.4/0.5;
deltaI  = 0.15;

// Exogenous prices
ri      = 0.025;

%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------

model;
    // 1. Production function 1
    y1     = k1 ^ alpha1 * exp(z1);
    k1 = ( theta1 * kT1 ^ ((lambda1 - 1) / lambda1) + (1 - theta1) * kI1 ^ ((lambda1 - 1) / lambda1) ) ^ (lambda1 / (lambda1 - 1));
    
    // 2. Production function 2
    y2     = k2 ^ alpha2;
    k2 = ( theta2 * kT2 ^ ((lambda2 - 1) / lambda2) + (1 - theta2) * kI2 ^ ((lambda2 - 1) / lambda2) ) ^ (lambda2 / (lambda2 - 1));
    
    // 3. capital accumulation
    kT     = x + (1 - deltaT) * kT(-1);
    kI     = y2 + (1 - deltaI) * kI(-1);

    // 4. First order equation for kT1
    alpha1 * theta1 * y1 / k1 * (k1 / kT1) ^ (1 / lambda1) = 
    q * alpha2 * theta2 * y2 / k2 * (k2 / kT2) ^ (1 / lambda2);

    // 5. First order equation for kI1
    alpha1 * (1 - theta1) * y1 / k1 * (k1 / kI1) ^ (1 / lambda1) = 
    q * alpha2 * (1 - theta2) * y2 / k2 * (k2 / kI2) ^ (1 / lambda2);    

    // 6. First order equation for kT
    (1 - deltaT) + q(+1) * alpha2 * theta2 * y2(+1) / k2(+1) * (k2(+1) / kT2(+1)) ^ (1 / lambda2) =
    1 + ri;

    // 7. First order equation for kI
    q(+1) * ( (1 - deltaI) + alpha2 * (1 - theta2) * y2(+1) / k2(+1) * (k2(+1) / kI2(+1)) ^ (1 / lambda2) ) = 
    (1 + ri) * q;

    // 11. Tangible and intangible capital identity
    kT(-1) = kT1 + kT2;
    kI(-1) = kI1 + kI2;

    // 11. exogenous processes
    z1     = rho1 * z1(-1) + e1;

end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------

initval;
    z1 = 0;
  
    kT = 1.84243;
    kT1 = 1.53079;
    kT2 = kT - kT1;
    kI = 5.59627;
    kI1 = 4.50973;
    kI2 = kI - kI1;
    
    x   = kT * deltaT;
    y2  = kI * deltaI;

    k1  = ( theta1 * kT1 ^ ((lambda1 - 1) / lambda1) + (1 - theta1) * kI1 ^ ((lambda1 - 1) / lambda1) ) ^ (lambda1 / (lambda1 - 1));
    y1  = k1 ^ alpha1 * exp(z1);
    k2  = ( theta2 * kT2 ^ ((lambda2 - 1) / lambda2) + (1 - theta2) * kI2 ^ ((lambda2 - 1) / lambda2) ) ^ (lambda2 / (lambda2 - 1));
    y2  = k2 ^ alpha2;

    q  = 0.267483;
end;

shocks;
var e1 = sigma1^2;
end;

steady(maxit = 1000000);

stoch_simul(irf = 25, order = 1) y1 x y2 k1 k2 kT kT1 kT2 kI kI1 kI2 z1 q;