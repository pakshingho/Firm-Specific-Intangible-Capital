%----------------------------------------------------------------
% GE Cobb-Douglas version with both n1 n2 z1 z2 sk sh (shares)
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

// Household
c n

// Firm
y1 k1 n1
sk sh
y2 k2 n2
k h
i
profit dividend

// Prices
q rf rk w sdf

// Productivity shocks
z1 z2;

// 2. Exogenous variables

varexo

e1 e2;

// 3. Parameters

parameters
// Preference
bbeta cchi l_ss

// Technology 1
theta1 alpha1 gamma1 deltaK rho1 sigma1

// Technology 2
theta2 alpha2 gamma2 deltaH rho2 sigma2
;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------
// Preferences 
bbeta   	= 0.99;
n_ss 		= 1 / 3;
cchi        = 1.75;

// Technology 1
theta1  = 0.5;
alpha1  = 0.3;
gamma1  = 0.6;
deltaK  = 0.1;
rho1    = 0.95; 
sigma1  = 0.05;

// Technology 2
theta2  = 0.4;
alpha2  = 0.4;
gamma2  = 0.5;
deltaH  = 0.15;
rho2    = 0.9;
sigma2  = 0.1;

%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------
model;

    // 1. Define SDF (sdf is at time t,t+1)
    exp(sdf) = bbeta * exp(c) / exp(c(+1));

	// 2. Euler equation for capital
	1		= exp(sdf) * (1 + rf);
	
	// 3. First order equation for labor-leisure
	exp(w)   	= cchi * exp(c) / (1 - exp(n));

    // 4. Production function 1
    exp(y1)     = exp(k1) ^ alpha1 * (exp(z1) * exp(n1)) ^ gamma1;
    exp(k1) = ( sk * exp(k(-1)) ) ^ theta1 * ( sh * exp(h(-1)) ) ^ (1 - theta1);
    
    // 5. Production function 2
    exp(y2)     = exp(k2) ^ alpha2 * (exp(z2) * exp(n2)) ^ gamma2;
    exp(k2) = ( (1 - sk ) * exp(k(-1)) ) ^ theta2 * ( (1 - sh ) * exp(h(-1)) ) ^ (1 - theta2);
    
    // 6. capital accumulation
    exp(k)     = exp(i) + (1 - deltaK) * exp(k(-1));
    exp(h)     = exp(y2) + (1 - deltaH) * exp(h(-1));

    // 7. First order equation for sk
    alpha1 * theta1 * exp(y1) / ( sk * exp(k(-1)) )  = 
    exp(q) * alpha2 * theta2 * exp(y2) / ( ( 1 - sk ) * exp(k(-1)) );

    // 8. First order equation for sh
    alpha1 * (1 - theta1) * exp(y1) / ( sh * exp(h(-1)) )  = 
    exp(q) * alpha2 * (1 - theta2) * exp(y2) / ( ( 1 - sh ) * exp(h(-1)) );    

    // 9. First order equation for k
    1 = 
        exp(sdf) * ( alpha1 * theta1 * exp(y1(+1)) / exp(k) 
        + exp(q(+1)) * alpha2 * theta2 * exp(y2(+1)) / exp(k) 
        + ( 1 - deltaK ) );

    rk = alpha1 * theta1 * exp(y1(+1)) / ( sk(+1) * exp(k) );

    // 10. First order equation for h
    exp(q) = 
        exp(sdf) * ( alpha1 * (1 - theta1) * exp(y1(+1)) / exp(h)
        + exp(q(+1)) * ( ( 1 - deltaH ) + alpha2 * (1 - theta2) * exp(y2(+1)) / exp(h) ) );

    // 11. First order equation for n1
    exp(w)      = gamma1 * exp(y1) / exp(n1);

    // 12. First order equation for n2
    exp(w)      = exp(q) * gamma2 * exp(y2) / exp(n2);

    // 13. exogenous processes
    z1     = rho1 * z1(-1) + e1;
    z2     = rho2 * z2(-1) + e2;

    // 14. Output market clearing
	exp(y1)     = exp(c) + exp(i);

    // 15. Labor market clearing
    exp(n)      = exp(n1) + exp(n2);

    // 16. Profit & dividend
    exp(profit) = exp(y1) - exp(w) * exp(n) - rk * exp(k);
    exp(dividend) = exp(y1) - exp(w) * exp(n) - exp(i);

end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------

initval;
    z1 = 0;
    z2 = 0;
    
    sdf = log(bbeta);
	rf			= (1 / bbeta) - 1;
    rk          = (1 / bbeta) - 1 + deltaK;
    n   = log(n_ss);
    n1  = log(0.278277);
    n2  = log(exp(n) - exp(n1));
    sk = 0.837948;
    sh = 0.775142;

    k1  = log(0.475949);
	k = log(0.604);

    h = log(0.577411);
    

    i   = log(exp(k) * deltaK);
    y2  = log(exp(h) * deltaH);

    y1  = log(exp(k1) ^ alpha1 * (exp(z1) * exp(n1)) ^ gamma1);
    w   = log(gamma1 * exp(y1)/exp(n1));
    c = log(exp(y1) - exp(i));

    k2 = log(( (1 - sk ) * exp(k) ) ^ theta2 * ( (1 - sh ) * exp(h) ) ^ (1 - theta2));
    q  = log(0.777652) ;

    profit = log(exp(y1) - exp(w) * exp(n) - rk * exp(k));
    dividend = log(exp(y1) - exp(w) * exp(n) - exp(i));
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