function price = Price_Call_t(t, St)
% -----------------------------------------------------------
% Function: Price_Call_t
% Task: Compute the Monte Carlo price of a European Call option
%       at an intermediate time t, given the current asset price St
% -----------------------------------------------------------
% Author: Etienne Trédan
% Description:
%   This function estimates the fair price of a European Call option
%   at time t < T using Monte Carlo simulation under the
%   risk-neutral measure.
%
%   The terminal price S_T of the underlying follows:
%       S_T = St * exp[(r - 0.5σ²)(T - t) + σ√(T - t) * Z],  with Z ~ N(0,1)
%
%   The Call price is then given by:
%       Price = e^(-r(T - t)) * E[ max(S_T - K, 0) | S_t = St ]
%
% Inputs:
%   t     : Current time (0 ≤ t ≤ T)
%   St    : Current asset price at time t
%   r     : Risk-free interest rate
%   sigma : Volatility of the underlying asset
%   K     : Strike price of the option
%   Nmc   : Number of Monte Carlo simulations
%   T     : Time to maturity
%
% Output:
%   price : Estimated Call option price at time t
% -----------------------------------------------------------

    % --- Parameters ---
    r     = 0.1;     % Risk-free rate
    sigma = 0.5;     % Volatility
    K     = 10;      % Strike price
    Nmc   = 1000;    % Number of Monte Carlo simulations
    T     = 1;       % Time to maturity (years)

    % --- Preallocation ---
    gain = zeros(Nmc, 1);  % Vector to store payoffs

    % --- Monte Carlo Simulation ---
    for n = 1:Nmc
        % Simulate terminal price under risk-neutral dynamics
        ST = St * exp((r - 0.5 * sigma^2) * (T - t) + sigma * sqrt(T - t) * randn);

        % Compute payoff for this path
        gain(n) = Payoff_call(ST, K);
    end

    % --- Compute Discounted Expected Payoff ---
    price = exp(-r * (T - t)) * mean(gain);

end
