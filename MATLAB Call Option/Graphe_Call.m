function [] = Graphe_Call()
% -----------------------------------------------------------
% Function: Graphe_Call
% Task: Plot the price of a European Call option as a function of S0
% -----------------------------------------------------------
% Author: Etienne Trédan
% Description:
%   This script computes and plots the price of a European Call option
%   using the user-defined function Price_Call(S0).
%   The call price is evaluated over a grid of initial asset prices S0
%   ranging from 0 to 20.
% -----------------------------------------------------------

    % --- Parameters ---
    Ns = 1000;               % Number of points in the price grid
    deltaS = 20 / Ns;        % Step size for S0
    S0 = zeros(1, Ns+1);     % Vector of underlying prices
    price = zeros(1, Ns+1);  % Vector of call prices

    % --- Compute Call Prices ---
    for j = 1:Ns+1
        S0(j) = deltaS * (j - 1);  % Define S0 grid point
        price(j) = Price_Call(S0(j)); % User-defined pricing function
    end

    % --- Plot Results ---
    figure;
    plot(S0, price, 'LineWidth', 1.5);
    grid on;

    % --- Plot Formatting ---
    title('European Call Option Price (Monte Carlo Simulation)', 'FontSize', 13);
    xlabel('Initial Price S_0', 'FontSize', 12);
    ylabel('Call Option Price', 'FontSize', 12);
    legend('Call Price Curve', 'Location', 'best');

end
