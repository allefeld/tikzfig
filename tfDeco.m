function tfDeco(feature, arg1, arg2)

% draw decorations for the current view
%
% tfDeco viewbox
%                       all four edges of the view box
% tfDeco xline
%                       lower edge of the view box
% tfDeco yline
%                       left edge of the view box
% tfDeco lines
%                       'xline' and 'yline'
% tfDeco xscale
% tfDeco('xscale', ticks)
% tfDeco('xscale', ticks, ticklabels)
%                       ticks and tick labels along the lower edge of the box
% tfDeco yscale
% tfDeco('yscale', ticks)
% tfDeco('yscale', ticks, ticklabels)
%                       ticks and tick labels along the left edge of the box
% tfDeco scales
%                       'xscale' and 'yscale'
% tfDeco
%                       'viewbox' and 'scales'
% tfDeco('xlabel', text)
%                       label at lower edge of the layout box
% tfDeco('ylabel', text)
%                       label at left edge of the layout box
% tfDeco('title', text)
%                       label at upper edge of the layout box
% tfDeco('viewlabel', text)
%                       label in upper left corner of the layout box
%
% The appearance of the decorations can be changed using the styles:
%   viewboxstyle, tickinstyle, tickoutstyle, ticklabelstyle,
%   axislabelstyle, titlestyle, viewlabelstyle
%
% See also tfStyle

% better: varargin with an argument consumation process, so that several
% options can be given at once

if nargin == 0
    feature = 'default';
end

v = tf_get('currentview', 'No current view!');
blim = v(1 : 4);
alim = v(5 : 8);
olim = v(9 : 12);



tf_close_view

switch feature
    
    case 'default'
        tfDeco viewbox
        tfDeco scales

    case 'viewbox'
        tf_rectangle('draw,viewboxstyle', reshape(blim, 2, 2));
        
    case 'background'
        tf_rectangle('draw,viewboxstyle', reshape(blim, 2, 2));
        
    case 'lines'
        tfDeco xline
        tfDeco yline
        
    case 'xline'
        tf_rectangle('draw,viewboxstyle', blim([1 3; 2 3]));
        
    case 'yline'
        tf_rectangle('draw,viewboxstyle', blim([1 3; 1 4]));
        
    case 'scales'
        tfDeco xscale
        tfDeco yscale

    case 'xscale'
        if nargin > 1
            ticks = arg1;
        else
            ticks = tf_genticks(alim(1 : 2), diff(blim(1 : 2)));
        end
        if nargin > 2
            if isempty(arg2)
                arg2 = cell(1, numel(ticks));
            end
            if iscell(arg2)
                ticklabels = arg2;
            else
                ticklabels = tf_genticklabels(arg2);
            end
        else
            ticklabels = tf_genticklabels(ticks);
        end
        ticks = ticks(:);
        xy = tf_transform_data2abs([ticks, ones(size(ticks)) * alim(3)]);
        tf_plot('mark=tick,mark size=0.6pt,mark options={tickinstyle}', xy)
        tf_append('\begin{scope} [local bounding box=lbx]')
        tf_plot('mark=tick,mark size=0.6pt,mark options={rotate=180,tickoutstyle}', xy)  
        tf_append('\begin{scope}[ticklabelstyle]')
        tf_append('\setfont')       % make sure em and ex refer to correct font size
        for i = 1 : numel(ticks)
            tf_path('draw,yshift=-1.4 * \capheightfactor em,inner sep=0,outer sep=0', ...
                xy(i, :), ['node[anchor=base] {' ticklabels{i} '}'])
        end
        if numel(ticklabels) > numel(ticks)
            tf_path('draw,yshift=-0.2em', [blim(2) blim(3)], ...
                ['node[anchor=north east,inner sep=0,outer sep=0,scale=0.7] {' ticklabels{end} '}'])
        end
        tf_append('\end{scope}')
        tf_append('\end{scope}')
        tf_append('\typeheight{padinner(2)}{lbx}')

    case 'yscale'
        if nargin > 1
            ticks = arg1;
        else
            ticks = tf_genticks(alim(3 : 4), diff(blim(3 : 4)));
        end
        if nargin > 2
            if isempty(arg2)
                arg2 = cell(1, numel(ticks));
            end
            if iscell(arg2)
                ticklabels = arg2;
            else
                ticklabels = tf_genticklabels(arg2);
            end
        else
            ticklabels = tf_genticklabels(ticks);
        end
        ticks = ticks(:);
        xy = tf_transform_data2abs([ones(size(ticks)) * alim(1), ticks]);
        tf_plot('mark=tick,mark size=0.6pt,mark options={rotate=270,tickinstyle}', xy)
        tf_append('\begin{scope} [local bounding box=lbx]')
        tf_plot('mark=tick,mark size=0.6pt,mark options={rotate=90,tickoutstyle}', xy)
        tf_append('\begin{scope}[ticklabelstyle]')
        tf_append('\setfont')
        for i = 1 : numel(ticks)
            tf_path('draw,xshift=-0.2em,yshift=-0.5ex', xy(i, :), ...
                ['node[anchor=base east,inner sep=0,outer sep=0] {' ticklabels{i} '}'])
        end
        if numel(ticklabels) > numel(ticks)
            tf_path('draw,xshift=-0.2em', [blim(1) blim(4)], ...
                ['node[anchor=north east,inner sep=0,outer sep=0,scale=0.7] {' ticklabels{end} '}'])
        end
        tf_append('\end{scope}')
        tf_append('\end{scope}')
        tf_append('\typewidth{padinner(3)}{lbx}')
        
    case 'xlabel'
        tf_append('\begin{scope}[axislabelstyle,local bounding box=lbx]')
        tf_append('\setfont')
        tf_path('draw', [mean(blim(1 : 2)), olim(3)], ...
                ['node[anchor=base,yshift=\descenderfactor em,inner sep=0,outer sep=0] {' arg1 '}'])
        tf_append('\end{scope}')
        tf_append('\typeheight{padouter(2)}{lbx}')

    case 'ylabel'
        tf_append('\begin{scope}[axislabelstyle,local bounding box=lbx]')
        tf_append('\setfont')
        tf_path('draw', [olim(1), mean(blim(3 : 4))], ...
                ['node[anchor=base,xshift=\capheightfactor em,rotate=90,inner sep=0,outer sep=0] {' arg1 '}'])
        tf_append('\end{scope}')
        tf_append('\typewidth{padouter(3)}{lbx}')
        
    case 'title'
        tf_append('\begin{scope}[titlestyle,local bounding box=lbx]')
        tf_append('\setfont')
        tf_path('draw', [mean(blim(1 : 2)), olim(4)], ...
                ['node[anchor=base,yshift=-\capheightfactor em,inner sep=2pt,outer sep=0] {' arg1 '}'])
        tf_append('\end{scope}')
        tf_append('\typeheight{padouter(1)}{lbx}')
        
    case 'viewlabel'
        tf_append('\begin{scope}[viewlabelstyle,local bounding box=lbx]')
        tf_append('\setfont')
        tf_path('draw', [olim(1), olim(4)], ...
                ['node[anchor=base west,yshift=-\capheightfactor em,inner sep=0,outer sep=0] {' arg1 '}'])
        tf_append('\end{scope}')
        tf_append('\typeheight{padouter(1)}{lbx}')

    otherwise
        error('Unknown feature %s!', feature)
end