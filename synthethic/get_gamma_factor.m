function gamma_factor = get_gamma_factor(gamma_list, t)
    idx = gamma_list(t + 1);
    % MATLAB refuses to use the idx variable as the actual index... 
    % so let's do it like this...
    amp = 10;
    phase = 0;
    offset = 26;
    switch  idx
        case 6
            gamma_factor = get_y(amp, phase, 720, offset, t);
        case 5
            gamma_factor = get_y(amp, phase, 480, offset, t);
        case 4
            gamma_factor = get_y(amp, phase, 240, offset, t);
        case 3
            gamma_factor = get_y(amp, phase, 180, offset, t);
        case 2
            gamma_factor = get_y(amp, phase, 150, offset, t);
        case 1
            gamma_factor = get_y(amp, phase, 120, offset, t);
        otherwise
            gamma_factor = idx * 720;
    end
end

