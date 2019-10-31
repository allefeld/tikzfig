function tfArrow(edge, xyA, xyB)

% draw arrow
%
% tfArrow(edge, xyA, xyB)
%
% edge: edge options
% xyA:  coordinates or node anchor of start point
% xyB:  coordinates or node anchor of end point
%
% Examples:
% - double arrow between two node anchors, bent to the left
% tfArrow('<->,bend left', 'd11.south east', 'd12.north east')
% - arrow from a node anchor to numeric coordinates, shortened at the start
% tfArrow('-latex,shorten <=1pt', 'comp.east', [8.4 1.5])
%
% Arrow tips:
%   Standard
%     latex / reversed                  long, pointed
%     stealth / reversed                hollowed at the base
%     to / reversed                     curled outwards; also < / >
%     |                                 line perpendicular to arrow
%   Triangular
%     latex' / reversed
%     stealth' / reversed
%     triangle 90 / reversed            90° filled triangle
%     triangle 60 / reversed            60° filled triangle
%     triangle 45 / reversed            45° filled triangle
%     open triangle 90 / reversed       90° opened triangle
%     open triangle 60 / reversed       60° opened triangle
%     open triangle 45 / reversed       45° opened triangle
%   Barbed
%     angle 90 / reversed               90° straight lines
%     angle 60 / reversed               60° straight lines
%     angle 45 / reversed               45° straight lines
%     hooks / reversed                  hooks
%   Bracket-Like
%     [ / ]
%     ( / )
%   Circle and Diamond
%     o                                 open circle
%     *                                 filled circle
%     diamond                           filled diamond
%     open diamond                      open diamond
%   Partial
%     left to / reversed
%     right to / reversed
%     left hook / reversed
%     right hook / reversed


if ~ischar(xyA)
    xyA = tf_transform_data2rel(xyA);
    xyA = sprintf('%.6f,%.6f', xyA);
end

if ~ischar(xyB)
    xyB = tf_transform_data2rel(xyB);
    xyB = sprintf('%.6f,%.6f', xyB);
end

tf_append(sprintf('\\path (%s) edge[%s] (%s);', xyA, edge, xyB))
