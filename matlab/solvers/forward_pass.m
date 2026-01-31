function v = forward_pass(v, v_lim, kappa, ds, veh, aero, tire)

N = length(v);

for i = 1:N-1
    Fz = veh.m * veh.g + aero_model(v(i), aero);
    mu = tire_model(Fz, tire);

    Fy = veh.m * v(i)^2 * abs(kappa(i));
%    Fx = sqrt(max((mu*Fz)^2 - Fy^2, 0));
    P = engine_model(v(i), veh);
    Fx_power = P / max(v(i), 1);
    Fx_tire = sqrt(max((mu*Fz)^2 - Fy^2, 0));

    Fx = min(Fx_power, Fx_tire); %realistic straight-line behaviour

    Drag = 0.5 * aero.rho * aero.Cd * aero.A * v(i)^2;
    a = (Fx - Drag) / veh.m;

    v(i+1) = min(sqrt(v(i)^2 + 2*a*ds(i)), v_lim(i+1));
    v(i+1) = max(v(i+1), 10);
end
end
