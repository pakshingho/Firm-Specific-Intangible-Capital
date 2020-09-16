%----------------------------------------------------------------
% 0. Housekeeping
%----------------------------------------------------------------

close all;

%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

var C N B D z;
varexo e;

parameters 
rho sigma 
W r
N_ss

// Utility function
bbeta cchi;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------
rho    = 0.95; 
sigma  = 0.05;

// Preferences 
bbeta   	= 0.99;
N_ss 		= 1 / 3;
cchi        = 1.75;
W           = 1;
r           = 1/bbeta - 1;
%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------

model;
	// 1. Euler equation for bond
	exp(C) ^ (-1) = bbeta * (1 + r(+1)) * exp(C(+1)) ^ (-1);
	
	// 2. First order equation for labor-leisure
	W = cchi * exp(C) / (1-exp(N));

    exp(D) = exp(z);
    z = rho * z(-1) + e;
    
    // 3. Budget
	exp(C) + B = (1+r) * B(-1) + W * exp(N) + exp(D);
end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------
steady_state_model;
	r			= (1 / bbeta) - 1;
	N			= N_ss;
    B           = 0;
	z			= 0;
    D           = 0;
    C           = log((1 - cchi / (1-exp(N)) * exp(N))^(-1) * exp(D));
	W			= cchi * exp(C) / (1-exp(N));
end;

shocks;
var e = sigma1;
end;

steady;

stoch_simul(irf = 50, order = 1);