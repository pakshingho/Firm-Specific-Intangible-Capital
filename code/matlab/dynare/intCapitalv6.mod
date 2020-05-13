%----------------------------------------------------------------
% CES version with both l1 l2 z1 z2 sk sh
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
y1 k1 n1
sk sh
y2 k2 n2
k h
i
//b
q

// Productivity shocks
z1 z2;

// 2. Exogenous variables

varexo

e1 e2;

// 3. Parameters

parameters

// Technology 1
lambda1 theta1 alpha1 gamma1 deltaK rho1 sigma1

// Technology 2
lambda2 theta2 alpha2 gamma2 deltaH rho2 sigma2

// Exogenous prices
//r
ri w

// Bond process
//a c d
;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------

// Technology 1
lambda1 = 1.1;
theta1  = 0.5;
alpha1  = 0.3;
gamma1  = 0.6;
deltaK  = 0.1;
rho1    = 0.95; 
sigma1  = 0.05;

// Technology 2
lambda2 = 0.9;
theta2  = 0.4;
alpha2  = 0.4;
gamma2  = 0.5;
deltaH  = 0.15;
rho2    = 0.9;
sigma2  = 0.1;

// Exogenous prices
ri      = 0.025;
//r       = 0.03;
w       = 1;

// Bond process
//a       = 0.02;
//c       = 0.01;
//d       = 0.2;


%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------

model;
    // 1. Production function 1
    y1     = k1 ^ alpha1 * (exp(z1) * n1) ^ gamma1;
    k1 = ( theta1 * ( sk * k(-1) ) ^ ((lambda1 - 1) / lambda1) + (1 - theta1) * ( sh * h(-1) ) ^ ((lambda1 - 1) / lambda1) ) ^ (lambda1 / (lambda1 - 1));
    
    // 2. Production function 2
    y2     = k2 ^ alpha2 * (exp(z2) * n2) ^ gamma2;
    k2 = ( theta2 * ( (1 - sk ) * k(-1) ) ^ ((lambda2 - 1) / lambda2) + (1 - theta2) * ( (1 - sh ) * h(-1) ) ^ ((lambda2 - 1) / lambda2) ) ^ (lambda2 / (lambda2 - 1));
    
    // 3. capital accumulation
    k     = i + (1 - deltaK) * k(-1);
    h     = y2 + (1 - deltaH) * h(-1);

    // 4. First order equation for sk
    alpha1 * theta1 * y1 / k1 * (k1 / ( sk * k(-1) ) ) ^ (1 / lambda1) = 
    q * alpha2 * theta2 * y2 / k2 * (k2 / ( ( 1 - sk ) * k(-1) ) ) ^ (1 / lambda2);

    // 5. First order equation for sh
    alpha1 * (1 - theta1) * y1 / k1 * ( k1 / ( sh * h(-1) ) ) ^ (1 / lambda1) = 
    q * alpha2 * (1 - theta2) * y2 / k2 * ( k2 / ( ( 1 - sh ) * h(-1) ) ) ^ (1 / lambda2);    

    // 6. First order equation for k
    alpha1 * theta1 * y1(+1) / k1(+1) * ( k1(+1) / ( sk(+1) * k ) ) ^ (1 / lambda1) * sk(+1)
    + q(+1) * alpha2 * theta2 * y2(+1) / k2(+1) * ( k2(+1) / ( ( 1 - sk(+1) ) * k ) ) ^ (1 / lambda2) * ( 1 - sk(+1) )
    = ri + deltaK;

    //q(+1) * alpha2 * theta2 * y2(+1) / k2(+1) * ( k2(+1) / ( ( 1 - sk(+1) ) * k ) ) ^ (1 / lambda2)
    //= ri + deltaK;

    // 7. First order equation for h
    alpha1 * (1 - theta1) * y1(+1) / k1(+1) * ( k1(+1) / ( sh(+1) * h ) ) ^ (1 / lambda1) * sh(+1)
    + q(+1) * ( ( 1 - deltaH ) + alpha2 * (1 - theta2) * y2(+1) / k2(+1) * ( k2(+1) / ( ( 1 - sh(+1) ) * h ) ) ^ (1 / lambda2) * ( 1 - sh(+1) ) )
    = (1 + ri) * q;

    //q(+1) * ( ( 1 - deltaH ) + alpha2 * (1 - theta2) * y2(+1) / k2(+1) * ( k2(+1) / ( ( 1 - sh(+1) ) * h ) ) ^ (1 / lambda2) )
    //= (1 + ri) * q;

    // 8. First order equation for n1
    w      = gamma1 * y1 / n1;

    // 9. First order equation for n2
    w      = q * gamma2 * y2 / n2;
    
    // 10. First order equation for b
    //(1 + ri) * (1 - 2 * a * (b - b(-1))) + 
    //               (- (1 + r) + 2 * a * (b(+1) - b) - 2 * c * (b - d)) = 0;

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
    n1  = 0.0443293;
    n2  = 0.00594081;
  
    k = 0.104443;
    sk = 0.088917 / 0.104443;
    h = 0.104617;
    sh = 0.0833954 / 0.104617;

    i   = k * deltaK;
    y2  = h * deltaH;

    k1  = ( theta1 * ( sk * k ) ^ ((lambda1 - 1) / lambda1) + (1 - theta1) * ( sk * h ) ^ ((lambda1 - 1) / lambda1) ) ^ (lambda1 / (lambda1 - 1));
    y1  = k1 ^ alpha1 * (exp(z1) * n1) ^ gamma1;
    k2 = ( theta2 * ( (1 - sk ) * k ) ^ ((lambda2 - 1) / lambda2) + (1 - theta2) * ( (1 - sh ) * h ) ^ ((lambda2 - 1) / lambda2) ) ^ (lambda2 / (lambda2 - 1));
    q  = 0.757152;
    //b  =  -0.05;
end;

shocks;
var e1 = sigma1^2;
var e2 = sigma2^2;
end;

steady(maxit = 1000000);
//check;

//stoch_simul(irf = 50, order = 1);
stoch_simul(irf = 50, order = 1, nocorr, nofunctions, nomoments, nograph, nodisplay);