function Surface_Asian()
% -----------------------------------------------------------
% Function: Surface_Asian
% Task: Plot the conditional price surface of an Asian Call option
%       as a function of the current asset price S_t and running average A_t
% -----------------------------------------------------------
% Author: Etienne Trédan
% Description:
%   This script computes and visualizes the conditional price surface
%   of an Asian Call option at a given intermediate time t.
%
%   For each pair (S_t, A_t), the function Price_Asian_t(t, S_t, A_t)
%   is used to estimate the conditional option value through Monte Carlo
%   simulation under the risk-neutral measure.
%
%   The resulting surface illustrates how the Asian option value depends
%   on both the current underlying price and the average price so far.
%
% Inputs (internal parameters):
%   T   : Total time to maturity
%   t   : Current evaluation time (t < T)
%   Ns  : Number of grid points for S_t
%   Na  : Number of grid points for A_t
%
% Output:
%   3D surface plot of Asian option price as a function of (S_t, A_t)
% -----------------------------------------------------------

    % --- Parameters ---
    T  = 0.5;          % Time to maturity (years)
    t  = 2 * T / 3;    % Current evaluation time
    Ns = 41;           % Number of grid points for S_t
    Na = 41;           % Number of grid points for A_t

    % --- Grids for S_t and A_t ---
    St = linspace(0, 20, Ns); % Underlying price grid
    At = linspace(0, 20, Na); % Average price grid

    % --- Preallocation for Price Matrix ---
    price = zeros(Na, Ns);

    % --- Compute Conditional Prices ---
    for j = 1:Ns
        for m = 1:Na
            price(m, j) = Price_Asian_t(t, St(j), At(m));
        end
    end

    % --- Plot the Surface ---
    figure;
    surf(St, At, price);
    shading interp;
    grid on;

    % --- Plot Formatting ---
    title('Asian Option Price Surface at t = 2T/3', 'FontSize', 13);
    xlabel('Current Price S_t', 'FontSize', 12);
    ylabel('Running Average A_t', 'FontSize', 12);
    zlabel('Conditional Price', 'FontSize', 12);
    colorbar;
    legend('Asian Option Price Surface', 'Location', 'best');

end
