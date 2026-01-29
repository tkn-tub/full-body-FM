function dydt = ddefun_2(t,y,Z)
p1 = get_p1(10, 0, 1440, 26, t);
p2 = 15;
p3 = 7.2;
p4 = 0.05;
p5 = 0.11;
p6 = 2.9;

ydelay1 = Z(:,1);
dydt = [p1 / (1 + (p2 * y(2) * y(3))) - (p3 * y(1));
        ((y(2) * y(3))^2) / (p4 + (y(2) * y(3))^2) + p5 - p6 * y(2);
        ydelay1(1) - y(3)];
end