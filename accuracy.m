function acc = accuracy(varargin)
%ACCURACY Classification accuracy.
%
%   Syntax:
%      acc = ACCURACY(y,yhat)
%      acc = ACCURACY(C)
%
%         y ... True class
%      yhat ... Predicted class
%         C ... Confusion matrix
%       acc ... Classification accuracy
%
%   Author:
%      Ildeberto de los Santos Ruiz
%      idelossantos@ittg.edu.mx
%      Certified MATLAB Associate
%
%   See also CONFUSIONMAT, CROSSTAB.

if nargin > 1
    y = varargin{1};
    yhat = varargin{2};
    acc = mean(y == yhat);
else
    C = varargin{1};
    acc = sum(diag(C))/sum(C(:));
end