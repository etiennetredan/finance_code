function f = Payoff_Butterfly(S, K)
% -----------------------------------------------------------
% Function: Payoff_Butterfly
% Task: Compute the payoff of a Butterfly Spread option strategy
% -----------------------------------------------------------
% Author: Etienne Trédan
% Description:
%   This function returns the terminal payoff of a Butterfly Spread
%   constructed using three strike prices:
%       - Long 1 call at strike K
%       - Short 2 calls at strike 2K
%       - Long 1 call at strike 3K
%
%   The payoff at maturity is given by:
%       f(S) = max(S - 3K, 0) + max(S - K, 0) - 2 * max(S - 2K, 0)
%
% Inputs:
%   S : Spot price of the underlying asset
%   K : Strike price parameter (defining the spread)
%
% Output:
%   f : Payoff value of the Butterfly strategy
% -----------------------------------------------------------

    f = max(S - 3*K, 0) + max(S - K, 0) - 2 * max(S - 2*K, 0);

end
