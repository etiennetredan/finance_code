function price = Price_Asian(S0)
% -----------------------------------------------------------
% Function: Price_Asian
% Task: Compute the Monte Carlo price of an Asian Call option
% -----------------------------------------------------------
% Author: Etienne Trédan
% Description:
%   This function estimates the fair price of an Asian Call option
%   using Monte Carlo simulation under the risk-neutral measure.
%
%   For each simulation, a full path of the underlying asset is
%   generated via a Geometric Brownian Motion (GBM) using the
%   function Pay_off_Asian(S0), which computes the corresponding
%   payoff of the Asian option.
%
%   The discounted expected payoff provides the option price:
%       Price = e^(-rT) * E[ Pay_off_Asian(S0) ]
%
% Inputs:
%   S0 : Initial asset price
%
% Internal Parameters:
%   r     : Risk-free interest rate
%   T     : Time to maturity (years)
%   Nmc   : Number of Monte Carlo simulations
%
% Output:
%   price : Estimated price of the Asian Call option
% -----------------------------------------------------------

    % --- Parameters ---
    r   = 0.4;       % Risk-free rate
    T   = 0.5;       % Time to maturity
    Nmc = 1000;      % Number of Monte Carlo simulations

    % --- Preallocation ---
    gain = zeros(1, Nmc);  % Vector to store simulated payoffs

    % --- Monte Carlo Simulation ---
    for n = 1:Nmc
        gain(n) = Pay_off_Asian(S0); % Compute payoff for one simulated path
    end

    % --- Compute Discounted Expected Payoff ---
    price = exp(-r * T) * mean(gain);

end
