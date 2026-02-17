function [] = Brownian_Motion2d()
% -----------------------------------------------------------
% Function: Brownien_Motion2d
% Task: Simulate and plot a 2D Brownian Motion (two independent Wiener processes)
% -----------------------------------------------------------
% Author: Etienne Trédan
% Description:
%   This script simulates a two-dimensional Brownian Motion (W1_t, W2_t)
%   over the time interval [0, T] using discrete time steps.
%
%   Each component follows:
%       W_i(0) = 0
%       W_i(t+Δt) = W_i(t) + sqrt(Δt) * ε_t,  where ε_t ~ N(0,1)
%
%   The two processes are independent.
%
% -----------------------------------------------------------

    % --- Parameters ---
    T = 1;                 % Total time horizon
    N = 1000;              % Number of time steps
    delta_t = T / N;       % Time step size

    % --- Initialization ---
    W1 = zeros(1, N+1);    % First Brownian component
    W2 = zeros(1, N+1);    % Second Brownian component
    W1(1) = 0;             % Initial condition for W1
    W2(1) = 0;             % Initial condition for W2

    % --- Simulation Loop ---
    for n = 1:N
        W1(n+1) = W1(n) + sqrt(delta_t) * randn; % Increment for W1
        W2(n+1) = W2(n) + sqrt(delta_t) * randn; % Increment for W2
    end

    % --- Plot Results ---
    figure;
    plot(W1, W2, 'LineWidth', 1.5);
    grid on;
    axis equal; % keep the same scale on both axes for clarity

    % --- Plot Formatting ---
    title('Simulation of a 2D Brownian Motion (Wiener Process)', 'FontSize', 13);
    xlabel('W_1(t)', 'FontSize', 12);
    ylabel('W_2(t)', 'FontSize', 12);
    legend('2D Brownian Path', 'Location', 'best');

end
