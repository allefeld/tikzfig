function tfPrintCode

% print TikZ code

d = tf_get('code');
sprintf('%s\n', d{:})