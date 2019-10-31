function tfStyle(stylename, stylevalue)

% define TikZ style for later use in options
%
% tfStyle(stylename, stylevalue)
%
% The following styles are predefined and may be overwritten to change the
% appearance of plots:
% tfView: clipstyle, viewbackgroundstyle
% tfDeco: viewboxstyle, tickinstyle, tickoutstyle, ticklabelstyle,
%   axislabelstyle, titlestyle, viewlabelstyle
%
% To change the font size, use 'font=' with standard LaTeX font size
% commands. For simplicity, aliases have been defined:
%   \ultrasmall \verysmall \small \normalsize \large \verylarge \ultralarge
% Normal font size is 11 pt.
%
% See also tfView, tfDeco

tf_append(['\tikzstyle{' stylename '}=[' stylevalue ']'])