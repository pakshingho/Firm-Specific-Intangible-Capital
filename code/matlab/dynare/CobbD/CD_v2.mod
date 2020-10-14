%----------------------------------------------------------------
% Cobb-Douglas version with both l1 l2 z1 z2 level-linearization
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
y1 k1 l1
kT1 kI1
y2 k2 l2
kT2 kI2
kT kI
x
q

// Productivity shocks
z1 z2;

// 2. Exogenous variables

varexo

e1 e2;

// 3. Parameters

parameters

// Technology 1
 theta1 alpha1 gamma1 deltaT rho1 sigma1

// Technology 2
 theta2 alpha2 gamma2 deltaI rho2 sigma2

// Exogenous prices
ri w;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------

// Technology 1
theta1  = 0.625;
alpha1  = 0.4;
gamma1  = 0.6;
deltaT  = 0.1;
rho1    = 0.95;
sigma1  = 0.01;

// Technology 2
theta2  = 0.6576;
alpha2  = 0.6373;
gamma2  = 0.31;
deltaI  = 0.158;
rho2    = 0.9;
sigma2  = 0.1;

// Exogenous prices
ri      = 0.04;
w       = 1;


%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------

model;
    // 1. Production function 1
    y1     = k1 ^ alpha1 * (exp(z1) * l1) ^ gamma1;
    k1 =  kT1 ^ theta1 * kI1 ^ (1 - theta1);
    
    // 2. Production function 2
    y2     = k2 ^ alpha2 * (exp(z2) * l2) ^ gamma2;
    k2 =  kT2 ^ theta2 * kI2 ^ (1 - theta2);
    
    // 3. capital accumulation
    kT     = x + (1 - deltaT) * kT(-1);
    kI     = y2 + (1 - deltaI) * kI(-1);

    // 4. First order equation for kT1
    alpha1 * theta1 * y1 / kT1 = 
    q * alpha2 * theta2 * y2 / kT2;

    // 5. First order equation for kI1
    alpha1 * (1 - theta1) * y1 / kI1 = 
    q * alpha2 * (1 - theta2) * y2 / kI2;

    // 6. First order equation for kT
    (1 - deltaT) + q(+1) * alpha2 * theta2 * y2(+1) / kT2(+1) =
    1 + ri;

    // 7. First order equation for kI
    q(+1) * ( (1 - deltaI) + alpha2 * (1 - theta2) * y2(+1) / kI2(+1) ) = 
    (1 + ri) * q;

    // 8. First order equation for l1
    w      = gamma1 * y1 / l1;

    // 9. First order equation for l2
    w      = q * gamma2 * y2 / l2;

    // 11. Tangible and intangible capital identity
    kT(-1) = kT1 + kT2;
    kI(-1) = kI1 + kI2;

    // 11. exogenous processes
    z1     = rho1 * z1(-1) + e1;
    z2     = rho2 * z2(-1) + e2;

end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------

initval;
    z1 = 0;
    z2 = 0;
    q  = 0.294577;
  
    kT = 3.56939e-06;
    kI = 5.00765e-06;
    kT1 = 2.84407e-06;
    kI1 = 4.0962e-06;

    kT2 = kT - kT1;
    kI2 = kI - kI1;

    x   = kT * deltaT;
    y2  = kI * deltaI;

    k1  = kT1 ^ theta1 * kI1 ^ (1 - theta1);
    l1  = (gamma1 * k1 ^ alpha1 / w)^(1/(1-gamma1));
    y1  = k1 ^ alpha1 * (exp(z1) * l1) ^ gamma1;
    k2  = kT2 ^ theta2 * kI2 ^ (1 - theta2);
    l2  = (q * gamma2 * k2 ^ alpha2 / w)^(1/(1-gamma2));

    
end;

shocks;
var e1 = sigma1^2;
var e2 = sigma2^2;
end;

//steady(maxit = 1000000);
steady(solve_algo=4);
//check;

stoch_simul(irf = 50, order = 1) y1;
//stoch_simul(irf = 50, order = 1, nocorr, nofunctions, nomoments, nograph, nodisplay);