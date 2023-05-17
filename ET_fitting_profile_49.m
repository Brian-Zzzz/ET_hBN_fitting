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
% -0.02e-05
ind = find(cond)

x_fit = xs(ind)
x_fit = -x_fit * 1.0e6
y_fit = linefull(ind)

% figure()
% plot(x_fit,y_fit,'Ok');

%% guess some starting parameters
%the fitting function is:
Lp=1;
lambdafit=0.22;
offset=0.95;
a=1;
slope= 0
 
% varying all the parameters other than offset
F_new=@(x,t)x(7)+x(1).*exp(-2*t./x(5))...
    .*sin(4*pi.*(t-x(2))./x(6))...
    ./t.^(1/2) + ...
    x(3).*exp(-t./x(5))...
    .*sin(2*pi.*(t-x(4))./x(6))./(t.^(x(8))) + slope.*t; ...

%     1      2        3         4         5         6          7         8       9
%     A      x_A      B         x_B       L_p       lambda     offset    a       slope
x0 = [0.5,  1,       0.5,     1,        2.5,       lambdafit, offset,   a       slope]; min_x = x0; % seed
lb = [0,     0,       0,       0,        0,       0.2,        0,        0.4, -0.02]; % lower bound
ub = [1,    2,        1,       2,        5,       0.25,        2,       0.6, 0.02]; % upper bound
% 
% %% Fitting options


curvefitoptions = optimset( 'Display', 'final' ,'MaxFunEvals',2e5,'TolFun',1e-8,'PlotFcns','optimplotfval');
[min_x,min_resnorm,~,exitflag,output] = lsqcurvefit(F_new,x0,x_fit,y_fit,lb,ub,curvefitoptions);
iteration = 5
count = 0

while(iteration)
    for c = 1:9
        x0_1 = x0
        x0_1(c) = (lb(c)+x0(c))./2.5
        ub_1 = ub
        ub_1(c) = x0(c).*0.75
        [cur_x1,cur_resnorm1,~,exitflag,output] = lsqcurvefit(F_new,x0_1,x_fit,y_fit,lb,ub_1,curvefitoptions);
        x0_2 = x0
        x0_2(c) = (ub(c)+x0(c))./2
        lb_2 = lb
        lb_2(c) = x0(c).*1.25
        [cur_x2,cur_resnorm2,~,exitflag,output] = lsqcurvefit(F_new,x0_2,x_fit,y_fit,lb_2,ub,curvefitoptions);
        if cur_resnorm1 <= min_resnorm & cur_resnorm1 < cur_resnorm2
            x0 = x0_1
            min_resnorm = cur_resnorm1
            ub(c) = ub_1(c)
            count = count+1
        elseif cur_resnorm2 <= min_resnorm & cur_resnorm2 < cur_resnorm1
            x0 = x0_2
            min_resnorm = cur_resnorm2
            lb(c) = lb_2(c)
            count = count+1
        else
            lb(c) = x0_1(c)
            ub(c) = x0_2(c)
        end
        fprintf('%f\n',cur_resnorm1)
        fprintf('%f\n',cur_resnorm2)
        fprintf('%f\n',min_resnorm)
        fprintf('%g\n',c)
    end
    iteration = iteration - 1
    fprintf('%g\n',iteration)
end


% [x,resnorm,~,exitflag,output] = lsqcurvefit(F_new,x0,x_fit,y_fit,lb,ub,curvefitoptions);
% 
% 
% %plot the fitting result
figure()
hold on
xp = linspace(x_fit(1),x_fit(end),1000); 
yp = F_new(real(min_x),xp); 
plot(xp,yp, '-', 'linewidth', 2)
plot(x_fit,y_fit,'Ok');
xlabel('L (\mum)')
ylabel('s_4 (a.u.)')  
hold off
