function price = Price_Call(S0)
% -----------------------------------------------------------
% Function: Price_Call
% Task: Compute the Monte Carlo price of a European Call option
% -----------------------------------------------------------
% Author: Etienne Trédan
% Description:
%   This function estimates the fair price of a European Call option
%   using Monte Carlo simulation under the risk-neutral measure.
%
%   The terminal price S_T of the underlying follows:
%       S_T = S0 * exp[(r - 0.5σ²)T + σ√T * Z],  with Z ~ N(0,1)
%
%   The Call price is then given by:
%       Price = e^(-rT) * E[ max(S_T - K, 0) ]
%
% Inputs:
%   S0    : Initial price of the underlying asset
%   r     : Risk-free interest rate
%   T     : Time to maturity (in years)
%   sigma : Volatility of the underlying asset
%   K     : Strike price of the option
%   Nmc   : Number of Monte Carlo simulations
%
% Output:
%   price : Estimated Call option price
% -----------------------------------------------------------

    % --- Parameters ---
    r     = 0.1;     % Risk-free rate
    T     = 0.5;     % Time to maturity (years)
    sigma = 0.5;     % Volatility
    K     = 10;      % Strike price
    Nmc   = 1000;    % Number of Monte Carlo simulations

    % --- Preallocation ---
    gain = zeros(Nmc, 1);  % Vector to store individual payoffs

    % --- Monte Carlo Simulation ---
    for n = 1:Nmc
        % Simulate terminal price under risk-neutral dynamics
        ST = S0 * exp((r - 0.5 * sigma^2) * T + sigma * sqrt(T) * randn());

        % Compute payoff for this path
        gain(n) = Payoff_call(ST, K);
    end

    % --- Compute Discounted Expected Payoff ---
    price = exp(-r * T) * mean(gain);

end
