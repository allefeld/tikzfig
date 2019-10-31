function tfColorBar(bi, clim)

% fill pre-defined layout box with colorbar
%
% tfColorBar(bi, clim)
%
% bi:   index of predefined layout box
% clim: range of values mapped to the colormap

% get view box dimensions
olim = tf_get('olim', 'No boxes defined!');
olim = olim(bi, :);

% determine values that are mapped
vals = linspace(clim(1), clim(2), size(colormap, 1));
vlim = tfLimits(vals);
dlim = tfLimits([1 1]);

if olim(2) - olim(1) > olim(4) - olim(3)
    % horizontal
    tfView(bi, vlim, dlim)
    tfHeatMap('', vals', clim, vals, [1 1])
else
    % vertical
    tfView(bi, dlim, vlim)
    tfHeatMap('', vals, clim, [1 1], vals)
end
