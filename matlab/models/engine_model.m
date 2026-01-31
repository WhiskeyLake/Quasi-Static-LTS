function P = engine_model(v, veh)
    % Simple flat power curve
    if v < 5
        P = 0;
    else
        P = veh.P_max;
    end
end
