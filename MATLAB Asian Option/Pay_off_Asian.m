function gain = Pay_off_Asian(S0)
% -----------------------------------------------------------
% Function: Pay_off_Asian
% Task: Compute the payoff of an Asian Call option using Monte Carlo simulation
% -----------------------------------------------------------
% Author: Etienne Trédan
% Description:
%   This function simulates a single sample path of an underlying asset
%   following a Geometric Brownian Motion (GBM), then computes the payoff
%   of an Asian Call option based on the *average price* of the asset.
%
%   The underlying follows:
%       S_{t+Δt} = S_t * exp[(r - 0.5σ²)Δt + σ√Δt * Z],  with Z ~ N(0,1)
%
%   The Asian Call payoff is:
%       Payoff = max( (1/T) * ∫₀ᵀ S_t dt - K , 0 )
%
% Inputs:
%   S0    : Initial asset price
%
% Internal Parameters:
%   r     : Risk-free interest rate
%   σ     : Volatility of the underlying asset
%   T     : Time to maturity (years)
%   K     : Strike price
%   N     : Number of time steps
%   dt    : Time step size
%
% Output:
%   gain  : Simulated payoff value of the Asian Call option
% -----------------------------------------------------------

    % --- Parameters ---
    r     = 0.4;      % Risk-free rate
    sigma = 0.5;      % Volatility
    T     = 0.5;      % Time to maturity
    K     = 10;       % Strike price
    N     = 100;      % Number of time steps
    dt    = T / N;    % Time step size

    % --- Initialization ---
    S = zeros(1, N+1); % Asset price vector
    S(1) = S0;         % Initial condition
    A = 0;             % Running sum for average price

    % --- Simulation of the GBM and Average Price ---
    for i = 1:N
        S(i+1) = S(i) * exp((r - 0.5 * sigma^2) * dt + sigma * sqrt(dt) * randn());
        A = A + S(i+1) * dt; % Approximate time-average with Riemann sum
    end

    % --- Compute Asian Call Payoff ---
    gain = max(A / T - K, 0);

end
