function price = Price_Butterfly(S0)
% -----------------------------------------------------------
% Function: Price_Butterfly
% Task: Compute the Monte Carlo price of a Butterfly Spread option
% -----------------------------------------------------------
% Author: Etienne Trédan
% Description:
%   This function estimates the fair price of a Butterfly Spread option
%   using Monte Carlo simulation. The terminal asset price S_T follows
%   a geometric Brownian motion under the risk-neutral measure:
%
%       S_T = S0 * exp[(r - 0.5σ²)T + σ√T * Z],   with Z ~ N(0,1)
%
%   The discounted expected payoff is then computed as:
%       Price = e^(-rT) * E[ Payoff_Butterfly(S_T, K) ]
%
% Inputs:
%   S0    : Initial asset price
%   r     : Risk-free interest rate
%   T     : Time to maturity (in years)
%   sigma : Volatility of the underlying asset
%   K     : Strike price parameter used in the Butterfly structure
%   Nmc   : Number of Monte Carlo simulations
%
% Output:
%   price : Estimated price of the Butterfly option
% -----------------------------------------------------------

    % --- Parameters ---
    r     = 0.1;      % Risk-free rate
    T     = 0.5;      % Time to maturity (years)
    sigma = 0.5;      % Volatility
    K     = 10;       % Strike price parameter
    Nmc   = 100;      % Number of Monte Carlo simulations

    % --- Monte Carlo Simulation ---
    gains = zeros(1, Nmc);  % Vector to store payoffs

    for n = 1:Nmc
        % Simulate terminal price under risk-neutral dynamics
        ST = S0 * exp((r - 0.5 * sigma^2) * T + sigma * sqrt(T) * randn);

        % Compute Butterfly payoff at maturity
        gains(n) = Payoff_Butterfly(ST, K);
    end

    % --- Compute Discounted Expected Payoff ---
    price = exp(-r * T) * mean(gains);

end
