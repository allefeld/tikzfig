function tf_close_view

% close current view (locked to further plotting)
%
% tf_close_view

v = tf_get('currentview');
if isempty(v)
    return
end

if v(end)
    tf_append('\end{scope}')
    v(end) = 0;
    tf_set('currentview', v)
end
