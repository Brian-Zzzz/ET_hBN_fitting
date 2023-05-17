addpath '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/Matlab Scripts'
folderbefore = '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/before process/'
folderafter = '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/after process/'
parameterfolder = '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/process parameters/'

load('sky_cmap.mat');
load('colororder_igor.mat');

% wavenumber to be processed
wn = 1470
set = 1
filename=sprintf("%g/hBN_ET_50K_%g_S4_fwd_%g.csv",wn,wn,set)
filepath_before = strcat(folderbefore,filename)
filepath_after = strcat(folderafter,filename)
% writematrix(m_after,filepath_after)

m_before = readmatrix(filepath_before)
m_after = readmatrix(filepath_after)

% figure()
% pcolor(m_before);
% colormap(sky_cmap);
% axis ij
% shading interp
% title('before');
% 
% figure()
% pcolor(m_after);
% colormap(sky_cmap);
% axis ij
% shading interp
% title('after');

filename_shiftzeros=sprintf("shift_zeros/hBN_ET_50K_%g_S4_fwd_%g.csv",wn,set)
filepath_shiftzeros = strcat(parameterfolder,filename_shiftzeros)
zero_pos = readmatrix(filepath_shiftzeros)
filename_xsshift=sprintf("xs_shift/hBN_ET_50K_%g_S4_fwd_%g.csv",wn,set)
filepath_xsshift = strcat(parameterfolder,filename_xsshift)
xs_shift = readmatrix(filepath_xsshift)
[nr, nc] = size(m_after)

for a=1:nr
    [~, idx(a)] = max(m_after(a,:))
    m_2(a,:) = circshift(m_after(a,:),zero_pos-idx(a))
end


for a=1:nr
    [~, idx2(a)] = max(m_2(a,:))
end

figure()
pcolor(m_after);
colormap(sky_cmap);
axis ij
shading interp
title('before further shift');

figure()
pcolor(m_2);
colormap(sky_cmap);
axis ij
shading interp
title('after further shift');

averaged_before=mean(m_after)
norm_val1=mean(averaged_before(20:zero_pos))
line_normaled_1 = averaged_before/norm_val1
averaged_after=mean(m_2)
norm_val2=mean(averaged_after(20:zero_pos))
line_normaled_2 = averaged_after/norm_val2

figure()
hold on
plot(xs_shift,line_normaled_1, 'DisplayName','before')
plot(xs_shift,line_normaled_2, 'DisplayName','after')
hold off
legend()




