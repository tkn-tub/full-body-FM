function sol = dde_body(delays, history, tspan, ...
    gamma_amp_input, gamma_period_input, p1_amp_input, p1_period_input, is_noisy_input, ...
    delta_list_input, gamma_list_input)
    global gamma_amp gamma_period p1_amp p1_period is_noisy delta_list gamma_list;
    gamma_amp = gamma_amp_input;
    gamma_period = gamma_period_input;
    p1_amp = p1_amp_input;
    p1_period = p1_period_input;
    is_noisy = is_noisy_input;
    delta_list = delta_list_input;
    gamma_list = gamma_list_input;
    
    sol = dde23(@ddefun_body, delays, history, tspan);
end

function dydt = ddefun_body(t, y, Z)
    global gamma_amp gamma_period p1_amp p1_period is_noisy delta_list gamma_list;
    p1 = 10;%get_p1(p1_amp, 0, p1_period, 26, t);
    p2 = 15;
    p3 = 7.2;
    p4 = 0.05;
    p5 = 0.11;
    p6 = 2.9;
    gamma = get_gamma_factor(gamma_list, floor(t));

    if is_noisy
        gamma = gamma + normrnd(0,5);
    end    
    y_delay = get_delta(Z, delta_list, floor(t));
    
    dydt = [p1 / (1 + (p2 * y(2) * y(3))) - (p3 * y(1));
            ((y(2) * y(3))^2) / (p4 + (y(2) * y(3))^2) + p5 - p6 * y(2);
            gamma * y_delay(1) - y(3)];
end