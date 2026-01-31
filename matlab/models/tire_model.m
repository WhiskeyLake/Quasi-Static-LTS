% function mu = tire_model(Fz, tire)
% mu = tire.mu0 - tire.k * (Fz - tire.Fz0);
% mu = max(mu, 0.6);
% end

function mu = tire_model(Fz, tire)

% Load-sensitive but bounded
mu = tire.mu0 * (1 + 0.2 * log(Fz / tire.Fz0));

% Hard bounds (MANDATORY)
mu = max(mu, 1.2);
mu = min(mu, 3.0);
end

