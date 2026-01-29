function amp = get_amp(delta_list, t)
    idx = delta_list(t);
    if idx <= 51
        amp = floor(idx) + 4;
    else
        amp = 26;
    end
    amp = amp*10;
end

