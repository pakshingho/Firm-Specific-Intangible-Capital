%----------------------------------------------------------------
% 0. Housekeeping
%----------------------------------------------------------------

close all;

%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

var y k x l z1 c r w;
varexo e1;

parameters 
alpha gamma delta rho1 sigma1
// Utility function
bbeta eeta cchi l_ss;
%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------

alpha   = 0.3;
gamma   = 0.6;
delta   = 0.1;

rho1    = 0.95; 
sigma1  = 0.05;

// Preferences 
bbeta   	= 0.99;
l_ss 		= 1 / 3;
cchi        = 1.75;
%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------

model;
	// 1. Euler equation for capital
	c ^ (-1)		= bbeta * c(+1) ^ (-1) * (1 + r(+1));
	
	// 2. First order equation for labor-leisure
	w * c ^ (-1)	= cchi / (1-l);
    y = k(-1) ^ alpha * (exp(z1) * l) ^ gamma;
    alpha * y / k(-1) = r + delta;
    x = k - (1 - delta) * k(-1);
    w = gamma * y / l;
    z1 = rho1 * z1(-1) + e1;
    
    // 7. Output market clearing
	y	= c + x;
end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------
steady_state_model;

	r			= (1 / bbeta) - 1;
	l			= l_ss;
	k			= (alpha * (l ^ gamma) / (r + delta)) ^ (1 / (1 - alpha));
    x           = delta * k;
	y			= k ^ alpha *  l ^ gamma;
	c			= y - x;
	z1			= 0;
	w			= gamma * y / l;
	cchi		= w * (c ^ (-1)) * (1-l);
end;

shocks;
var e1 = sigma1^2;
end;

steady;

stoch_simul(irf = 50, order = 1);