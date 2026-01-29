function gamma_list = create_gamma_list(max_t, type)
    gamma_list = zeros(max_t+1,1);
    if type == 1
        stop_t = max_t/25;
        t_n = 0;
        idx = 1;
        idx_max = 6;
        fw = true;
        for n = 1:max_t+1
            gamma_list(n,1) = idx;
            if t_n >= stop_t
                t_n = 0;
                if fw
                    if  idx >= idx_max
                        idx = idx - 1;
                        fw = false;
                    else
                        idx = idx + 1;
                    end
                else
                    if  idx <= 1
                        idx = idx + 1;
                        fw = true;
                    else
                        idx = idx - 1;
                    end
                end
            else
                t_n = t_n + 1;
            end
        end
    else
        gamma_list(:,1) = 3;
    end
    % figure;
    % plot(gamma_list);
    % grid("minor");
    % xline(1440);
end