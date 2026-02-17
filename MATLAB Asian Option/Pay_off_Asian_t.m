function gain = Pay_off_Asian_t(t, St, At)
% -----------------------------------------------------------
% Function: Pay_off_Asian_t
% Task: Compute the payoff of an Asian Call option at time t
%       given the current asset price S_t and running average A_t
% -----------------------------------------------------------
% Author: Etienne Trédan
% Description:
%   This function simulates the remaining evolution of the underlying asset
%   from time t to maturity T under the risk-neutral measure. It uses the
%   current asset price S_t and the current partial average A_t (up to time t)
%   to compute the final payoff of an Asian Call option.
%
%   The underlying follows:
%       S_{u+Δt} = S_u * exp[(r - 0.5σ²)Δt + σ√Δt * Z],  with Z ~ N(0,1)
%
%   The Asian Call payoff is:
%       Payoff = max( (1/T) * ∫₀ᵀ S_u du - K , 0 )
%
% Inputs:
%   t   : Current time (0 ≤ t ≤ T)
%   St  : Current asset price S_t
%   At  : Current running average A_t (up to time t)
%
% Internal Parameters:
%   r     : Risk-free interest rate
%   sigma : Volatility of the underlying asset
%   N     : Number of time steps for remaining path simulation
%   T     : Time to maturity
%   K     : Strike price of the Asian Call option
%
% Output:
%   gain : Simulated payoff of the Asian Call option at maturity
% -----------------------------------------------------------

    % --- Model Parameters ---
    r     = 0.4;     % Risk-free rate
    sigma = 0.5;     % Volatility
    N     = 100;     % Number of remaining time steps
    T     = 0.5;     % Time to maturity
    K     = 10;      % Strike price

    % --- Initialization ---
    S = zeros(1, N+1); % Vector of simulated prices
    S(1) = St;         % Initial condition at time t
    A = At * t;        % Partial accumulated average up to time t

    % --- Time step for remaining period ---
    delta_t = (T - t) / N;

    % --- Simulate remaining GBM path ---
    for i = 1:N
        S(i+1) = S(i) * exp((r - 0.5 * sigma^2) * delta_t + sigma * sqrt(delta_t) * randn);
        A = A + S(i+1) * delta_t; % Accumulate integral for average computation
    end

    % --- Compute Final Asian Payoff ---
    gain = max(A / T - K, 0);

end
