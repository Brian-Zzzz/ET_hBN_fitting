wns = [1465,1466.5,1467,1467.5,1468,1468.5,1469,1469.5,1470,1470.5,1471,1471.5,1472,1472.5,1473,1473.5]
% idx = [6,7,8,9,10,12,13,15,16]
% wns_2 = wns(idx)
wns = wns(2:end)

peak_1 = readmatrix('/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/peak4_326_tuning.csv')
% peak_2 = peak_1(idx)
peak_1 = peak_1(2:end)
new_peak = abs(peak_1*1e06)

figure()
plot(peak_1,wns,'ko','LineWidth', 2)

figure()
plot(new_peak/2,wns,'ko','LineWidth', 2)

% figure()
% plot(-peak_2,wns_2,'ko','LineWidth', 2)