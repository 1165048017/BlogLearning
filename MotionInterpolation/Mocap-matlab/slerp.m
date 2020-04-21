function y = slerp(q1, q2, t)
% SLERP   Spherical linear interpolation.
% Interpolates between two quaternions q1 and q2, using parameter t to
% determine how far along the 'arc' to position the result (0 <= t <= 1).
% q1 and q2 must be of the same size. Either the two quaternions, or t,
% must be scalar, or t must have the same size as the two quaternions.

% Copyright © 2008 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

% The third parameter, t, gives the 'distance' along the 'arc' between the
% quaternions, 0 representing q1 and 1 representing q2. If q1 and q2 are
% unit pure quaternions, the interpolation is along a great circle of the
% sphere between the points represented by q1 and q2. If q1 and q2 are unit
% full quaternions, the interpolation is along the 'arc' on the 4-sphere:
% this means the result is a quaternion which represents a rotation
% intermediate between the two rotations represented by q1 and q2. If the
% first two parameters are not unit quaternions, then there is also
% interpolation in modulus.

% q1 and q2 are not restricted to be real quaternions. Since a unit complex
% quaternion has a real modulus, the check that the first two parameters
% have unit modulus works as coded.

% Interpretation.
%
% The slerp function can be simply understood in terms of the ratio of two
% vectors (pure quaternions). The ratio is the quaternion that rotates one
% vector into the other. Taking a fractional power of this rotation and
% then multiplying it by the first vector obviously gives a vector which is
% part way along the arc between the two quaternions. The ratio is computed
% using the multiplicative inverse. If the two quaternions are full, then
% their ratio again gives a quaternion which multiplies one to give the
% other, but this time in 4-space, including, if the moduli are not unity,
% the scale factor needed to scale one into the other.

% Reference:
%
% Ken Shoemake, 'Animating rotation with quaternion curves', SIGGRAPH
% Computer Graphics, 19 (3), July 1985, 245-254, ACM, New York, USA.
% DOI:10.1145/325165.325242.

error(nargchk(3, 3, nargin)), error(nargoutchk(0, 1, nargout))

if ~isnumeric(t) || ~isreal(t)
    error('Third parameter must be real and numeric.');
end

if any(any(t < 0.0)) || any(any(t > 1.0))
    error('Third parameter must have values between 0 and 1 inclusive.');
end

if ~(all(size(q1) == size(q2)) || isscalar(q1) || isscalar(q2))
    error(['First two parameters cannot be of different sizes unless' ...
          ' one is a scalar.']);
end

if ~isscalar(t)
    
    % t is an array. This is only possible if it matches the size of one of
    % the first two parameters, or both of the first two parameters are
    % scalars.
    
    if ~(all(size(q1) == size(t)) || all(size(q2) == size(t)) || ...
         (isscalar(q1) && isscalar(q2)) ...
        )
        error(['Third parameter cannot be an array unless' ...
               ' the first two are scalars, or it has the'...
               ' same size as one of the first two parameters.']);
    end
end

y = q1 .* (q1.^-1 .* q2).^t;

% $Id: slerp.m,v 1.6 2009/02/08 18:35:21 sangwine Exp $

