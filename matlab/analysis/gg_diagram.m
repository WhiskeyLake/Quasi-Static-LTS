function gg_diagram(veh, aero, tire)

figure; hold on;

v_list = linspace(20, 90, 8);  % speeds [m/s]

for v = v_list
    Fz = veh.m * veh.g + aero_model(v, aero);
    mu = tire_model(Fz, tire);

    Fy = linspace(-mu*Fz, mu*Fz, 200);
    Fx_lim = sqrt(max((mu*Fz).^2 - Fy.^2, 0));

    % Acceleration and braking
    Fx = [ Fx_lim, -Fx_lim ];
    Fy = [ Fy,      Fy     ];

    ax = Fx / veh.m / veh.g;
    ay = Fy / veh.m / veh.g;

    plot(ax, ay, '.', 'MarkerSize', 4);
end

xlabel('Longitudinal g');
ylabel('Lateral g');
axis equal;
grid on;
end
