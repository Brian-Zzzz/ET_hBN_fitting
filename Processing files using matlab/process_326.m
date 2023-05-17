addpath '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/Matlab Scripts'
folderbefore = '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/before process/'
folderafter = '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/after process/'
parameterfolder = '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/process parameters/'
savefolder = '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/after process 326/'

load('sky_cmap.mat');
load('colororder_igor.mat');

wns=readmatrix('/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/DataFiles/221121_junhe/file_wns.csv');

% wavenumber to be processed
set = 1
m2_cell = cell([1,length(wns)])

for b=1:length(wns)
    filename=sprintf("%g/hBN_ET_50K_%g_S4_fwd_%g.csv",wns(b),wns(b),set)
    filepath_after = strcat(folderafter,filename)
    m_after = readmatrix(filepath_after)
    filename_shiftzeros=sprintf("shift_zeros/hBN_ET_50K_%g_S4_fwd_%g.csv",wns(b),set)
    filepath_shiftzeros = strcat(parameterfolder,filename_shiftzeros)
    zero_pos = readmatrix(filepath_shiftzeros)
    [nr, nc] = size(m_after)
    for a=1:nr
        [~, idx] = max(m_after(a,:))
        m2_cell{b}(a,:) = circshift(m_after(a,:),zero_pos-idx)
    end
    filename_save=sprintf("hBN_ET_50K_%g_S4_fwd_%g.csv",wns(b),set)
    filepath_save = strcat(savefolder,filename_save)
%     writematrix(m2_cell{b},filepath_save)
end




