function tfColor(name, colorspace, components)

% define color for later use in drawing or filling
%
% tfColor(name, colorspace, components)
%
% implemented using the \definecolor command of the xcolor package
%
% Examples:
% tfColor('yellow', 'HTML', 'FFFF00')
% tfColor('yellow', 'rgb', [1 1 0])
% tfColor('yellow', 'RGB', [255 255 0])
% tfColor('yellow', 'cmyk', [0 0 1 0])
% tfColor('yellow', 'Hsb', [60 1 1])
%
% Instead of defining colors explicitly like this, TikZ also supports the
% xcolor syntax for mixing colors, e.g. 'blue!50!yellow'. 
%
% The following colors are predefined by xcolor:
%   red, green, blue
%   cyan, magenta, yellow
%   black, darkgray, gray, lightgray, white
%   brown, lime, olive, orange, pink, purple, teal, violet
%
% tfColor without arguments defines additional colors that complete the
% RGB color circle:
%     red
%                     Mandarin
%             yellow
%                     Lime
%     green
%                     Cyanotic
%             cyan
%                     Nautical
%     blue
%                     Purple
%             magenta
%                     Crimson
%     red

if nargin == 0
    tfColor('Mandarin', 'HTML', 'FFA600')
    tfColor('Lime', 'HTML', 'A6FF00')
    tfColor('Cyanotic', 'HTML', '00FFA6')
    tfColor('Nautical', 'HTML', '00A6FF')
    tfColor('Purple', 'HTML', 'A600FF')
    tfColor('Crimson', 'HTML', 'FF00A6')
    return
end

if ischar(components)
    col = components;
elseif all(round(components) == components)
    col = sprintf('%d,', components);
    col = col(1 : end - 1);
else
    col = sprintf('%.4f,', components);
    col = col(1 : end - 1);
end

tf_append(sprintf('\\definecolor{%s}{%s}{%s}', name, colorspace, col))
