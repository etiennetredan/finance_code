function Graphe_Asian()
% -----------------------------------------------------------
% Function: Graphe_Asian
% Task: Plot the price of an Asian option and compare it with
%       a standard Call option and its payoff as a function of S0
% -----------------------------------------------------------
% Author: Etienne Trédan
% Description:
%   This script computes and plots three curves as functions of S0:
%     1. The Monte Carlo price of an Asian option (Price_Asian)
%     2. The payoff of a European Call option (Payoff_call)
%     3. The Monte Carlo price of a European Call option (Price_Call)
%
%   The goal is to visually compare the Asian option pricing behavior
%   with that of the standard European Call.
%
% Inputs (internal parameters):
%   Ns : Number of grid points for S0
%   deltaS : Step size for S0
%
% Outputs:
%   A 2D plot showing the three price/payoff curves
% -----------------------------------------------------------

    % --- Parameters ---
    Ns = 100;              % Number of grid points
    deltaS = 20 / Ns;      % Step size for S0

    % --- Preallocation ---
    S0 = zeros(1, Ns);     % Vector of underlying prices
    price_asian = zeros(1, Ns);
    price_call = zeros(1, Ns);
    payoff_call = zeros(1, Ns);

    % --- Compute Values for Each S0 ---
    for j = 1:Ns
        S0(j) = deltaS * (j - 1);
        price_asian(j) = Price_Asian(S0(j));     % Monte Carlo price of Asian option
        payoff_call(j) = Payoff_call(S0(j), 10); % European Call payoff (K=10)
        price_call(j) = Price_Call(S0(j));       % Monte Carlo price of European Call
    end

    % --- Plot Results ---
    figure;
    plot(S0, price_asian, 'r-', 'LineWidth', 1.5); hold on;
    plot(S0, payoff_call, 'b--', 'LineWidth', 1.2);
    plot(S0, price_call, 'g-', 'LineWidth', 1.2);
    hold off;

    % --- Plot Formatting ---
    grid on;
    title('Comparison: Asian Option vs European Call', 'FontSize', 13);
    xlabel('Initial Price S_0', 'FontSize', 12);
    ylabel('Option Price / Payoff', 'FontSize', 12);
    legend('Asian Option Price', 'European Call Payoff', 'European Call Price', ...
           'Location', 'northwest');

end
