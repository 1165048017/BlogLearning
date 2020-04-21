function out = xyzhumanevaRemovePart(Z,type,limb_type)

% XYZHUMANEVAREMOVEPART
%
% COPYRIGHT : Carl Henrik Ek and Neil Lawrence, 2008

% MOCAP


if(nargin<3)
  limb_type = 'head';
end

switch type
 case 'jon'
  limb{1} = [1 2;2 3;3 4;4 5]; % left leg
  limb{2} = [1 6;6 7;7 8;8 9]; % right leg
  limb{3} = [19 10;10 11;11 12;12 13]; % left arm
  limb{4} = [19 14;14 15;15 16;16 17]; % right arm
  limb{5} = [1 19;19 18]; % head
 case 'raquel'
  limb{1} = [1 2;2 3;3 4;4 5]; % left leg
  limb{2} = [1 6;6 7;7 8;8 9]; % right leg
  limb{3} = [19 10;10 11;11 12;12 13]; % left arm
  limb{4} = [19 14;14 15;15 16;16 17]; % right arm
  limb{5} = [1 19;19 18]; % head
 otherwise
  error('Unkown parametrization');
end


switch limb_type
 case 'head'
  limb_index = 19;
end

for(i = 1:1:size(Z,1))
  pos = xyzhumaneva2joint(Z(i,:));
  pos = pos(setdiff(1:1:size(pos,1),limb_index),:);
  out(i,:) = xyzhumanevaJoint2pos(pos);
end
