function f = Payoff_call(S, K)
% -----------------------------------------------------------
% Function: Payoff_call
% Task: Compute the payoff of a European Call option
% -----------------------------------------------------------
% Author: Etienne Trédan
% Description:
%   This function returns the terminal payoff of a European Call option
%   with strike price K, evaluated for a given underlying price S.
%
%   The payoff at maturity is defined as:
%       f(S) = max(S - K, 0)
%
% Inputs:
%   S : Spot price of the underlying asset
%   K : Strike price of the option
%
% Output:
%   f : Payoff value of the Call option
% -----------------------------------------------------------

    f = max(S - K, 0);

end
