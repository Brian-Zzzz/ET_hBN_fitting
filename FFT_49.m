%% General Preamble + loading from files
line_folder = '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/line_profile_326/'

freq = 1465
path = strcat(line_folder,sprintf("hBN_ET_50K_%g_S4_fwd_1.csv",freq))
data = readmatrix(path)
xs = data(1,:)
linefull = data(2,:)

% figure();
% plot(xs,linefull,'Ok');

cond = xs>-0.1e-05 & xs<0
ind = find(cond)

x_fit = xs(ind)
x_fit = -x_fit
y_fit = linefull(ind)
y_fit = y_fit - 0.98
y_fit = y_fit.*sqrt(x_fit)


xs = (x_fit(end)-x_fit(1))/length(x_fit)

y_fft = fft(x_fit)
x_fft = (0:length(x_fit)-1)*xs/length(x_fit)

figure()
plot(x_fit,y_fit)

figure()
plot(x_fft, y_fft)

% Ts = 1/50;
% t = 0:Ts:10-Ts;
% x = exp(-t).*sin(2*pi*15*t) + exp(-2*t).*sin(2*pi*20*t);
% figure()
% plot(t,x)
% xlabel('Time (seconds)')
% ylabel('Amplitude')
% 
% y = fft(x);
% fs = 1/Ts;
% f = (0:length(y)-1)*fs/length(y);
% 
% figure()
% plot(f,abs(y))
% xlabel('Frequency (Hz)')
% ylabel('Magnitude')
% title('Magnitude')
