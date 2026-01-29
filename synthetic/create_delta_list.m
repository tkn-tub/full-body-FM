function delta_list = create_delta_list(max_t, type)
    delta_list = zeros(max_t+1,1);
    if type == 1
        delta_list(1:900,1) = 1;
        delta_list(901:925,1) = 2;
        delta_list(926:950,1) = 3;
        delta_list(951:975,1) = 4;
        delta_list(975:1000,1) = 5;

        delta_list(1001:2000,1) = 6;
        delta_list(2001:2025,1) = 7;
        delta_list(2026:2050,1) = 8;
        delta_list(2051:2075,1) = 9;
        delta_list(2076:3000,1) = 10;

        delta_list(3001:3050,1) = 11;
        delta_list(3051:3063,1) = 12;
        delta_list(3064:3076,1) = 13;
        delta_list(3078:3089,1) = 14;
        delta_list(3090:4000,1) = 15;

        delta_list(4026:6000,1) = 16;
        delta_list(6001:6025,1) = 17;
        delta_list(6026:6050,1) = 18;
        delta_list(6051:6100,1) = 19;
        delta_list(6101:6500,1) = 20;
        delta_list(6501:6600,1) = 21;
        delta_list(6601:6000,1) = 22;
        delta_list(6000:6000,1) = 23;
        delta_list(6000:6000,1) = 24;

        delta_list(7001:8000,1) = 5;
        delta_list(7001:8000,1) = 5;
        delta_list(7001:8000,1) = 5;
        delta_list(7001:8000,1) = 5;
        delta_list(7001:8000,1) = 5;

        delta_list(8001:8500,1) = 7;
        delta_list(8001:8500,1) = 7;
        delta_list(8001:8500,1) = 7;
        delta_list(8001:8500,1) = 7;
        delta_list(8001:8500,1) = 7;

        delta_list(8501:9000,1) = 9;
        delta_list(9001:11500,1) = 11;
        delta_list(11501:13000,1) = 5;
        delta_list(13001:max_t+1,1) = 1;

    elseif type == 2
        period_factor = 2*pi/ (max_t);
        for n = 1:max_t+1
            delta_list(n,1) = floor(sin(period_factor * n) * 25 + 26);
        end
    elseif type == 3
        stop_t = 720;
        t_n = 0;
        idx = 1;
        idx_max = 51;
        for n = 1:max_t+1
            delta_list(n,1) = idx;
            if t_n >= stop_t
                t_n = 0;
                if  idx >= idx_max
                    idx = 1;
                else
                    idx = idx + 1;
                end
            else
                t_n = t_n + 1;
            end

        end
    elseif type == 4
        stop_t = 1440;
        t_n = 0;
        idx = 1;
        idx_max = 51;
        fw = true;
        for n = 1:max_t+1
            delta_list(n,1) = idx;
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
        delta_list(:,1) = 25;
    end
    % figure;
    % plot(delta_list);
    % grid("minor");
    % xline(1440);
end