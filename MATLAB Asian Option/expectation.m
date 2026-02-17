function [exp_W] = expectation(Nmc, N)
% -----------------------------------------------------------
% Function: expectation
% Task: Estimate the expected terminal value of a Brownian Motion
%       using Monte Carlo simulation
% -----------------------------------------------------------
% Author: Etienne Trédan
% Description:
%   This function simulates Nmc Brownian motion paths over [0, T]
%   with N time steps and computes the empirical expectation
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
    last_value = zeros(1, Nmc); % Store final values of each path

    % --- Monte Carlo Simulation ---
    for j = 1:Nmc
        W = zeros(1, N+1);          % Initialize one Brownian path
        for i = 1:N
            W(i+1) = W(i) + sqrt(delta_t) * randn; % Incremental step
        end
        last_value(j) = W(end);     % Store terminal value
    end

    % --- Compute Empirical Expectation ---
    exp_W = mean(last_value);

    % --- Plot Example Path ---
    figure;
    plot(linspace(0, T, N+1), W, 'LineWidth', 1.5);
    grid on;

    % --- Plot Formatting ---
    title('Example Path of Simulated Brownian Motion', 'FontSize', 13);
    xlabel('Time (t)', 'FontSize', 12);
    ylabel('W(t)', 'FontSize', 12);
    legend('Sample Brownian Path', 'Location', 'best');

end
