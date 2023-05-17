%% Preamble things
addpath '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/Matlab Scripts'; % the path to your folder with relevant matlab scripts
datafolder='/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/DataFiles/221121_junhe/'; % a relative path to where the .gsf files are stored
imagefolder='/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/images/'
processfolder = '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/before process/'
after_process = '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/after process/'
parameterfolder = '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/process parameters/'
% in a folder named DataFiles inside the same directory the .m file is in

% these are just some colormaps, and are in the Matlab scripts folder
load('sky_cmap.mat');
load('colororder_igor.mat');
%to apply the colororder_igor, do colororder(color_order_mult) before
%the plot. reset to the default colororder with colororder(default);

%% Data loading variables
wns=readmatrix('/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/DataFiles/221121_junhe/file_wns.csv');

%% Take line average

% now that each of these are lined up, we average each line
% we may need to clean up the data prior to this
% if we have 'NA's, just do 'mean' which should ignore nan
% this can be done with: mean(array,'omitnan') | this is only if we expand
% the array instead of doing a cric shift

current_wn = 1467
set_num = 4

shifted_line=cell([1,length(set_num)])

figure(); %we actually do want to plot this
hold on;
for a=1:length(wns)
    % average all line-cuts: hopefully by this point everything looks good
    % at this point, we can possibly do an interpolation and double the
    % number of points? try with both
    if wns(a)~=current_wn
        continue
    end
   
    for d = 1:set_num
        filename=sprintf("%g/hBN_ET_50K_%g_S4_fwd_%g.csv",current_wn,current_wn,d)
        filepath_after = strcat(after_process,filename)
        m_after = readmatrix(filepath_after)

        filename_xsshift=sprintf("xs_shift/hBN_ET_50K_%g_S4_fwd_%g.csv",current_wn,d)
        filepath_xsshift = strcat(parameterfolder,filename_xsshift)
        xs_shift = readmatrix(filepath_xsshift)

        averaged_line=mean(m_after);
        shifted_line{d}=averaged_line; %store it
        plot(xs_shift,averaged_line);
    end
end
title('lines')
hold off;

%% Normalise each line
% Have it centered in y at a '0'
% rather than normalising the curve amplitude, we just want to be able to
% waterfall this nicely (...for now)

figure();
hold on;
for b=1:set_num
    filename_shiftzeros=sprintf("shift_zeros/hBN_ET_50K_%g_S4_fwd_%g.csv",current_wn,b)
    filepath_shiftzeros = strcat(parameterfolder,filename_shiftzeros)
    zero_pos = readmatrix(filepath_shiftzeros)
        
    filename_xsshift=sprintf("xs_shift/hBN_ET_50K_%g_S4_fwd_%g.csv",current_wn,b)
    filepath_xsshift = strcat(parameterfolder,filename_xsshift)
    xs_shift = readmatrix(filepath_xsshift)

    to_norm=shifted_line{b};
    norm_val=mean(to_norm(20:zero_pos));
    line_normed=to_norm/norm_val;

    % plot them each w an offset
    plot(xs_shift,line_normed+0.3*b); %the 0.3 scaling factor is just trial and error to see how to best offset it
%     plot(xs_shift,line_normed);

    
end
hold off;
