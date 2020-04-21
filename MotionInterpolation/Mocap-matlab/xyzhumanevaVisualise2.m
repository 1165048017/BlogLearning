function handle = xyzhumanevaVisualise2(pos,fid)

% XYZHUMANEVAVISUALISE2
%
% COPYRIGHT : Carl Henrik Ek and Neil Lawrence, 2008

% MOCAP


if(nargin<2)
  fid = 2;
end

figure(fid);

% determine parametrization
if(max(max(abs(pos)))<100)
  type = 'jon';
else
  type = 'raquel';
end

joint = xyzhumaneva2joint(pos);
handle{1} = xyzhumanevaDraw(joint);axis equal;view([1 0 0]);
switch type
 case 'raquel'
  set(gca,'XLim',[-300 300],'YLim',[-300 300],'ZLim',[-800 800]);
 case 'jon'
  set(gca,'XLim',[-0.35 0.35],'YLim',[-0.35 0.35],'ZLim',[-1 0.3]);
end

figure(fid+2);
handle{2} = xyzhumanevaDraw(joint);axis equal;view([1 1 1]);
switch type
 case 'raquel'
  set(gca,'XLim',[-300 300],'YLim',[-300 300],'ZLim',[-800 800]);
 case 'jon'
  set(gca,'XLim',[-0.35 0.35],'YLim',[-0.35 0.35],'ZLim',[-1 0.3]);
end

return
