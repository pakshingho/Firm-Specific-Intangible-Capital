%----------------------------------------------------------------
% 0. Housekeeping
%----------------------------------------------------------------

close all;

%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

var y k x mpk l b z1
logY logX logK;
varexo e1;

parameters alpha gamma delta ri r w rho1 sigma1 a c d;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------

alpha   = 0.3;
gamma   = 0.6;
delta   = 0.1;
ri      = 0.025;
r       = 0.03;
w       = 1;
a       = 0.02;
c       = 0.01;
d       = 0.2;
rho1    = 0.95; 
sigma1  = 0.05;

%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------

model;
    y = k(-1) ^ alpha * (exp(z1) * l) ^ gamma;
    mpk = alpha * y / k(-1);
    alpha * y(+1) / k = ri + delta;
    x = k - (1 - delta) * k(-1);
    w = gamma * y / l;
    (1 + ri) * (1 - 2 * a * (b - b(-1))) + 
                   (- (1 + r) + 2 * a * (b(+1) - b) - 2 * c * (b - d)) = 0;
    z1 = rho1 * z1(-1) + e1;

// 9. Definition of logY
	logY					= 100 * log(y);
	
	// 10. Definition of logC
	logX					= 100 * log(x);
	
	// 11. Definition of logI
	logK					= 100 * log(k);
end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------

initval;
    k  = 1.54792;
    l  = 0.386981;
    x = (1 - delta) * k;
    b =  -0.05;
    z1 = 0;
    y = k ^ alpha * (exp(z1) * l) ^ gamma;
    logY		= 100 * log(y);
	logX		= 100 * log(x);
	logK		= 100 * log(k);
end;

shocks;
var e1 = sigma1^2;
end;

steady;

stoch_simul(irf = 50, order = 1);