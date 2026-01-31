% function v = cornering_speed(kappa, veh, aero, tire)
% 
% if kappa == 0
%     v = veh.v_max;
%     return
% end
% 
% 
% if abs(kappa) < 1e-6
%     v = 100;
%     return
% end
% 
% v = 30;
% 
% for i = 1:30
%     Fz = veh.m * veh.g + aero_model(v, aero);
%     mu = tire_model(Fz, tire);
% 
%     Fy_req = veh.m * v^2 * abs(kappa);
%     Fy_max = mu * Fz;
% 
%     v = max(v - (Fy_req - Fy_max)/(veh.m*2*v*abs(kappa)), 10);
% end
% end

function v = cornering_speed(kappa, veh, aero, tire)

k = abs(kappa);

% Straight line
if k < 1e-4
    v = veh.v_max;
    return
end

% Initial guess
v = 40;  % m/s

% Fixed-point iteration (NOT Newton)
for i = 1:10
    Fz = veh.m * veh.g + aero_model(v, aero);
    mu = tire_model(Fz, tire);

    v = sqrt(mu * Fz / (veh.m * k));
end

% Hard guards (critical)
v = min(v, veh.v_max);
v = max(v, 10);   % numerical safety floor
end

