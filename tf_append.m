function tf_append(code)

% append TikZ code
%
% tf_append(code)

d = tf_get('code');
d{end + 1, 1} = code;
tf_set('code', d)
