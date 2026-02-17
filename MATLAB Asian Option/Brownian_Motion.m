function [] = Brownian_Motion()
% -----------------------------------------------------------
% Function: Brownian_Motion
% Task: Simulate and plot a 1D Brownian Motion (Wiener Process)
% -----------------------------------------------------------
% Author: Etienne Trédan
% Description:
%   This script simulates a one-dimensional Brownian Motion (W_t)
%   over the time interval [0, T] using discrete time steps.
%
%   The Brownian motion satisfies:
%       W(0) = 0
%       W(t+Δt) = W(t) + sqrt(Δt) * ε_t,  where ε_t ~ N(0,1)
%
% -----------------------------------------------------------

    % --- Parameters ---
    T = 1;                % Total time horizon
    N = 1000;             % Number of time steps
    delta_t = T / N;      % Time step size

    % --- Initialization ---
    t = zeros(1, N+1);    % Time vector
    W = zeros(1, N+1);    % Brownian path vector
    t(1) = 0;             % Initial time
    W(1) = 0;             % Initial value of Brownian motion

    % --- Simulation Loop ---
    % Generate the Brownian path iteratively
    for n = 1:N
        t(n+1) = t(n) + delta_t;               % Update time
        W(n+1) = W(n) + sqrt(delta_t) * randn; % Random increment (Normal(0, Δt))
    end

    % --- Plot Results ---
    figure;
    plot(t, W, 'LineWidth', 1.5);
    grid on;

    % --- Plot Formatting ---
    title('Simulation of a 1D Brownian Motion (Wiener Process)', 'FontSize', 13);
    xlabel('Time (t)', 'FontSize', 12);
    ylabel('W(t)', 'FontSize', 12);
    legend('Brownian Path', 'Location', 'best');

end


