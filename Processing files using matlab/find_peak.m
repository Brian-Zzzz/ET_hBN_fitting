%% Preamble things


addpath '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/Matlab Scripts'; % the path to your folder with relevant matlab scripts
datafolder='/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/DataFiles/221121_junhe/'; % a relative path to where the .gsf files are stored
imagefolder='/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/images/'
processfolder = '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/before process/'
parameterfolder = '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/process parameters/'
after_process = '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/after process/'
% in a folder named DataFiles inside the same directory the .m file is in

% these are just some colormaps, and are in the Matlab scripts folder
load('sky_cmap.mat');
load('colororder_igor.mat');
%to apply the colororder_igor, do colororder(color_order_mult) before
%the plot. reset to the default colororder with colororder(default);

%% Data loading variables
temps=[50]; % 
%wns=[1450,1471,1472]; %if we just want to do some test 
wns=readmatrix('/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/DataFiles/221121_junhe/file_wns_rearranged.csv');
wns = wns(4:19,:)
sets=[1,1,1]; %for now (for this to be used, we could similarly 
% have a csv file that listed the number of sets for each wavenumber, and
% load them in individually. this is currently being overwritten by the
% below variables

% only using one temperature and one set for now
temp=50; %forcing it to only be 50K files
setnum=1; %and only the one labelled as _1
dir='fwd'; %and only the forward direction
chn='S4'; %and only channel S4


%% Load Data Files

% Workflow for this cell:
% create a new file load script that takes the complete file name in
% in other words, the file path is *outside* this function
% this includes any 'set' or 'fwd' options, however, the function will
% need to account for the file format itself (e.g. x-res: vs X-Res= and
% number of lines

% Create file name to open the file

% Output it into storage cell arrays: S4_cell, x_cell, y_cell, xres_cell,
% yres_cell etc. alternatively, S4_cell, 
% xrange_cell, yrange_cell, xres_cell, yres_cell
% 

% Plot if needed


% the file names right now have a format of "hBN_ET_50K_1450_S4_fwd_1.gsf"
% we can write this as "hBN_ET_[temp]K_[wn]_[S4/z/S3]_[dir]_[set].gsf"
% therefore, the file location to open will be a
% strcat(datafolder,filename)
% we will then pass to the load_file function the entire filepath
% and then get out all the different parts we need
% for now, we'll just only use set 1, and manually get the list of
% temperatures

%allocate variables
S4_cell=cell([1,length(wns)]); %cell array to store the scattering amp.
xs_cell=cell([1,length(wns)]); %cell array to store the x-axis array
ys_cell=cell([1,length(wns)]); %cell array to store the y-axis array
res_cell=cell([1,length(wns)]);%cell array to store the x, y pixle number 
dim_cell=cell([1,length(wns)]);%cell array to store the x,y real dimensions

for j=1:length(wns)
    filename=sprintf("hBN_ET_%gK_%g_%s_%s_%g.gsf",temp,wns(j),chn,dir,setnum);
    filepath=strcat(datafolder,filename) % do not suppress this print (check the file path directory)
    [S4_cell{j}, xs_cell{j}, ys_cell{j},res_cell{j},dim_cell{j}] ...
        = sp_load_file_filename(filepath); %load using this script that is in the Matlab Scripts folder
end

%% Shift each line to line them up
% Correct for physical thermal drift

% Assuming we now have at least three cell arrays of S4_cell, x_cell, and
% y_cell
% potentially also load in the z files, and do edge detection
% and then find the maximum around that location, presumably within
% 100nms(?)
% store this '0' value in an index_cell 

% for now we are just going to create a new cell array of S4_shift
% and in this one, we will store the shifted file

% if needed, we'll also plot the scans in a single tiled layout
% comment all parts out for figures if not using
% fig_S4_raw=figure('Name','S4');
% p=tiledlayout('flow','TileSpacing','tight','Padding','tight');


S4_shift_cell=cell([1,length(wns)]);
shift_ind_cell=cell(1,length(wns));
shift_zeros=NaN(1,length(wns)); %store the location of '0'


smoothnum=3; % in order to remove outliers and make this automatic matching
% more reliable, we do some smoothing using nearest neighbours
% note: the current script  of "image_average" is an incomplete one
% the only part that works is nearest neighbour averaging


for k=1:length(wns)
%     filename_unshifted=sprintf("UN_hBN_ET_%gK_%g_%s_%s_%g.png",temp,wns(k),chn,dir,setnum);
%     filepath_unshifted=strcat(imagefolder,filename_unshifted)
%     filename_shifted=sprintf("S_hBN_ET_%gK_%g_%s_%s_%g.png",temp,wns(k),chn,dir,setnum);
%     filepath_shifted=strcat(imagefolder,filename_shifted)
%     data_shifted=sprintf("hBN_ET_%gK_%g_%s_%s_%g.csv",temp,wns(k),chn,dir,setnum);
%     filepath_data=strcat(processfolder,data_shifted)
    % put the S4 into a temp array
    % put the x, y res into a temp values
    unshifted_mat=S4_cell{k};
    xyres=res_cell{k};
    shift_ind=NaN(1,xyres(2)); % this should be the number of rows
    shifted_mat=NaN(size(unshifted_mat));
    
    %get the dimensional info
    xs_raw=xs_cell{k}*1e6; %convert to um
    ys_raw=ys_cell{k}*1e6;
    xydim=dim_cell{k}*1e6; 
    
    %do the plotting here, if we want
%     nexttile(p);
%     s4=pcolor(xs_raw,ys_raw,unshifted_mat); %s4 is a temporary variable i'll regret eventually
%     set(s4,'EdgeColor','none'); colormap(sky_cmap); %remove lines and change colormap
%     pbaspect([xydim(1) xydim(2) 1]); %xydim(1) is x length, xydim(2) is y length
%     set(gca,'Yticklabel',[],'Xticklabel',[]); %do not plot the numbers on axis
%     title(sprintf('%gcm-1',wns(k)));
%     %make a scale bar of 0.5um
%     %since we know the x dimensions, and this has the correct dimensions
%     %for aspect ratio: plot a line using these coordinates
%     line([0.15 0.65],[xydim(2)/5 xydim(2)/5],'Color','White','LineWidth',1,'Marker','|');
%     text(0.3,xydim(2)/5*2,'0.5um','Color','White','FontWeight','bold');
%     saveas(s4,filepath_unshifted)

   

    %do a bit of smoothing to hopefully remove outliers
    %unshifted_smoothed=image_average(unshifted_mat,'NN','n'); %ignore other flags
    unshifted_smoothed=image_average(unshifted_mat,'NN','n');
    if smoothnum == 1
        remsooth=unshifted_smoothed; %no smoothing
    elseif smoothnum > 1 
        resmooth=image_average(unshifted_mat,'NN','n'); %do an iterative smoothing of the image
        for renum=1:smoothnum
            if renum==smoothnum
                resmooth=image_average(resmooth,'NN','n'); %so the fact that this is the same as below
            else
                resmooth=image_average(resmooth,'NN','n'); %is for there to be options for other variables (just leave for now)
            end
        end
        
    end

    % get the index of the maximum line for each row
    for m=1:xyres(2)
        %unshifted_line=unshifted_smoothed(m,:);
        unshifted_line=resmooth(m,:); % a temporary variable for the 'current' line
        [~,shift_ind(m)]=max(unshifted_line); %finding the maximum value (throw away) and the index

    end

    %shift using circshift (see matlab doc.)
    shift_zeros(k)=round(mean(shift_ind));
    for m = 1:size(unshifted_smoothed,1)      
        shifted_mat(m,:) = circshift(unshifted_smoothed(m,:),-shift_ind(m) + shift_zeros(k),2);
        %the main problem here is that the parts at the ends that get
        %wrapped around are essentially garbage
        %but since we're not using them anyway, we can ignore them
    end

    % store the indices into the cell
    shift_ind_cell{k}=shift_ind;
    S4_shift_cell{k}=shifted_mat;


    %plot it, essentially same as above but now with the shifted plots
    
%     s=pcolor(shifted_mat);
%     set(s,'EdgeColor','none');
%     colormap('gray');

%     nexttile(p);
%     s4_shift=pcolor(xs_raw,ys_raw,shifted_mat); %s4 is a temporary variable i'll regret eventually
%     set(s4_shift,'EdgeColor','none'); colormap(sky_cmap); %remove lines and change colormap
%     pbaspect([xydim(1) xydim(2) 1]); %xydim(1) is x length, xydim(2) is y length
%     set(gca,'Yticklabel',[],'Xticklabel',[]); %do not plot the numbers on axis
%     title(sprintf('%gcm-1',wns(k)));
%     %make a scale bar of 0.5um
%     %since we know the x dimensions, and this has the correct dimensions
%     %for aspect ratio: plot using dimensions
%     line([0.15 0.65],[xydim(2)/5 xydim(2)/5],'Color','White','LineWidth',1,'Marker','|');
%     text(0.3,xydim(2)/5*2,'0.5um','Color','White','FontWeight','bold');
%     saveas(s4_shift,filepath_shifted)
%     writematrix(shifted_mat, filepath_data)
    
   
    

end

%% Take line average

% now that each of these are lined up, we average each line
% we may need to clean up the data prior to this
% if we have 'NA's, just do 'mean' which should ignore nan
% this can be done with: mean(array,'omitnan') | this is only if we expand
% the array instead of doing a cric shift

xs_shift_cell=cell(size(wns)); %create a blank shell

figure(); %we actually do want to plot this
hold on;
for a=1:length(wns)
    filename=sprintf("%g/hBN_ET_50K_%g_S4_fwd_1.csv",wns(a),wns(a))
    filepath_after = strcat(after_process,filename)
    shifted_mat = readmatrix(filepath_after)
    % average all line-cuts: hopefully by this point everything looks good
    % at this point, we can possibly do an interpolation and double the
    % number of points? try with both
    averaged_line=mean(shifted_mat);
    shifted_line{a}=averaged_line; %store it
    

    % create the shifted xs
    xydim=dim_cell{a};
    xyres=res_cell{a};
    dx=xydim(1)/xyres(1);
    xs_shift=zeros(size(xs_cell{a}));

    for xs_ind=1:xyres(1) %number of x elements?
        xs_shift(xs_ind)=(xs_ind-shift_zeros(a))*dx;
    end
    xs_shift_cell{a}=xs_shift; %store it

%     writematrix(xs_shift,filepath_xsshift)
%     writematrix(shift_zeros(a),filepath_shiftzeros)

    plot(xs_shift,averaged_line);
end
hold off;

%% Normalise each line
% Have it centered in y at a '0'
% rather than normalising the curve amplitude, we just want to be able to
% waterfall this nicely (...for now)

figure();
hold on;
for b=1:length(wns)
    to_norm=shifted_line{b};
    norm_val=mean(to_norm(20:shift_zeros(b)));
    line_normed=to_norm/norm_val;


    xs_shift=xs_shift_cell{b};
    line_normed_cell{b}=line_normed;

    % plot them each w an offset
    plot(xs_shift,line_normed+0.3*b); %the 0.3 scaling factor is just trial and error to see how to best offset it
end
hold off;

%% Interpolate and extrapolate curves
% figure()
% hold on
% x = xs_shift_cell{1}
% y = line_normed_cell{1}
% y = transpose(y)
% f = fit(x,y,'smoothingspline')
% x1 = x(1)
% x2 = x(end)
% x_points = linspace(x1,x2,10000)
% y_points = feval(f,x_points)
% [ypk,idx] = findpeaks(y_points)
% xpk = x_points(idx)
% cond = xpk>-0.05e-05 & xpk<-0.01e-05
% ind = find(cond)
% plot(xpk(ind),ypk(ind),'o')
% plot(f,x,y)
% hold off

figure()
hold on
% result = zeros(size(wns))
all_indices = readmatrix('/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/peaks/smoothspline_peaks_2_rearranged.csv')
all_indices = all_indices(4:19,:)
for c=1:length(wns)
    x = xs_shift_cell{c}
    y = line_normed_cell{c}
    y = transpose(y)
%     y = y + 0.3*c %comment this out
    f = fit(x,y,'smoothingspline')
    x1 = x(1)
    x2 = x(end)
    x_points = linspace(x1,x2,10000)
    y_points = feval(f,x_points)
    [ypk,idx] = findpeaks(y_points)
    xpk = x_points(idx)
    cond = xpk>-0.03e-05 & xpk<-0.01e-05
    ind = find(cond)
%     indices = [ind, ind-1, ind-2, ind-3, ind-4, ind-5, ind-6, ind-7, ind-8]
%     all_indices(c,:) = indices
    indices = all_indices(c,:)
    result(c,:) = xpk(indices)

%     result(c) = xpk(ind)
    plot(f,x,y) %comment this out
    plot(xpk(indices),ypk(indices),'o') %comment this out
end
hold off

% result2 = [-2.95664598459846e-07,-2.53677287728773e-07,-2.39935833583359e-07,-2.32601368136814e-07,-2.25888838883888e-07,-2.23956804680468e-07,-2.24651233123312e-07,-2.20856348634863e-07,-2.27015523552355e-07, ...
% -2.18018070807081e-07,-2.22465766576658e-07,-2.16645760576058e-07,-2.19483885388539e-07,-2.17177908790879e-07,-2.22212221222122e-07,-2.14173783378338e-07,-2.13145064506451e-07,-2.17917599759976e-07, ...
% -2.09256948694869e-07,-2.03209824982498e-07,-2.04637050705071e-07,-2.03398163816382e-07,-2.01798772877288e-07,-2.03330765076507e-07,-1.94892865286529e-07,-2.03182984298430e-07,-1.94560168016802e-07, ...
% -2.01498517851785e-07,-2.05711503150315e-07,-1.96172595259526e-07,-1.90808328832883e-07,-1.92640560056006e-07,-1.87581926192620e-07,-1.88348038803880e-07,-1.82866574657466e-07]

% figure()
% hold on
% plot(wns,result,'o')
% plot(wns,result2,'o')
% hold off
% hold off
%% Regression
% writematrix(all_indices,'/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/peaks/smoothspline_peaks.csv')

%% Waterfall each plot
% and then we can compare where the peaks change, hopefully

% just plot some of them...
% makes it easier to handle
% wns_to_plot=[1461,1465,1467,1468,1469,1470,14705,1471,14715,1472,1473,1474,1475,1478,1479,1480,1481];
% figure();
% hold on;
% index=0;
% for j=1:length(wns)
% 
%     %don't show the wonky ones
%     if ismember(wns(j),wns_to_plot)==0
%         continue
%     end
%     xs_shift=xs_shift_cell{j}*1e6;
%     line_normed=line_normed_cell{j};
% 
%     % plot them each w an offset
%     plot(xs_shift,line_normed+0.3*index);
%     index=index+1;
% end
% xlim([-1.2, 0.2]);
% leg_text=(num2str(wns_to_plot'));
% legend(leg_text);
% hold off;

%% Plot wavenumber versus wavelenth
% wns2 = [1450,1461,1463,1465,1466.5,1467.5,1467,1468.5,1468,1469.5,1469,1470.5,1470,1471.5,1471,1472.5,1472,1473.5,1473,1474,1475.5,1475,1476.5,1476,1477.5,1477,1478.5,1478,1479.5,1479,1480,1481,1482,1483,1484]
% wns2 = [1465,1466.5,1467,1467.5,1468,1468.5,1469,1469.5,1470,1470.5,1471,1471.5,1472,1472.5,1473,1473.5]
% figure()
% plot(result(:,1)-result(:,4),wns2,'o')
% plot(1./(result(:,1)-result(:,4)),wns2,'o')
% title('peak 1&4')
% 
% figure()
% plot(result(:,1)-result(:,3),wns2,'o')
% plot(1./(result(:,1)-result(:,3)),wns2,'o')
% title('peak 1&3')
% 
% figure()
% plot(result(:,1)-result(:,2),wns2,'o')
% plot(1./(result(:,1)-result(:,2)),wns2,'o')
% title('peak 1&2')
% 
% figure()
% plot(-result(:,1),wns2,'ko','LineWidth', 2)
% plot(-1./result(:,1),wns2,'o')
% title('peak 1')
% 
% figure()
% plot(result(:,2)-result(:,3),wns2,'o')
% plot(1./(result(:,2)-result(:,3)),wns2,'o')
% title('peak 2&3')
% 
% figure()
% plot(result(:,2)-result(:,4),wns2,'o')
% plot(1./(result(:,2)-result(:,4)),wns2,'o')
% title('peak 2&4')
% 
% figure()
% plot(-result(:,2),wns2,'ko','LineWidth', 2)
% plot(-1./result(:,2),wns2,'o')
% title('peak 2')
% 
% figure()
% plot(result(:,3)-result(:,4),wns2,'o')
% plot(1./(result(:,3)-result(:,4)),wns2,'o')
% title('peak 3&4')
% 
% figure()
% plot(-result(:,3),wns2,'ko','LineWidth', 2)
% plot(-1./result(:,3),wns2,'o')
% title('peak 3')
% 
% figure()
% plot(-result(:,4),wns2,'ko','LineWidth', 2)
% plot(-1./result(:,4),wns2,'o')
% title('peak 4')
% 
% 1450 is excluded for better comparison
% wns3 = [1463,1465,1466.5,1467.5,1467,1468.5,1468,1469.5,1469,1470.5,1470,1471.5,1471,1472.5,1472,1473.5,1473,1474,1475.5,1475,1476.5,1476,1477.5,1477,1478.5,1478,1479.5,1479,1480,1481,1482,1483,1484]
% result2 = result(3:end,:)
% 
% figure()
% plot(result(:,1)-result(:,4),wns2,'o')
% plot(1/(result2(:,1)-result2(:,4)),wns3,'o')
% title('peak 1&4')
% 
% figure()
% plot(result(:,1)-result(:,3),wns2,'o')
% plot(1/(result2(:,1)-result2(:,3)),wns3,'o')
% title('peak 1&3')
% 
% figure()
% plot(result(:,1)-result(:,2),wns2,'o')
% plot(1/(result2(:,1)-result2(:,2)),wns3,'o')
% title('peak 1&2')
% 
% figure()
% plot(-result(:,1),wns2,'o')
% plot(-1/result2(:,1),wns3,'o')
% title('peak 1')
% 
% figure()
% plot(result(:,2)-result(:,3),wns2,'o')
% plot(1/(result2(:,2)-result2(:,3)),wns3,'o')
% title('peak 2&3')
% 
% figure()
% plot(result(:,2)-result(:,4),wns2,'o')
% plot(1/(result2(:,2)-result2(:,4)),wns3,'o')
% title('peak 2&4')
% 
% figure()
% plot(-result(:,2),wns2,'o')
% plot(-1/result2(:,2),wns3,'o')
% title('peak 2')
% 
% figure()
% plot(result(:,3)-result(:,4),wns2,'o')
% plot(1/(result2(:,3)-result2(:,4)),wns3,'o')
% title('peak 3&4')
% 
% figure()
% plot(-result(:,3),wns2,'o')
% plot(-1/result2(:,3),wns3,'o')
% title('peak 3')
% 
% figure()
% plot(-result(:,4),wns2,'o')
% plot(-1/result2(:,4),wns3,'o')
% title('peak 4')