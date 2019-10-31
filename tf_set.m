function tf_set(name, value)

% set appdata of TikZ figure
%
% tf_set(name, value)

if isempty(get(0, 'CurrentFigure'))
    error('No figure!');
end

setappdata(gcf, ['tikzfig_' name], value);
