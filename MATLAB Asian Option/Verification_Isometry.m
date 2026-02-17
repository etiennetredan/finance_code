function [exp_Int_sto_power, exp_Int_Theta] = Verification_Isometry()
% -----------------------------------------------------------
% Function: Verification_Isometry
% Task: Verify Ito's isometry using Monte Carlo simulation
% -----------------------------------------------------------
% Author: Etienne Trédan
% Description:
%   We simulate Nmc Brownian paths on [0, T] with N time steps.
%   For each path we compute:
%     1) I_sto = \int_0^T Theta(t,W_t) dW_t (discrete Ito sum)
%     2) I_Theta = \int_0^T Theta(t,W_t)^2 dt (Riemann sum)
%   We then compare the empirical means:
%     E[I_sto^2]  vs  E[I_Theta]
%   According to Ito's isometry, these two quantities should match.
% -----------------------------------------------------------

    % --- Parameters ---
    N   = 100;             % Number of time steps
    Nmc = 100000;          % Number of Monte Carlo paths
    T   = 2;               % Time horizon
    dt  = T / N;           % Time step size
    t   = (0:N) * dt;      % Time grid (row vector)

    % --- Preallocation for Monte Carlo outputs ---
    Integral_sto_power = zeros(1, Nmc);  % Stores I_sto^2 for each path
    Integral_Theta     = zeros(1, Nmc);  % Stores I_Theta for each path

    % --- Monte Carlo simulation ---
    for k = 1:Nmc
        % Reset the Brownian path for each simulation
        W = zeros(1, N+1);    % W(1) = 0 at t = 0 by construction

        % Accumulators for the two integrals on this path
        I_sto   = 0.0;        % \int Theta dW
        I_theta = 0.0;        % \int Theta^2 dt

        % Build the Brownian path and compute discrete integrals
        for i = 1:N
            dW        = sqrt(dt) * randn;                    % Brownian increment ~ N(0, dt)
            Theta_val = Theta(t(i), W(i));                   % Theta evaluated at left-point (Ito)
            I_sto     = I_sto + Theta_val * dW;              % Discrete Ito integral
            I_theta   = I_theta + (Theta_val^2) * dt;        % Riemann sum for \int Theta^2 dt
            W(i+1)    = W(i) + dW;                           % Update Brownian path
        end

        % Store the path-level results
        Integral_sto_power(k) = I_sto^2;
        Integral_Theta(k)     = I_theta;
    end

    % --- Empirical expectations ---
    exp_Int_sto_power = mean(Integral_sto_power);
    exp_Int_Theta     = mean(Integral_Theta);

    % --- Convergence plot (running means) ---
    running_mean_sto   = cumsum(Integral_sto_power) ./ (1:Nmc);
    running_mean_theta = cumsum(Integral_Theta)     ./ (1:Nmc);

    figure;
    plot(1:Nmc, running_mean_sto, 'LineWidth', 1.3); hold on;
    plot(1:Nmc, running_mean_theta, 'LineWidth', 1.3);
    grid on; hold off;

    title('Itô Isometry Verification — Monte Carlo Convergence', 'FontSize', 13);
    xlabel('Number of simulations (k)', 'FontSize', 12);
    ylabel('Running mean', 'FontSize', 12);
    legend('E[(\int \Theta dW)^2] (running mean)', 'E[\int \Theta^2 dt] (running mean)', 'Location', 'best');

end

% --- Local function: test integrand Theta(t, w) ---
function f = Theta(t, w)
    % Example integrand (smooth, non-anticipative):
    % You can replace this by any adapted process in t and W_t.
    f = t^2 + w^2 + sin(w) + t;
end
