%----------------------------------------------------------------
% 0. Housekeeping
%----------------------------------------------------------------

close all;

%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

var y k x l z1 c rf rk w profit dividend;
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
	c ^ (-1)		= bbeta * c(+1) ^ (-1) * (1 + rf);
	
	// 2. First order equation for labor-leisure
	w * c ^ (-1)	= cchi / (1-l);

    // 3. Production func
    y = k(-1) ^ alpha * (exp(z1) * l) ^ gamma;

    // 4. FOC capital
    1 = bbeta * c(+1) ^ (-1) / c ^ (-1) * (alpha * y(+1) / k + (1-delta));
    %1 = bbeta * c(+1) ^ (-1) / c ^ (-1) * (rk(+1) + (1-delta)); % same result as above
    rk = alpha * y / k(-1);

    // 5. Capital law of motion
    x = k - (1 - delta) * k(-1);

    // 6. FOC labor demand
    w = gamma * y / l;

    // 7. Productivity law of motion
    z1 = rho1 * z1(-1) + e1;
    
    // 8. Output market clearing
	y	= c + x;

    // 9. Profit
    profit = y - w * l - rk * k;
    dividend = y - w * l - x;
end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------
steady_state_model;

	rf			= (1 / bbeta) - 1;
    rk          = (1 / bbeta) - 1 + delta;
	l			= l_ss;
	k			= (alpha * (l ^ gamma) / rk) ^ (1 / (1 - alpha));
    x           = delta * k;
	y			= k ^ alpha *  l ^ gamma;
	c			= y - x;
	z1			= 0;
	w			= gamma * y / l;
    profit = y - w * l - rk * k; 
    dividend = y - w * l - x;
	cchi		= w * (c ^ (-1)) * (1-l);
end;

shocks;
var e1 = sigma1^2;
end;

steady;

stoch_simul(irf = 50, order = 1);
%stoch_simul(hp_filter = 1600, irf = 80, order = 1);