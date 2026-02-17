function price = Price_Asian_t(t, St, At)
% -----------------------------------------------------------
% Function: Price_Asian_t
% Task: Compute the conditional Monte Carlo price of an Asian Call option
%       at time t, given the current asset price S_t and running average A_t
% -----------------------------------------------------------
% Author: Etienne Trédan
% Description:
%   This function estimates the conditional price of an Asian Call option
%   using Monte Carlo simulation under the risk-neutral measure.
%
%   Given the current asset price S_t and the current average A_t (up to time t),
%   it simulates the remaining evolution of the underlying asset until maturity T
%   using the function Pay_off_Asian_t(t, S_t, A_t), which computes the
%   final payoff of the option.
%
%   The conditional price is obtained as:
%       Price(t, S_t, A_t) = e^(-r(T - t)) * E[ Pay_off_Asian_t(t, S_t, A_t) ]
%
% Inputs:
%   t   : Current time (0 ≤ t ≤ T)
%   St  : Current asset price S_t
%   At  : Current running average A_t (up to time t)
%
% Internal Parameters:
%   r     : Risk-free interest rate
%   T     : Time to maturity (years)
%   Nmc   : Number of Monte Carlo simulations
%
% Output:
%   price : Estimated conditional price of the Asian Call option
% -----------------------------------------------------------

    % --- Parameters ---
    r   = 0.4;      % Risk-free rate
    Nmc = 1000;     % Number of Monte Carlo simulations
    T   = 0.5;      % Time to maturity

    % --- Preallocation ---
    gain = zeros(1, Nmc);  % Vector to store payoffs

    % --- Monte Carlo Simulation ---
    for n = 1:Nmc
        gain(n) = Pay_off_Asian_t(t, St, At);  % Conditional payoff simulation
    end

    % --- Compute Discounted Expected Payoff ---
    price = exp(-r * (T - t)) * mean(gain);

end
