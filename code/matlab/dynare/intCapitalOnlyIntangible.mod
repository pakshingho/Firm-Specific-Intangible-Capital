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
y1 k1 l1
y2 k2 l2
kI
q

// Productivity shocks
z1 z2;

// 2. Exogenous variables

varexo

e1 e2;

// 3. Parameters

parameters

// Technology 1
lambda1 theta1 alpha1 gamma1 deltaT rho1 sigma1

// Technology 2
lambda2 theta2 alpha2 gamma2 deltaI rho2 sigma2

// Exogenous prices
ri r w

// Bond process
a c d;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------

// Technology 1
lambda1 = 1.1;
theta1  = 0;
alpha1  = 0.3;
gamma1  = 0.6;
deltaT  = 0.1;
rho1    = 0.95; 
sigma1  = 0.05;

// Technology 2
lambda2 = 0.9;
theta2  = 0;
alpha2  = 0.4;
gamma2  = 0.5;
deltaI  = 0.15;
rho2    = 0.9;
sigma2  = 0.1;

// Exogenous prices
ri      = 0.025;
r       = 0.03;
w       = 1;

// Bond process
a       = 0.02;
c       = 0.01;
d       = 0.2;


%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------

model;
    // 1. Production function 1
    y1     = k1 ^ alpha1 * (exp(z1) * l1) ^ gamma1;

    // 2. Production function 2
    y2     = k2 ^ alpha2 * (exp(z2) * l2) ^ gamma2;

    // 3. capital accumulation
    kI     = y2 + (1 - deltaI) * kI(-1);

    // 4. First order equation for k1
    alpha1 * (1 - theta1) * y1 / k1  = 
    q * alpha2 * (1 - theta2) * y2 / k2;    

    // 5. First order equation for kI
    q(+1) * ( (1 - deltaI) + alpha2 * (1 - theta2) * y2(+1) / k2(+1) ) = 
    (1 + ri) * q;

    // 6. First order equation for l1
    w      = gamma1 * y1 / l1;

    // 7. First order equation for l2
    w      = q * gamma2 * y2 / l2;

    // 8. Tangible and intangible capital identity
    kI(-1) = k1 + k2;

    // 9. exogenous processes
    z1     = rho1 * z1(-1) + e1;
    z2     = rho2 * z2(-1) + e2;

end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------

initval;
    z1 = 0;
    z2 = 0;
    l1  = 0.0443293;
    l2  = 0.00594081;
  
    kI = 0.104617;
    k1 = 0.0833954;
    k2 = kI - k1;

    y1  = k1 ^ alpha1 * (exp(z1) * l1) ^ gamma1;
    y2  = k2 ^ alpha2 * (exp(z2) * l2) ^ gamma2;
    //kI  = y2 / deltaI;

    q  = 0.757152;
end;

shocks;
var e1 = sigma1^2;
var e2 = sigma2^2;
end;

steady(maxit = 1000000);

stoch_simul(irf = 50, order = 1) y1 y2 k1 k2 kI l1 l2 z1 z2 q;