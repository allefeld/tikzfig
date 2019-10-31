function ticks = tf_genticks(lim, len)

% automatically generate tick values
%
% ticks = tf_genticks(lim, len)
%
% lim:      axis limits
% len:      length in cm of the scale
% ticks:    tick values

% heuristic:
% - choice of tick diff should be independent of range location
% - range should contain at least two ticks
%   2 * td <= abs(diff(lim))
% - tick diff is made up of a nice number q = 1, 2, 5 and a power of ten
%   td = q * 10 ^ o
% - ticks are at integer multiples of the tick diff
% - the optimal number of ticks is 0.25 * len + 4
% - choose the variant with the number of ticks closest to the optimum

if nargin < 2
    on = 6;
else
    on = 0.25 * len + 4;
end

q = [1 5 2];        % order defines preference in case of tie
ticks = cell(size(q));
n = zeros(size(q));
for i = 1 : size(q, 2)
    o = floor(log10(abs(diff(lim)) / q(i) / 2));
    td = q(i) * 10 ^ o;
    ticks{i} = (ceil(min(lim) / td) : floor(max(lim) / td)) * td;
    n(i) = numel(ticks{i});
end
[~, i] = min(abs(n - on));
ticks = ticks{i};


