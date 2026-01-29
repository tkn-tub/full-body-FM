function y_at_t = get_y(amp, phase, period, offset, t)
    period_factor = 2*pi/ (2 * period);
    y_at_t = sin(period_factor * (t + phase)) * amp + offset;
end