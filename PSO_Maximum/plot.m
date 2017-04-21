[x, y] = meshgrid(-2:0.01:2);
z = sin(sqrt(x.^2+y.^2))./sqrt(x.^2+y.^2) + exp((cos(2*pi*x)+cos(2*pi*y))/2)-2.71289;
mesh(x,y,z);
