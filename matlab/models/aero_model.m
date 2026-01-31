function Fz = aero_model(v, aero)
Fz = 0.5 * aero.rho * aero.Cl * aero.A * v^2;
end
