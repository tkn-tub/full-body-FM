function p1_at_t = get_p1(amp, phase, period, offset, t)
    if t > 1440
        t = mod(t, 1440);
    end
    period_factor = 2*pi/ (2 * period);
    p1_at_t = sin(period_factor * (t + phase)) * amp + offset;
end