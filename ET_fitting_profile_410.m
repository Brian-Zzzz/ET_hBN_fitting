%% General Preamble + loading from files
line_folder = '/Users/brian_z/Desktop/Research/ET_hBN_fitting/Processing files using matlab/line_profile_326/'

freq = 1450
path = strcat(line_folder,sprintf("hBN_ET_50K_%g_S4_fwd_1.csv",freq))
data = readmatrix(path)
xs = data(1,:)
linefull = data(2,:)

figure();
plot(xs,linefull,'Ok');

cond = xs>-0.35e-05 & xs<-0.023e-05
% -0.02e-05
ind = find(cond)

x_fit = xs(ind)
x_fit = -x_fit * 1.0e6
y_fit = linefull(ind)

figure()
plot(x_fit,y_fit, 'Ok')

% x1 = x_fit(find(x_fit<0.95))
% x2 = x_fit(find(x_fit>1.25))
% y1 = y_fit(find(x_fit<0.95))
% y2 = y_fit(find(x_fit>1.25))
% new_x = horzcat(x1,x2)
% new_y = horzcat(y1,y2)
% figure()
% plot(new_x,new_y,'Ok');

%% guess some starting parameters
%the fitting function is:
Lp=1.3;
lambdafit=0.95;
offset=0.95;
a=1;
slope= 0
 
% varying all the parameters other than offset
F_new=@(x,t)x(7)+x(1).*exp(-2*t./x(5))...
    .*sin(4*pi.*(t-x(2))./x(6))...
    ./t.^(1/2) + ...
    x(3).*exp(-t./x(5))...
    .*sin(2*pi.*(t-x(4))./x(6))./(t.^(x(8))) + slope.*t; ...

% %temporarily fixing A1 to be 0
%     1      2        3         4         5         6          7         8       9
%     A      x_A      B         x_B       L_p       lambda     offset    a       slope
% x0 = [0.01,  1,       0.06,     1,        Lp,       lambdafit, offset,   a       slope]; x = x0; % seed
% lb = [0,     0,       0.05,       0,        0.6,       0.21,        0,        0.9, -0.02]; % lower bound
% ub = [0.02,    2,        0.07,       2,        1.5,       0.23,        2 ,       1.1, 0.02]; % upper bound
%     1      2        3         4         5         6          7         8       9
%     A      x_A      B         x_B       L_p       lambda     offset    a       slope
x0 = [0.05,  1,       1,     0,        Lp,       lambdafit, offset,   a       slope]; x = x0; % seed
lb = [0,     0,       0,       0,        0,       0,        0,        1, 0]; % lower bound
ub = [0,    2,        10,       10,        5,       2,        2,       1, 0]; % upper bound
% 
% %% Fitting options



curvefitoptions = optimset( 'Display', 'final' ,'MaxFunEvals',2e5,'TolFun',1e-8);
[x,resnorm,~,exitflag,output] = lsqcurvefit(F_new,x0,x_fit,y_fit,lb,ub,curvefitoptions);
% [x,resnorm,~,exitflag,output] = lsqcurvefit(F_new,x0,x_fit,y_fit,lb,ub);
% 
% 
% %plot the fitting result
figure()
hold on
xp = linspace(x_fit(1),x_fit(end),1000); 
yp = F_new(real(x),xp); 
plot(xp,yp, '-', 'linewidth', 2)
plot(x_fit,y_fit,'Ok');
xlabel('L (\mum)')
ylabel('s_4 (a.u.)')  
hold off
