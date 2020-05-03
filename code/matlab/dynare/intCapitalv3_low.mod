%----------------------------------------------------------------
% CES version with both l1 l2 z1 z2
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
b
q

// Percentage deviations from steady state
y1_obs x_obs y2_obs

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
theta1  = 0.01;
alpha1  = 0.3;
gamma1  = 0.6;
deltaT  = 0.1;
rho1    = 0.95; 
sigma1  = 0.05;

// Technology 2
lambda2 = 0.9;
theta2  = 0.4;
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
    k1 = ( theta1 * kT1 ^ ((lambda1 - 1) / lambda1) + (1 - theta1) * kI1 ^ ((lambda1 - 1) / lambda1) ) ^ (lambda1 / (lambda1 - 1));
    
    // 2. Production function 2
    y2     = k2 ^ alpha2 * (exp(z2) * l2) ^ gamma2;
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

    // 8. First order equation for l1
    w      = gamma1 * y1 / l1;

    // 9. First order equation for l2
    w      = q * gamma2 * y2 / l2;
    
    // 10. First order equation for b

    (1 + ri) * (1 - 2 * a * (b - b(-1))) + 
                   (- (1 + r) + 2 * a * (b(+1) - b) - 2 * c * (b - d)) = 0;

    // 11. Tangible and intangible capital identity
    kT(-1) = kT1 + kT2;
    kI(-1) = kI1 + kI2;

    // 11. exogenous processes
    z1     = rho1 * z1(-1) + e1;
    z2     = rho2 * z2(-1) + e2;

    // Percentage deviations from steady state
    y1_obs = y1 - steady_state(y1);
    x_obs = x - steady_state(x);
    y2_obs = y2 - steady_state(y2);
end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------

initval;
    z1 = 0;
    z2 = 0;
    l1  = 0.138179;
    l2  = 0.036994;
  
    kT = 0.0989237;
    kT1 = 0.0036092;
    kT2 = kT - kT1;
    kI = 0.512478;
    kI1 = 0.407506;
    kI2 = kI - kI1;

    x   = kT * deltaT;
    y2  = kI * deltaI;

    k1  = ( theta1 * kT1 ^ ((lambda1 - 1) / lambda1) + (1 - theta1) * kI1 ^ ((lambda1 - 1) / lambda1) ) ^ (lambda1 / (lambda1 - 1));
    y1  = k1 ^ alpha1 * (exp(z1) * l1) ^ gamma1;
    k2  = ( theta2 * kT2 ^ ((lambda2 - 1) / lambda2) + (1 - theta2) * kI2 ^ ((lambda2 - 1) / lambda2) ) ^ (lambda2 / (lambda2 - 1));

    q  = 0.926244;
    b  =  -0.05;
end;

shocks;
var e1 = sigma1^2;
var e2 = sigma2^2;
end;

steady(maxit = 1000000);
//check;

//stoch_simul(irf = 50, order = 1);
stoch_simul(irf = 50, order = 1, nocorr, nofunctions, nomoments, nograph, nodisplay);