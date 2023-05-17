data = readmatrix('/Users/brian_z/Desktop/Research/ET_hBN_fitting/wn vs Lp tuning.csv')
wn = data(:,1)
Lp = data(:,2)
wl = data(:,3)

Lp_1 = Lp([1:6 10 13:21 24])
Lp_2 = Lp([7:9 11:12 22:23 25:26])

wn_1 = wn([1:6 10 13:21 24])
wn_2 = wn([7:9 11:12 22:23 25:26])

wl_1 = wl([1:6 10 13:21 24])
wl_2 = wl([7:9 11:12 22:23 25:26])

figure()
hold on
plot(Lp_1, wn_1, 'Ok')
% plot(Lp_2, wn_2, 'Ob')
title("wn vs Lp")
xlabel('L_p(um)')
ylabel('wn(cm-1)')
hold off

figure()
hold on
plot(wl_1, wn_1, 'Ok')
% plot(wl_2, wn_2, 'Ob')
title("wn vs wl")
xlabel('lambda(um)')
ylabel('wn(cm-1)')
hold off