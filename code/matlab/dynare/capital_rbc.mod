%----------------------------------------------------------------
% 0. Housekeeping
%----------------------------------------------------------------

close all;

%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

var y k x l z1 c r ri w;
varexo e1;

parameters 
alpha gamma delta rho1 sigma1
// Utility function
bbeta eeis eeta cchi l_ss;
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
eeis 		= 1;
l_ss 		= 1 / 3;
eeta 		= 1 / 2;

%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------

model;
	// 1. Euler equation for capital
	c ^ (-1 / eeis)			= bbeta * (c(+1) ^ (-1 / eeis)) * (1 + r(+1));
	
	// 2. First order equation for labor-leisure
	w * (c ^ (-1 / eeis))	= cchi * (l ^ (1 / eeta));

    y = k(-1) ^ alpha * (exp(z1) * l) ^ gamma;
    alpha * y(+1) / k = ri + delta;
    ri = r(+1);
    x = k - (1 - delta) * k(-1);
    w = gamma * y / l;
    z1 = rho1 * z1(-1) + e1;
    
    // 7. Output market clearing
	y						= c + x;
end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------
steady_state_model;

	r			= (1 / bbeta) - 1;
    ri          = r;
	l			= l_ss;
	k			= (alpha * (l ^ gamma) / (ri + delta)) ^ (1 / (1 - alpha));
    x           = delta * k;
	y			= k ^ alpha *  l ^ gamma;
	c			= y - x;
	z1			= 0;
	w			= gamma * y / l;
	cchi		= w * (c ^ (-1 / eeis)) / (l ^ (1 / eeta));
end;

shocks;
var e1 = sigma1^2;
end;

steady;

stoch_simul(irf = 50, order = 1);