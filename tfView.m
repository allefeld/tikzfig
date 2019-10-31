function tfView(blim, xlim, ylim, olim)

% prepare layout box as current view
%
% normal use: select and prepare predefined layout box
%
% tfView(bi, xlim, ylim)
%
% bi:   index of predefined layout box (default: 1)
% xlim: minimum and maximum values for abscissa 
% ylim: minimum and maximum values for ordinate
%
% low-level use: define new layout box and prepare it
%
% tfView(blim, xlim, ylim, olim)
%
% blim: view box limits, vector [lx ux ly uy]
% olim: layout box limits, vector [lx ux ly uy]
%
% The LaTeX lengths \xu and \yu are defined as the physical lengths
% corresponding to a length of 1 in the view coordinate system,
% horizontally and vertically.
%
% By default, draw operations within the current view are clipped. Clipping
% can be disabled by
%   tfStyle('clipstyle', '')
% before opening the first view.
% By default, the view has a transparent background. This can be changed by
% setting the 'viewbackgroundstyle', e.g.
%   tfStyle('viewbackgroundstyle', 'fill=green')
% See also tfStyle

% For each view a local TikZ coordinate system is used which is not scaled
% but whose origin is moved. This origin is either identical to the origin of
% the data space if that falls within the box, or pinned to one of the
% borders. The advantage of this approach is that TikZ commands that use
% the origin (plot ycomb, polar comb, ybar etc.) work as expected.
% Drawing operations within the view are clipped to its box. In order to
% make both shift of origin and clipping temporary, commands are enclosed
% in a `scope` for each view.


if nargin == 2
    ylim = xlim;
    xlim = blim;
    blim = 1;
end

if isscalar(blim)
    bi = blim;
    blim = tf_get('blim', 'No boxes defined!');
    blim = blim(bi, :);
    olim = tf_get('olim', 'No boxes defined!');
    olim = olim(bi, :);
end

fprintf('tfView %d\n', bi)

tf_close_view

tf_set('currentview', [blim, xlim, ylim, olim, 1])

if prod(xlim) < 0
    ox = 0;
else
    [~, mi] = min(abs(xlim));
    ox = xlim(mi);
end
if prod(ylim) < 0
    oy = 0;
else
    [~, mi] = min(abs(ylim));
    oy = ylim(mi);
end

origin = round(tf_transform_data2abs([ox oy]) * 1e6) * 1e-6;

tf_set('origin', origin);

tf_append(sprintf('\\begin{scope}[xshift=%.6fcm,yshift=%.6fcm]', origin))
tf_rectangle('clipstyle', bsxfun(@minus, reshape(blim, 2, 2), origin));
tf_rectangle('viewbackgroundstyle', bsxfun(@minus, reshape(blim, 2, 2), origin));

xy = diff(tf_transform_data2abs([0 0 ; 1 1]));
tf_append(sprintf('\\setlength{\\xu}{%.6fcm}', xy(1)))
tf_append(sprintf('\\setlength{\\yu}{%.6fcm}', xy(2)))
