function results = run_lts(track, veh, aero, tire)

s     = track.s(:);
kappa = track.kappa(:);
% Hard clamp insane curvature
kappa = max(min(kappa, 0.2), -0.2);

% Kill numerical noise
kappa(abs(kappa) < 1e-4) = 0;
% ds    = mean(diff(s));
ds = diff(s);
N     = length(s);

v_corner   = zeros(N,1);
v_forward  = inf(N,1);
v_backward = inf(N,1);

for i = 1:N
    v_corner(i) = cornering_speed(kappa(i), veh, aero, tire);
end

v_forward(1) = v_corner(1);
v_forward = forward_pass(v_forward, v_corner, kappa, ds, veh, aero, tire);

v_backward(end) = v_corner(end);
v_backward = backward_pass(v_backward, v_corner, kappa, ds, veh, aero, tire);

[min(v_corner) max(v_corner)]
[min(v_forward) max(v_forward)]
[min(v_backward) max(v_backward)]


v = min([v_corner, v_forward, v_backward], [], 2);
v = max(v, 5);
% lap_time = sum(ds ./ max(v,1e-3));
v_mid = v(2:end);
lap_time = sum(ds ./max(v_mid,1));

results.s = s;
results.v = v;
results.lap_time = lap_time;
end
