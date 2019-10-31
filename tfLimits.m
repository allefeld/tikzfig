function lim = tfLimits(val, n)

% compute fitting view limits for discretely sampled data (e.g. images)
%
% lim = tfLimits(values)
% lim = tfLimits([minval maxval], numvals)

val = val(:);
if nargin < 2
    n = numel(val);
end

step = range(val) / (n - 1);
if isnan(step) || (step == 0)
    step = 1;
end
if isinf(step)
    error('Cannot span positive range with 1 step.')
end

lim = [min(val) - step / 2, max(val) + step / 2];
