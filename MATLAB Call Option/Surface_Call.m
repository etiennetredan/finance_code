function Surface_Call()
% -----------------------------------------------------------
% Function: Surface_Call
% Task: Plot the European Call option price surface as a function of (t, S)
% -----------------------------------------------------------
% Author: Etienne Trédan
% Description:
%   This script computes and visualizes the price surface of a European
%   Call option using the previously defined function Price_Call_t(t, S_t).
%
%   For each pair (t, S_t), the price is computed via Monte Carlo simulation
%   under the risk-neutral measure:
%
%       S_T = S_t * exp[(r - 0.5σ²)(T - t) + σ√(T - t) * Z],  with Z ~ N(0,1)
%
%   The Call price is then:
%       Price(t, S_t) = e^(-r(T - t)) * E[ max(S_T - K, 0) | S_t ]
%
% Inputs (internal parameters):
%   Ns : Number of grid points for S_t
%   Nt : Number of grid points for t
%
% Output:
%   3D surface plot of Call prices as a function of (t, S_t)
% -----------------------------------------------------------

    % --- Parameters ---
    Ns = 100;               % Number of grid points for S_t
    Nt = 100;               % Number of grid points for t
    deltaS = 20 / Ns;       % Step size for S_t
    deltaT = 1 / Nt;        % Step size for t

    % --- Grids for S_t and t ---
    St = (0:Ns) * deltaS;   % Vector of spot prices
    t  = (0:Nt) * deltaT;   % Vector of time points

    % --- Preallocation ---
    price = zeros(Ns+1, Nt+1); % Matrix to store computed prices

    % --- Compute Prices over (t, S_t) grid ---
    for j = 1:Ns+1
        for m = 1:Nt+1
            price(j, m) = Price_Call_t(t(m), St(j));
        end
    end

    % --- Plot the Price Surface ---
    figure;
    surf(t, St, price);
    shading interp;
    grid on;

    % --- Plot Formatting ---
    title('European Call Option Price Surface', 'FontSize', 13);
    xlabel('Time t', 'FontSize', 12);
    ylabel('Underlying Price S_t', 'FontSize', 12);
    zlabel('Call Option Price', 'FontSize', 12);
    colorbar;
    legend('Call Price Surface', 'Location', 'best');

end
