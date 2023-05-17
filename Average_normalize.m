m_after = readmatrix('/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/after process/14705/hBN_ET_50K_14705_S4_fwd_1.csv')
averaged_line=mean(m_after);
norm_val=mean(averaged_line(20:240));
linefull=averaged_line/norm_val;

line_folder = '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/line_profile_324/'

freq = 14705
path = strcat(line_folder,sprintf("hBN_ET_50K_%g_S4_fwd_1.csv",freq))
data = readmatrix(path)
xs = data(1,:)

figure();
plot(xs,linefull,'Ok');

cond = xs>-0.23e-05 & xs<-0.017e-05
% -0.02e-05
ind = find(cond)

x_fit = xs(ind)
x_fit = -x_fit * 1.0e6
y_fit = linefull(ind)
figure()
plot(x_fit, y_fit, 'Ok')

% save_folder = '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/line_profile_515/'
% save_path = strcat(save_folder,sprintf("hBN_ET_50K_%g_S4_fwd_1.csv",freq))
% save_data = vertcat(xs, linefull)
% writematrix(save_data,save_path)

% x1 = x_fit(find(x_fit<1.13))
% x2 = x_fit(find(x_fit>1.43))
% y1 = y_fit(find(x_fit<1.13))
% y2 = y_fit(find(x_fit>1.43))
% new_x = horzcat(x1,x2)
% new_y = horzcat(y1,y2)
% figure()
% plot(new_x,new_y,'Ok');