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
    sdf = bbeta * c / c(+1);

	// 2. Euler equation for capital
	1		= sdf * (1 + rf);
	
	// 3. First order equation for labor-leisure
	w   	= cchi * c / (1-n);

    // 4. Production function 1
    y1     = k1 ^ alpha1 * (exp(z1) * n1) ^ gamma1;
    k1 = ( sk * k(-1) ) ^ theta1 * ( sh * h(-1) ) ^ (1 - theta1);
    
    // 5. Production function 2
    y2     = k2 ^ alpha2 * (exp(z2) * n2) ^ gamma2;
    k2 = ( (1 - sk ) * k(-1) ) ^ theta2 * ( (1 - sh ) * h(-1) ) ^ (1 - theta2);
    
    // 6. capital accumulation
    k     = i + (1 - deltaK) * k(-1);
    h     = y2 + (1 - deltaH) * h(-1);

    // 7. First order equation for sk
    alpha1 * theta1 * y1 / ( sk * k(-1) )  = 
    q * alpha2 * theta2 * y2 / ( ( 1 - sk ) * k(-1) );

    // 8. First order equation for sh
    alpha1 * (1 - theta1) * y1 / ( sh * h(-1) )  = 
    q * alpha2 * (1 - theta2) * y2 / ( ( 1 - sh ) * h(-1) );    

    // 9. First order equation for k
    1 = 
        sdf * ( alpha1 * theta1 * y1(+1) / k 
        + q(+1) * alpha2 * theta2 * y2(+1) / k 
        + ( 1 - deltaK ) );

    rk = alpha1 * theta1 * y1(+1) / ( sk(+1) * k );

    // 10. First order equation for h
    q = 
        sdf * ( alpha1 * (1 - theta1) * y1(+1) / h
        + q(+1) * ( ( 1 - deltaH ) + alpha2 * (1 - theta2) * y2(+1) / h ) );

    // 11. First order equation for n1
    w      = gamma1 * y1 / n1;

    // 12. First order equation for n2
    w      = q * gamma2 * y2 / n2;

    // 13. exogenous processes
    z1     = rho1 * z1(-1) + e1;
    z2     = rho2 * z2(-1) + e2;

    // 14. Output market clearing
	y1     = c + i;

    // 15. Labor market clearing
    n      = n1 + n2;

    // 16. Profit & dividend
    profit = y1 - w * n - rk * k;
    dividend = y1 - w * n - i;

end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------

initval;
    z1 = 0;
    z2 = 0;
    
    sdf = bbeta;
	rf			= (1 / bbeta) - 1;
    rk          = (1 / bbeta) - 1 + deltaK;
    n   = n_ss;
    n1  = 1/6;
    n2  = n - n1;
    sk = 0.5;
    sh = 0.5;

    k1  = 0.476767;
	k = 0.608592;

    h = 0.573028;
    

    i   = k * deltaK;
    y2  = h * deltaH;

    y1  = k1 ^ alpha1 * (exp(z1) * n1) ^ gamma1;
    w   = gamma1 * y1/n1;
    c = y1 - i;

    k2 = ( (1 - sk ) * k ) ^ theta2 * ( (1 - sh ) * h ) ^ (1 - theta2);
    q  = 0.777222 ;

    profit = y1 - w * n - rk * k;
    dividend = y1 - w * n - i;
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