function [C,M] = direction(X)
%DIRECTION Direction cosines of the row-vectors in a matrix.
%
%   Syntax:
%      C = DIRECTION(X)
%
%      X ... Matrix with row-vectors
%      C ... Matrix with direction cosines
%      M ... Column-vector with magnitudes
%
%   Author:
%      Ildeberto de los Santos Ruiz
%      idelossantos@ittg.edu.mx
%      Certified MATLAB Associate
%
%   See also DOT.

M = sqrt(dot(X,X,2));
C = X./M;