% peak_folder = '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/peak_data_326/'
% 
% wns=readmatrix('/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/DataFiles/221121_junhe/file_wns_rearranged.csv');
% wns = wns(4:19,:)
% xpk_cell=cell([1,length(wns)]);
% ypk_cell=cell([1,length(wns)]);
% 
% figure()
% p=tiledlayout('flow','TileSpacing','tight','Padding','tight')
% 
% for a=1:length(wns)
%     filename = sprintf("p4_hBN_ET_50K_%g_S4_fwd_1.csv",wns(a))
%     path = strcat(peak_folder,filename)
%     data = readmatrix(path)
%     x = data(1,:)
%     y = data(2,:)
%     f = fit(transpose(x),transpose(y),'sin4')
%     x_points = linspace(x(1),x(end),10000)
%     y_points = feval(f,x_points)
%     [ypk,idx] = findpeaks(y_points)
%     xpk = x_points(idx)
%     xpk_cell{a} = xpk
%     ypk_cell{a} = ypk
%     nexttile(p)
%     hold on
%     plot(xpk,ypk,'o')
%     plot(f,x,y)
%     title(sprintf('%gcm-1',wns(a)));
%     hold off
%     result(a) = xpk(end)
% end
% writematrix(transpose(result),'peak4_326.csv')


data = readmatrix('/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/peak_data_326/p4_hBN_ET_50K_14725_S4_fwd_1.csv')
x = data(1,:)
y = data(2,:)
f = fit(transpose(x),transpose(y),'sin3')
x_points = linspace(x(1),x(end),10000)
y_points = feval(f,x_points)
[ypk,idx] = findpeaks(y_points)
xpk = x_points(idx)


figure()
hold on
plot(xpk,ypk,'o')
plot(f,x,y)
hold off