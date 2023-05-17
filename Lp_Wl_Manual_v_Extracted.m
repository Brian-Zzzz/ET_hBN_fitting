% Manually extracted propogation wavelength vs wavenumber
wns = [1465,1466.5,1467,1467.5,1468,1468.5,1469,1469.5,1470,1470.5,1471,1471.5,1472,1472.5,1473,1473.5]
peak_1 = readmatrix('/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/peak4_326_tuning.csv')
wns = wns(2:end)
peak_1 = peak_1(2:end)
new_peak = abs(peak_1*1e06)

% Fitting extracted propogation wavelength vs wavenumber
data = readmatrix('/Users/brian_z/Desktop/Research/ET_hBN_fitting/wn vs Lp tuning 5.15.csv')
wn = data(:,1)
Lp = data(:,2)
wl = data(:,3)
% Confident about set 1, unconfident in 2 and 3. 2>3
% excluded 1450
Lp_1 = Lp([2:6 10 12:27])
Lp_2 = Lp([7:9 11])
Lp_3 = Lp([28:30])
Lp_4 = Lp([1:6 10 13:27 7:9 11:12 28:30])

wn_1 = wn([2:6 10 12:27])
wn_2 = wn([7:9 11])
wn_3 = wn([28:30])
wn_4 = wn([1:6 10 13:27 7:9 11:12 28:30])

wl_1 = wl([2:6 10 12:27])
wl_2 = wl([7:9 11])
wl_3 = wl([28:30])
wl_4 = wl([1:6 10 13:27 7:9 11:12 28:30])

figure()
hold on
plot(wl_1, wn_1, 'ok')
% plot(wl_2, wn_2, '*b')
% plot(wl_3, wn_3, '+g')
plot(new_peak/2, wns, 'xr', 'LineWidth', 2)
title("wn vs wl")
xlabel('lambda(um)')
ylabel('wn(cm-1)')
hold off

figure()
hold on
plot(Lp_1, wn_1, 'Ok')
% plot(Lp_2, wn_2, 'Ob')
title("wn vs Lp")
xlabel('L_p(um)')
ylabel('wn(cm-1)')
hold off

% output = vertcat(transpose(wn_4),transpose(wl_4))
% output_2 = vertcat(wns,transpose(new_peak/2))
% writematrix(output, "wn_v_wl.csv")
% writematrix(output_2, "wn_v_wl_manual.csv")