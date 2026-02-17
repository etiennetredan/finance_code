function Surface_Butterfly()
% -----------------------------------------------------------
% Function: Surface_Butterfly
% Task: Plot the Butterfly option price surface as a function of (t, S0)
% -----------------------------------------------------------
% Author: Etienne Trédan
% Description:
%   This script computes and visualizes the price surface of a Butterfly
%   Spread option using conditional Monte Carlo simulation.
%
%   For each pair (t, S0), the terminal price S_T is simulated under the
%   risk-neutral measure, and the discounted expected payoff is computed:
%
%       S_T = S0 * exp[(r - 0.5σ²)(T - t) + σ√(T - t) * Z],  with Z ~ N(0,1)
%
%   The Butterfly price is then:
%       Price(t, S0) = e^(-r(T - t)) * E[ Payoff_Butterfly(S_T, K) ]
%
% Inputs (internal parameters):
%   r     : Risk-free interest rate
%   T     : Time to maturity (in years)
%   sigma : Volatility of the underlying asset
%   K     : Strike price parameter of the Butterfly
%   Ns    : Number of grid points for S0
%   Nt    : Number of grid points for t
%   Nmc   : Number of Monte Carlo simulations per grid point
%
% Output:
%   3D surface plot of Butterfly prices as a function of (t, S0)
% -----------------------------------------------------------

    % --- Parameters ---
    r     = 0.1;          % Risk-free rate
    T     = 0.5;          % Time to maturity (years)
    sigma = 0.5;          % Volatility
    K     = 10;           % Strike price parameter
    Ns    = 41;           % Number of grid points for S0
    Nt    = 41;           % Number of grid points for t

    deltaS = 40 / Ns;     % Step size for S0
    deltaT = T / Nt;      % Step size for t

    S0 = (0:Ns) * deltaS; % Vector of initial prices
    t  = (0:Nt) * deltaT; % Vector of time points

    price = zeros(Ns+1, Nt+1); % Matrix to store prices

    % --- Monte Carlo Simulation over (t, S0) grid ---
    for j = 1:Ns+1
        for m = 1:Nt+1
            Nmc = 1e4;                            % Number of simulations per point
            gains = zeros(1, Nmc);                % Vector for simulated payoffs

            % Conditional Monte Carlo for this (t, S0)
            for n = 1:Nmc
                ST = S0(j) * exp((r - 0.5 * sigma^2) * (T - t(m)) + sigma * sqrt(T - t(m)) * randn);
                gains(n) = Payoff_Butterfly(ST, K);
            end

            % Discounted expected value
            price(j, m) = exp(-r * (T - t(m))) * mean(gains);
        end
    end

    % --- Plot the Price Surface ---
    figure;
    surf(t, S0, price);
    shading interp;
    grid on;

    % --- Plot Formatting ---
    title('Butterfly Option Price Surface', 'FontSize', 13);
    xlabel('Time t', 'FontSize', 12);
    ylabel('Initial Price S_0', 'FontSize', 12);
    zlabel('Butterfly Option Price', 'FontSize', 12);
    colorbar;
    legend('Butterfly Price Surface', 'Location', 'best');

end
