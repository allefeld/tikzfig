function tfGrid(options, step, lim)

% draw a coordinate grid into the current view
%
% tfGrid(options, step)
% tfGrid(options, step, lim)
%
% Grid lines are drawn at integer multiples of step, which can be a scalar
% for equal steps in both directions, or a two-vector. The grid extends
% over the current view, unless lim is specified in the form [lx ly ; ux uy].

if isscalar(step)
    step = [step step];
end

if nargin < 3
    a = tf_get('currentview', 'No current view!');
    lim = a(5 : 8);
    lim = reshape(lim, 2, 2);
end

step = diff(tf_transform_data2abs([0 0 ; step]));

tfPath(sprintf('draw,xstep=%.6fcm,ystep=%.6fcm,%s', abs(step), options), lim, {'grid', ''})