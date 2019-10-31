function value = tf_get(name, errmsg)

% get appdata from TikZ figure
%
% value = tf_get(name, errmsg)

if isempty(get(0, 'CurrentFigure'))
    error('No figure!');
end

value = getappdata(gcf, ['tikzfig_' name]);
if (nargin > 2) && isempty(value)
    error(errmsg);
end
