function ATD = atd(varargin)
%ATD Average topological distance.
%
%   Syntax:
%      d = ATD(y,yhat,D)
%      d = ATD(C,D)
%
%         y ... True nodes
%      yhat ... Estimated nodes
%         C ... Confusion matrix
%         D ... Distance matrix
%         d ... Average topological distance
%
%   Author:
%      Ildeberto de los Santos Ruiz
%      idelossantos@ittg.edu.mx
%      Certified MATLAB Associate
%
%   See also ADJACENCY, SHORTESTPATH, DISTANCES.

if nargin > 2
    y = varargin{1};
    yhat = varargin{2};
    D = varargin{3};
    ATD = mean(diag(D(y,yhat)));
else
    C = varargin{1};
    D = varargin{2};
    ATD = sum(sum(C.*D))/sum(sum(C));
end