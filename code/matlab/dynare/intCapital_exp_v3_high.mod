%----------------------------------------------------------------
% CES exponential version with both l1 l2 z1 z2
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
//b
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
theta1  = 0.99;
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
    exp(y1)     = exp(k1) ^ alpha1 * (exp(z1) * exp(l1)) ^ gamma1;
    exp(k1) = ( theta1 * exp(kT1) ^ ((lambda1 - 1) / lambda1) + (1 - theta1) * exp(kI1) ^ ((lambda1 - 1) / lambda1) ) ^ (lambda1 / (lambda1 - 1));
    
    // 2. Production function 2
    exp(y2)     = exp(k2) ^ alpha2 * (exp(z2) * exp(l2)) ^ gamma2;
    exp(k2) = ( theta2 * exp(kT2) ^ ((lambda2 - 1) / lambda2) + (1 - theta2) * exp(kI2) ^ ((lambda2 - 1) / lambda2) ) ^ (lambda2 / (lambda2 - 1));
    
    // 3. capital accumulation
    exp(kT)     = exp(x) + (1 - deltaT) * exp(kT(-1));
    exp(kI)     = exp(y2) + (1 - deltaI) * exp(kI(-1));

    // 4. First order equation for kT1
    alpha1 * theta1 * exp(y1) / exp(k1) * (exp(k1) / exp(kT1)) ^ (1 / lambda1) = 
    exp(q) * alpha2 * theta2 * exp(y2) / exp(k2) * (exp(k2) / exp(kT2)) ^ (1 / lambda2);

    // 5. First order equation for kI1
    alpha1 * (1 - theta1) * exp(y1) / exp(k1) * (exp(k1) / exp(kI1)) ^ (1 / lambda1) = 
    exp(q) * alpha2 * (1 - theta2) * exp(y2) / exp(k2) * (exp(k2) / exp(kI2)) ^ (1 / lambda2);    

    // 6. First order equation for kT
    (1 - deltaT) + exp(q(+1)) * alpha2 * theta2 * exp(y2(+1)) / exp(k2(+1)) * (exp(k2(+1)) / exp(kT2(+1))) ^ (1 / lambda2) =
    1 + ri;

    // 7. First order equation for kI
    exp(q(+1)) * ( (1 - deltaI) + alpha2 * (1 - theta2) * exp(y2(+1)) / exp(k2(+1)) * (exp(k2(+1)) / exp(kI2(+1))) ^ (1 / lambda2) ) = 
    (1 + ri) * exp(q);

    // 8. First order equation for l1
    w      = gamma1 * exp(y1) / exp(l1);

    // 9. First order equation for l2
    w      = exp(q) * gamma2 * exp(y2) / exp(l2);
    
    // 10. First order equation for b

    //(1 + ri) * (1 - 2 * a * (exp(b) - exp(b(-1)))) + 
    //               (- (1 + r) + 2 * a * (exp(b(+1)) - exp(b)) - 2 * c * (exp(b) - d)) = 0;

    // 11. Tangible and intangible capital identity
    exp(kT(-1)) = exp(kT1) + exp(kT2);
    exp(kI(-1)) = exp(kI1) + exp(kI2);

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
    l1  = log(0.0443293);
    l2  = log(0.00594081);
  
    kT = log(0.104443);
    kT1 = log(0.088917);
    kT2 = log(exp(kT) - exp(kT1));
    kI = log(0.104617);
    kI1 = log(0.0833954);
    kI2 = log(exp(kI) - exp(kI1));

    x   = log(exp(kT) * deltaT);
    y2  = log(exp(kI) * deltaI);

    k1  = log( ( theta1 * exp(kT1) ^ ((lambda1 - 1) / lambda1) + (1 - theta1) * exp(kI1) ^ ((lambda1 - 1) / lambda1) ) ^ (lambda1 / (lambda1 - 1)) );
    y1  = log( exp(k1) ^ alpha1 * (exp(z1) * exp(l1)) ^ gamma1 );
    k2  = log( ( theta2 * exp(kT2) ^ ((lambda2 - 1) / lambda2) + (1 - theta2) * exp(kI2) ^ ((lambda2 - 1) / lambda2) ) ^ (lambda2 / (lambda2 - 1)) );

    q  = log(0.757152);
end;

shocks;
var e1 = sigma1^2;
var e2 = sigma2^2;
end;

steady(maxit = 1000000);
//check;

//stoch_simul(irf = 50, order = 1);
stoch_simul(irf = 50, order = 1, nocorr, nofunctions, nomoments, nograph, nodisplay);