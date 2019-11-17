function C = direction(X)
%DIRECTION Direction cosines of the row-vectors in a matrix.
%
%   Syntax:
%      C = DIRECTION(X)
%
%   Programmed by:
%      Ildeberto de los Santos Ruiz
%      idelossantos@ittg.edu.mx
%
%   See also DOT.

M = sqrt(dot(X,X,2));
C = X./M;