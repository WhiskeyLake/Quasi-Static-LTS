function v = backward_pass(v, v_lim, kappa, ds, veh, aero, tire)

N = length(v);

for i = N:-1:2
    Fz = veh.m * veh.g + aero_model(v(i), aero);
    mu = tire_model(Fz, tire);

    Fy = veh.m * v(i)^2 * abs(kappa(i));
%    Fx = sqrt(max((mu*Fz)^2 - Fy^2, 0));
    Fx_max = sqrt(max((mu*Fz)^2 - Fy^2, 0));

    a = Fx_max / veh.m;
    a = min(a, 10);   % max 10 m/s² braking (~1 g)

    v(i-1) = min(sqrt(v(i)^2 + 2*a*ds(i-1)), v_lim(i-1));
end
end
