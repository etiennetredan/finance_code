function Graph_Butterfly()
% -----------------------------------------------------------
% Function: Graph_Butterfly
% Task: Plot the price of a Butterfly option as a function of S0
% -----------------------------------------------------------
% Author: Etienne Trédan
% Description:
%   This script computes and plots the price of a Butterfly option
%   for a range of underlying prices S0. The function Price_Butterfly(S0)
%   must be defined separately to return the option price for each value.
% -----------------------------------------------------------

    % --- Parameters ---
    Ns = 1000;              % Number of points for S0
    deltaS = 40 / Ns;       % Step size for S0
    S0 = (0:Ns) * deltaS;   % Range of initial asset prices

    % --- Preallocation for Prices ---
    price = zeros(size(S0)); % Vector to store Butterfly prices

    % --- Compute Prices for Each S0 ---
    for j = 1:length(S0)
        price(j) = Price_Butterfly(S0(j)); % User-defined pricing function
    end

    % --- Plot Results ---
    figure;
    plot(S0, price, 'b-', 'LineWidth', 2);
    grid on;

    % --- Plot Formatting ---
    title('Butterfly Option Price as a Function of S_0', 'FontSize', 13);
    xlabel('Initial Price S_0', 'FontSize', 12);
    ylabel('Butterfly Option Price', 'FontSize', 12);
    legend('Butterfly Price Curve', 'Location', 'best');

end
