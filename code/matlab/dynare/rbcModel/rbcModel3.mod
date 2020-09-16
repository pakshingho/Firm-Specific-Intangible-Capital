% Basic RBC Model 
%
% Jesus Fernandez-Villaverde
% Philadelphia, March 3, 2005

%----------------------------------------------------------------
% 0. Housekeeping (close all graphic windows)
%----------------------------------------------------------------

close all;

%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

var y c k i l y_l z;
varexo e;

parameters beta psi l_ss delta alpha rho;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------

alpha   = 1 / 3;
beta    = 0.99;
delta   = 0.025;
l_ss    = 1/3;
psi     = 1.75;
rho     = 0.95;  
sigma   = 0.007;

%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------

model; 
  (1/c) = beta*(1/c(+1))*(1+alpha*(k^(alpha-1))*exp(z(+1))*(l(+1))^(1-alpha)-delta);
  psi*c/(1-l) = (1-alpha)*(k(-1)^alpha)*exp(z)*(l^(-alpha));
  c+i = y;
  y = (k(-1)^alpha)*exp(z)*l^(1-alpha);
  i = k-(1-delta)*k(-1);
  y_l = y/l;
  z = rho*z(-1)+e;
end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------

initval;
  l = l_ss;
  k = (alpha * (l ^ (1 - alpha)) / ((1 / beta) - (1 - delta))) ^ (1 / (1 - alpha));
  c = (k ^ alpha) * (l ^ (1 - alpha)) - delta * k;
  z = 0; 
  e = 0;
end;

shocks;
var e = sigma^2;
end;

steady;

stoch_simul(hp_filter = 1600, order = 1);
