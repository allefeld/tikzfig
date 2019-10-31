function ticklabels = tf_genticklabels(ticks)

% automatically generate tick labels
%
% ticklabels = tf_genticklabels(ticks)
%
% ticks:        tick values
% ticklabels:   cell array containing tick label strings,
%               and factored-out power of ten in the last element

% tick label heuristic
% - no scientific format within tick labels
% - for nice ticks all digits must be shown,
%   for others two after the first digit that changes between ticks
% - no trailing zeros or decimal point
% - if any tick is >= 10000 or < 0.001, factor out power of ten

% factor out
if (max(abs(ticks)) >= 10000) || (min(abs(ticks) < 0.001))
    o = floor(log10(median(abs(ticks))));
    ticks = ticks / 10 ^ o;
else
    o = 0;
end

% maximum number of decimals of labels
ndec = max(0, o - floor(log10(min(abs(diff(ticks))))) + 2);

% format labels
ticklabels = cell(size(ticks));
for i = 1 : size(ticks, 2)
    s = sprintf(['%.' num2str(ndec) 'f'], ticks(i));
    if ndec > 0
        while (s(end) == '0')
            s(end) = [];
        end
        if s(end) == '.'
            s(end) = [];
        end
    end
    if strcmp(s, '-0')
        s = '0';
    end
    if s(1) == '-'
        s = ['\uneg ' s(2 : end)];  % shorter unary minus sign
    end
ticklabels{i} = ['$' s '$'];
end

% append power
if o ~= 0
    ticklabels{end + 1} = sprintf('$[10 ^ %d]$', o);
end
