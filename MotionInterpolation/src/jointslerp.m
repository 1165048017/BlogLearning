function [ q3 ] = jointslerp( q1, q2, t )
%SLERP quaternion slerp
%   computes the slerp of value t between quaternions q1 and q2
%https://gist.github.com/simonlynen/5349167
q1 = q1 ./ norm(q1);
q2 = q2 ./ norm(q2);

one = 1.0 - eps;
d = q1'*q2;
absD = abs(d);

if(absD >= one)
    scale0 = 1 - t;
    scale1 = t;
else
    % theta is the angle between the 2 quaternions
    theta = acos(absD);
    sinTheta = sin(theta);
    
    scale0 = sin( ( 1.0 - t ) * theta) / sinTheta;
    scale1 = sin( ( t * theta) ) / sinTheta;
end
if(d < 0)
    scale1 = -scale1;
end

q3 = scale0 * q1 + scale1 * q2;
q3 = q3 ./ norm(q3);
end