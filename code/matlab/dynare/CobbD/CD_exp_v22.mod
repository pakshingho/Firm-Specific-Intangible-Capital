%----------------------------------------------------------------
% Cobb-Douglas version with both l1 l2 z1 z2 log-linearization
% Matching income shares for pre periods.
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
theta1  = 0.65;
alpha1  = 0.4;
gamma1  = 0.6;
deltaT  = 0.1;
rho1    = 0.95;
sigma1  = 0.01;

// Technology 2
theta2  = 0.64;
alpha2  = 0.4;
gamma2  = 0.51;
deltaI  = 0.158;
rho2    = 0.9;
sigma2  = 0.1;

// Exogenous prices
ri      = 0.04;
w       = 1; % 0.72; % match q = 0.9


%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------

model;
    // 1. Production function 1
    exp(y1)     = exp(k1) ^ alpha1 * (exp(z1) * exp(l1)) ^ gamma1;
    exp(k1) =  exp(kT1) ^ theta1 * exp(kI1) ^ (1 - theta1);
    
    // 2. Production function 2
    exp(y2)     = exp(k2) ^ alpha2 * (exp(z2) * exp(l2)) ^ gamma2;
    exp(k2) =  exp(kT2) ^ theta2 * exp(kI2) ^ (1 - theta2);
    
    // 3. capital accumulation
    exp(kT)     = exp(x) + (1 - deltaT) * exp(kT(-1));
    exp(kI)     = exp(y2) + (1 - deltaI) * exp(kI(-1));

    // 4. First order equation for kT1
    alpha1 * theta1 * exp(y1) / exp(kT1) = 
    exp(q) * alpha2 * theta2 * exp(y2) / exp(kT2);

    // 5. First order equation for kI1
    alpha1 * (1 - theta1) * exp(y1) / exp(kI1) = 
    exp(q) * alpha2 * (1 - theta2) * exp(y2) / exp(kI2);

    // 6. First order equation for kT
    (1 - deltaT) + exp(q(+1)) * alpha2 * theta2 * exp(y2(+1)) / exp(kT2(+1)) =
    1 + ri;

    // 7. First order equation for kI
    exp(q(+1)) * ( (1 - deltaI) + alpha2 * (1 - theta2) * exp(y2(+1)) / exp(kI2(+1)) ) = 
    (1 + ri) * exp(q);

    // 8. First order equation for l1
    w      = gamma1 * exp(y1) / exp(l1);

    // 9. First order equation for l2
    w      = exp(q) * gamma2 * exp(y2) / exp(l2);

    // 11. Tangible and intangible capital identity
    exp(kT(-1)) = exp(kT1) + exp(kT2);
    exp(kI(-1)) = exp(kI1) + exp(kI2);

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
    l1  = log(0.0443293);
    l2  = log(0.00594081);
  
    kT = log(0.103943);
    kT1 = log(0.0886386);
    kT2 = log(exp(kT) - exp(kT1));
    kI = log(0.10527);
    kI1 = log(0.0836149);
    kI2 = log(exp(kI) - exp(kI1));

    x   = log(exp(kT) * deltaT);
    y2  = log(exp(kI) * deltaI);

    k1  = log(exp(kT1) ^ theta1 * exp(kI1) ^ (1 - theta1));
    y1  = log(exp(k1) ^ alpha1 * (exp(z1) * exp(l1)) ^ gamma1);
    k2  = log(exp(kT2) ^ theta2 * exp(kI2) ^ (1 - theta2));

    q  = log(0.757202);
end;

shocks;
var e1 = sigma1^2;
var e2 = sigma2^2;
end;

//steady(maxit = 1000000);
steady(solve_algo=4);
//check;

//stoch_simul(irf = 50, order = 1);
stoch_simul(irf = 50, order = 1, nocorr, nofunctions, nomoments, nograph, nodisplay);
//stoch_simul(irf = 50, order = 1, nocorr, nofunctions, nomoments) y1;