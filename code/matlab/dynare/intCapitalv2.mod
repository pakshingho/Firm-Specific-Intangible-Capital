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
b
mu

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
theta1  = 0.5;
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
    
    // 3. Intangible capital accumulation
    kI     = y2 + (1 - deltaI) * kI(-1);

    // 4. First order equation for kT1
    alpha1 * theta1 * y1 / k1 * (kT1 / k1) ^ (- 1 / lambda1) = 
    mu * alpha2 * theta2 * y2 / k2 * (kT2 / k2) ^ (- 1 / lambda2);

    // 5. First order equation for kI1
    alpha1 * (1 - theta1) * y1 / k1 * (kI1 / k1) ^ (- 1 / lambda1) = 
    mu * alpha2 * (1 - theta2) * y2 / k2 * (kI2 / k2) ^ (- 1 / lambda2);    

    // 6. First order equation for kT
    (1 - deltaT) + mu(+1) * alpha2 * theta2 * y2(+1) / k2(+1) * (kT2(+1) / k2(+1)) ^ (- 1 / lambda2) =
    1 + ri;

    // 7. First order equation for kI
    mu(+1) * ( (1 - deltaI) + alpha2 * (1 - theta2) * y2(+1) / k2(+1) * (kI2(+1) / k2(+1)) ^ (- 1 / lambda2) ) = 
    (1 + ri) * mu;

    // 8. First order equation for l1
    w      = gamma1 * y1 / l1;

    // 9. First order equation for l2
    w      = mu * gamma2 * y2 / l2;
    
    // 10. First order equation for b

    (1 + ri) * (1 - 2 * a * (b - b(-1))) + 
                   (- (1 + r) + 2 * a * (b(+1) - b) - 2 * c * (b - d)) = 0;

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
    l1  = 0.0443293;
    l2  = 0.00594081;
  
    kT = 0.104443;
    kT1 = 0.088917;
    kT2 = kT - kT1;
    kI = 0.104617;
    kI1 = 0.0833954;
    kI2 = kI - kI1;

    k1  = ( theta1 * kT1 ^ ((lambda1 - 1) / lambda1) + (1 - theta1) * kI1 ^ ((lambda1 - 1) / lambda1) ) ^ (lambda1 / (lambda1 - 1));
    y1  = k1 ^ alpha1 * (exp(z1) * l1) ^ gamma1;
    k2  = ( theta2 * kT2 ^ ((lambda2 - 1) / lambda2) + (1 - theta2) * kI2 ^ ((lambda2 - 1) / lambda2) ) ^ (lambda2 / (lambda2 - 1));
    y2  = k2 ^ alpha2 * (exp(z2) * l2) ^ gamma2;
    //kI  = y2 / deltaI;

    mu  = 0.757152;
    b  =  -0.05;
end;

shocks;
var e1 = sigma1^2;
var e2 = sigma2^2;
end;

steady(maxit = 1000000);

stoch_simul(irf = 50, order = 1);