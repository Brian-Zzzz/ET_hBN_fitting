addpath '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/Matlab Scripts'
load('sky_cmap.mat');
load('colororder_igor.mat');

freq = 1483
% 
% filepath = sprintf('/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/after process 326/hBN_ET_50K_%g_S4_fwd_1.csv',freq)
filepath = sprintf('/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/after process/%g/hBN_ET_50K_%g_S4_fwd_1.csv',freq,freq)
% 
% % [m_before, ~, ~, ~, ~] ...
% %         = sp_load_file_filename(filepath);
% 
% 
m_before = readmatrix(filepath)
% m_after = m_before
% 
figure()
pcolor(m_before);
colormap(sky_cmap);
axis ij
shading interp
title('before');

% writematrix(m_before,'hBN_ET_50K_1483_S4_fwd_1_517_2.csv')

% figure()
% pcolor(m_after);
% colormap(sky_cmap);
% caxis([0.38,0.4])
% axis ij
% shading interp
% title('after');
% zpath = sprintf('/Users/brian_z/Desktop/Research/ET_hBN_fitting/zdata/zdata_%g.csv',freq)
% z_data = readmatrix(zpath)
% 
% figure()
% image(z_data,'CDataMapping','scaled')
% caxis([0,0.1e-08])
% colorbar
% 
% line_folder = '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/line_profile_326/'
% 
% path = strcat(line_folder,sprintf("hBN_ET_50K_%g_S4_fwd_1.csv",freq))
% data = readmatrix(path)
% xs = data(1,:)
% linefull = data(2,:)
% 
% figure();
% plot(xs,linefull,'Ok');
% 
