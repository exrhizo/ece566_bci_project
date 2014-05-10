init

[X, Y] = meshgrid(linspace(-10,10,15),linspace(-10,10,15));
z = (X.^2 - Y.^2).*sin(0.5*X) + randn(15).*10;
%
xdata = [reshape(X,15*15,1) reshape(Y,15*15,1)]';
ydata = [reshape(z,15*15,1)]';
%
[~, alpha0] = svr(xdata,ydata,[],[],[],[]);
for x=1:15
     for y=1:15
         z_approx(x,y) = svr(xdata,[],[X(1,x) Y(y,1)]',alpha0,[],[]);
    end
end
%
subplot(1,2,1)
surf(X,Y,z)
subplot(1,2,2)
surf(X,Y,z_approx)