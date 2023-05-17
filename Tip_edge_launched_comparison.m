F_new=@(x,t)x(7)+x(1).*exp (-2*t./x(5))...
    .*sin(4*pi.*(t-x(2))./x(6))...
    ./t.^(1/2) + ...
    x(3).*exp(-t./x(5))...
    .*sin(2*pi.*(t-x(4))./x(6))./(t.^(x(8))) + slope.*t; ...

A = linspace(2,20,20)
p=tiledlayout('flow','TileSpacing','tight','Padding','tight');

for i=1:20
    a = A(i)
    x = linspace(0.1,2,91)
    y = a*0.04.*exp(-2*x).*sin(16*pi.*(x-1))./sqrt(x)+0.04.*exp(-x).*sin(8*pi.*(x-1))./x
    z = a*0.04.*exp(-2*x).*sin(16*pi.*(x-1))./sqrt(x)
    nexttile(p)
    hold on
    plot(x,y)
    % plot(x,z, 'r')
    title(a)
    hold off
end

    
x = linspace(0.2,2,91)
y = 0.0195.*exp(-x/0.9290).*sin(2*pi.*(x-1.0299)/0.4080)./x
z = 0.1149.*exp(-2*x/0.9290).*sin(4*pi.*(x-0.9788)/0.4080)./sqrt(x)
c = y+z

figure()
hold on
plot(x, y, 'r')
plot(x, z, 'b')
plot(x, c, 'k')
title("tip(blue)/edge(red)/combined(black) components")
hold off