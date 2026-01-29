function y_delay = get_delta(Z, delta_list, t)
    idx = delta_list(t + 1);
    % MATLAB refuses to use the idx variable as the actual index... 
    % so let's do it like this...
    switch  idx
        case 51
            y_delay = Z(:,51);
        case 50
            y_delay = Z(:,50);
        case 49
            y_delay = Z(:,49);
        case 48
            y_delay = Z(:,48);
        case 47
            y_delay = Z(:,47);
        case 46
            y_delay = Z(:,46);
        case 45
            y_delay = Z(:,45);
        case 44
            y_delay = Z(:,44);
        case 43
            y_delay = Z(:,43);
        case 42
            y_delay = Z(:,42);
        case 41
            y_delay = Z(:,41);
        case 40
            y_delay = Z(:,40);
        case 39
            y_delay = Z(:,39);
        case 38
            y_delay = Z(:,38);
        case 37
            y_delay = Z(:,37);
        case 36
            y_delay = Z(:,36);
        case 35
            y_delay = Z(:,35);
        case 34
            y_delay = Z(:,34);
        case 33
            y_delay = Z(:,33);
        case 32
            y_delay = Z(:,32);
        case 31
            y_delay = Z(:,31);
        case 30
            y_delay = Z(:,30);
        case 29
            y_delay = Z(:,29);
        case 28
            y_delay = Z(:,28);
        case 27
            y_delay = Z(:,27);
        case 26
            y_delay = Z(:,26);
        case 25
            y_delay = Z(:,25);
        case 24
            y_delay = Z(:,24);
        case 23
            y_delay = Z(:,23);
        case 22
            y_delay = Z(:,22);
        case 21
            y_delay = Z(:,21);
        case 20
            y_delay = Z(:,20);
        case 19
            y_delay = Z(:,19);
        case 18
            y_delay = Z(:,18);
        case 17
            y_delay = Z(:,17);
        case 16
            y_delay = Z(:,16);
        case 15
            y_delay = Z(:,15);
        case 14
            y_delay = Z(:,14);
        case 13
            y_delay = Z(:,13);
        case 12
            y_delay = Z(:,12);
        case 11
            y_delay = Z(:,11);
        case 10
            y_delay = Z(:,10);
        case 9
            y_delay = Z(:,9);
        case 8
            y_delay = Z(:,8);
        case 7
            y_delay = Z(:,7);
        case 6
            y_delay = Z(:,6);
        case 5
            y_delay = Z(:,5);
        case 4
            y_delay = Z(:,4);
        case 3
            y_delay = Z(:,3);
        case 2
            y_delay = Z(:,2);
        case 1
            y_delay = Z(:,1);
        otherwise
            y_delay = Z(:,26);
    end
end

