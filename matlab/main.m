
clear; clc;
addpath(genpath(pwd));

veh = vehicle_params();
aero = aero_params();
tire = tire_params();

track = load('D:\Games\Projects\LTS_starter\data\tracks\baku.mat');
results = run_lts(track, veh, aero, tire);

disp(results.lap_time);


t = results.lap_time;
minutes = floor(t / 60);
seconds = mod(t, 60);

fprintf('Lap time: %d:%05.2f (mm:ss)\n', minutes, seconds);
results.s(end)
[min(results.v), max(results.v)]
[min(track.kappa), max(track.kappa)]




ds = diff(results.s);
dt = ds ./ max(results.v(2:end), 1);

plot(results.s(2:end), dt)
xlabel('Distance [m]')
ylabel('Time per segment [s]')
grid on




