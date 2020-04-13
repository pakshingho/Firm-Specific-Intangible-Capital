%----------------------------------------------------------------
% CES tangible only version
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
kT1
kT2
kT
x
b

// Productivity shocks
z1;

// 2. Exogenous variables

varexo

e1;

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
theta1  = 1;
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
    k1 = ( theta1 * kT1 ^ ((lambda1 - 1) / lambda1) + (1 - theta1) * 0 ^ ((lambda1 - 1) / lambda1) ) ^ (lambda1 / (lambda1 - 1));
    
    // 2. Production function 2
    //y2     = k2 ^ alpha2 * (exp(z2) * l2) ^ gamma2;
    //k2 = ( theta2 * kT2 ^ ((lambda2 - 1) / lambda2) + (1 - theta2) * kI2 ^ ((lambda2 - 1) / lambda2) ) ^ (lambda2 / (lambda2 - 1));

    // 3. capital accumulation
    kT     = x + (1 - deltaT) * kT(-1);
    //kI     = y2 + (1 - deltaI) * kI(-1);
    //kI = 0;

    // 4. First order equation for kT1
    //alpha1 * theta1 * y1 / k1 * (k1 / kT1) ^ (1 / lambda1) = 
    //q * alpha2 * theta2 * y2 / k2 * (k2 / kT2) ^ (1 / lambda2);
    kT2    = 0;

    // 5. First order equation for kI1
    //alpha1 * (1 - theta1) * y1 / k1 * (k1 / kI1) ^ (1 / lambda1) = 
    //q * alpha2 * (1 - theta2) * y2 / k2 * (k2 / kI2) ^ (1 / lambda2);    
    //kI1    = 0;

    // 6. First order equation for kT
    alpha1 * theta1 * y1(+1) / k1(+1) * (k1(+1) / kT1(+1)) ^ (1 / lambda1) = ri + deltaT;

    // 7. First order equation for kI
    //q(+1) * ( (1 - deltaI) + alpha2 * (1 - theta2) * y2(+1) / k2(+1) * (k2(+1) / kI2(+1)) ^ (1 / lambda2) ) = 
    //(1 + ri) * q;
    //q    = 0;

    // 8. First order equation for l1
    w      = gamma1 * y1 / l1;

    // 9. First order equation for l2 (if q = 0, l2 -> 0)
    // w      = q * gamma2 * y2 / l2;
    //l2     = 0;
    
    // 10. First order equation for b

    (1 + ri) * (1 - 2 * a * (b - b(-1))) + 
                   (- (1 + r) + 2 * a * (b(+1) - b) - 2 * c * (b - d)) = 0;

    // 11. Tangible and intangible capital identity
    kT(-1) = kT1 + kT2;
    //kI(-1) = kI1 + kI2;

    // 11. exogenous processes
    z1     = rho1 * z1(-1) + e1;
    //z2     = rho2 * z2(-1) + e2;

end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------

initval;
    z1 = 0;
    //z2 = 0;
    l1  = 0.386981;
    //l2  = 0;
  
    kT = 1.54792;
    kT1 = kT;
    kT2 = kT - kT1;
    //kI = 0;
    //kI1 = 0;
    //kI2 = kI - kI1;

    x   = kT * deltaT;
    //y2  = kI * deltaI;

    k1  = ( theta1 * kT1 ^ ((lambda1 - 1) / lambda1) + (1 - theta1) * 0 ^ ((lambda1 - 1) / lambda1) ) ^ (lambda1 / (lambda1 - 1));
    y1  = k1 ^ alpha1 * (exp(z1) * l1) ^ gamma1;
    //k2  = ( theta2 * kT2 ^ ((lambda2 - 1) / lambda2) + (1 - theta2) * kI2 ^ ((lambda2 - 1) / lambda2) ) ^ (lambda2 / (lambda2 - 1));

    //q  = 0;
    b  =  -0.05;
end;

shocks;
var e1 = sigma1^2;
//var e2 = sigma2^2;
end;

steady(maxit = 1000000);

stoch_simul(irf = 50, order = 1);