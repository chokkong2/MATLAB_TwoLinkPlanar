syms theta1 theta2 L1 L2 X Y C2 a b % L1, L2 = Link1,2 의 length

T1 = [cos(theta1) -sin(theta1) 0 L1*cos(theta1); sin(theta1) cos(theta1) 0 L1*sin(theta1); 0 0 1 0; 0 0 0 1]
T2 = [cos(theta2) -sin(theta2) 0 L2*cos(theta2); sin(theta2) cos(theta2) 0 L2*sin(theta2); 0 0 1 0; 0 0 0 1]
T3 = T1*T2
X = 10;
Y = -10;
L1 = 10;
L2 = 10;

C2 = ((X^2 + Y^2 - L1^2 - L2^2)/(2*L1*L2))  % cos(theta2)

if (C2 < 0)
     theta2 = [atan((1-C2^2)^0.5/C2)+pi atan(-((1-C2^2)^0.5/C2))-pi]
elseif (C2 > 0)
     theta2 = [atan((1-C2^2)^0.5/C2) atan(-((1-C2^2)^0.5/C2))]
elseif (C2 == 0)
     theta2 = [pi/2 -pi/2]
end

if (C2 > 1 && C2 < -1)
    disp('FAIL');
elseif (C2 ~= real(C2))
    disp('FAIL');
    return;
end

theta1 = atan2(Y,X) - atan((L2*sin(theta2))./(L1+L2*C2))
%th1 = atan2(Py,Px) - atan(a2*sin(th2)./(a1+a2*cos(th2)))

for i=1:2   
    th1 = theta1(i);
    th2 = theta2(i);

    T2_X = L1*cos(th1);         % Transformation matrix
    T2_Y = L1*sin(th1);

    T3_X = L1*cos(th1) + L2*cos(th1)*cos(th2) - L2*sin(th1)*sin(th2);
    T3_Y = L1*sin(th1) + L2*cos(th1)*sin(th2) + L2*cos(th2)*sin(th1);

    originX = [0, T2_X, T3_X];
    originY = [0, T2_Y, T3_Y];
    
    figure
    plot(originX, originY, 'o--', 'linewidth', 2);
    hold on
    axis([-25 25 -25 25]);
    grid on
    axis square
    circle = a^2 + b^2 == 400;
    fimplicit(circle);
    axis equal;
    c=[T3_X];
    d=[T3_Y];
    plot(c,d,'h', 'color', 'r', 'linewidth', 5);
    text(c,d, '   End Effector', 'color', 'b', 'FontSize', 10);
    hold off
end