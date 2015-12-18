% Grid values of the objective function (visualization)
Ngrid=100;
range=[0 4 0 4];
dx=(range(2)-range(1))/Ngrid;
dy=(range(4)-range(3))/Ngrid;
xgrid=range(1):dx:range(2); ygrid=range(3):dy:range(4);

[x,y]=meshgrid(xgrid,ygrid);
z=-sin(x).*(sin(x.^2/pi)).^20 - sin(y).*(sin(2. .*y.^2/pi)).^20;

% Display the shape of the function to be optimized
figure(1);
surfc(x,y,z);
