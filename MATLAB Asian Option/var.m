function [var_W] = var(Nmc, N)
% -----------------------------------------------------------
% Function: var
% Task: Estimate the variance of the terminal value of a Brownian Motion
%       using Monte Carlo simulation
% -----------------------------------------------------------
% Author: Etienne Trédan
% Description:
%   This function simulates Nmc Brownian motion paths over [0, T]
%   with N time steps and computes the empirical variance
%   of their terminal values W(T).
%
%   Each path satisfies:
%       W(0) = 0
%       W(t+Δt) = W(t) + sqrt(Δt) * ε_t,  where ε_t ~ N(0,1)
%
% -----------------------------------------------------------

    % --- Parameters ---
    T = 2;                 % Total time horizon
    delta_t = T / N;       % Time step size

    % --- Initialization ---
    last_value = zeros(1, Nmc); % Vector to store terminal values

    % --- Monte Carlo Simulation ---
    for j = 1:Nmc
        W = zeros(1, N+1);          % Initialize one Brownian path
        for i = 1:N
            W(i+1) = W(i) + sqrt(delta_t) * randn; % Brownian increment
        end
        last_value(j) = W(end);     % Store terminal value
    end

    % --- Compute Empirical Variance ---
    var_W = mean(last_value.^2) - (mean(last_value))^2;

    % --- Plot Example Path ---
    t = linspace(0, T, N+1);
    figure;
    plot(t, W, 'LineWidth', 1.5);
    grid on;

    % --- Plot Formatting ---
    title('Example Path of Simulated Brownian Motion', 'FontSize', 13);
    xlabel('Time (t)', 'FontSize', 12);
    ylabel('W(t)', 'FontSize', 12);
    legend('Sample Brownian Path', 'Location', 'best');

end
