function sol = calc_amp_sol(max_t, gamma_list, delta_list)
    sol = zeros(max_t+1,1);
    for n = 1:max_t+1
        sol(n,1) = get_amp(delta_list, n) * 1 + gamma_list(n) * 1000;
    end
end