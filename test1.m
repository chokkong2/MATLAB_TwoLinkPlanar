syms theta1 theta2 L1 L2 X Y C2 a b               % L1, L2 = Link1,2 의 length

T1 = [cos(theta1) -sin(theta1) 0 L1*cos(theta1); sin(theta1) cos(theta1) 0 L1*sin(theta1); 0 0 1 0; 0 0 0 1] % 첫 번째 Transformation Matrix : 원점에서 바라본 첫 번째 joint의 좌표계
T2 = [cos(theta2) -sin(theta2) 0 L2*cos(theta2); sin(theta2) cos(theta2) 0 L2*sin(theta2); 0 0 1 0; 0 0 0 1] % 두 번째 Transformation Matrix : 첫 번째 joint에서 바라본 두 번째 joint의 좌표계
T3 = T1*T2                 % 세 번째 Transforamation : 두 번째 joint에서 바라본 End Effector의 좌표계
X = 10;                    % 설정하고자 하는 End Effector의 X 좌표
Y = -10;                   % 설정하고자 하는 End Effector의 Y 좌표
L1 = 10;                   % 첫 번째 Link의 Length
L2 = 10;                   % 두 번째 Link의 Length

C2 = ((X^2 + Y^2 - L1^2 - L2^2)/(2*L1*L2))  % cos(theta2)

if (C2 < 0)
     theta2 = [atan((1-C2^2)^0.5/C2)+pi atan(-((1-C2^2)^0.5/C2))-pi]
elseif (C2 > 0)
     theta2 = [atan((1-C2^2)^0.5/C2) atan(-((1-C2^2)^0.5/C2))]
elseif (C2 == 0)
     theta2 = [pi/2 -pi/2]
end

if (C2 > 1 && C2 < -1)       % cos(theta2)가 범위를 벗어나면 fail
    disp('FAIL');
elseif (C2 ~= real(C2))      % cos(theta2)가 실수가 아니면 fial
    disp('FAIL');
    return;
end

theta1 = atan2(Y,X) - atan((L2*sin(theta2))./(L1+L2*C2))      % theta1

for i=1:2                       % theta1, theta2의 해가 각각 두 개씩 존재하면 두 경우를 모두 출력시키기 위해 반복문 사용 
    th1 = theta1(i);
    th2 = theta2(i);

    T2_X = L1*cos(th1);         % 두 번째 Transformation Matrix의 1행 3열 성분
    T2_Y = L1*sin(th1);         % 두 번째 Transformation Matrix의 2행 3열 성분

    T3_X = L1*cos(th1) + L2*cos(th1)*cos(th2) - L2*sin(th1)*sin(th2);     % 세 번째 Transformation Matrix의 1행 3열 성분
    T3_Y = L1*sin(th1) + L2*cos(th1)*sin(th2) + L2*cos(th2)*sin(th1);     % 세 번째 Transformation Matrix의 2행 3열 성분

    originX = [0, T2_X, T3_X];
    originY = [0, T2_Y, T3_Y];
    
    figure
    plot(originX, originY, 'o--', 'linewidth', 2);
    hold on
    axis([-25 25 -25 25]);
    grid on
    axis square
    circle = a^2 + b^2 == 400;               % 첫 번째 Link와 두 번째 Link의 길이가 모두 10이므로 반지름이 20인 원 밖은 도달할 수 없음 (경계선 표시목적)
    fimplicit(circle);
    axis equal;
    c=[T3_X];                                % End Effector의 X 좌표             
    d=[T3_Y];                                % End Effector의 Y 좌표
    plot(c,d,'h', 'color', 'r', 'linewidth', 5);                % End Effector를 강조하여 표시하기 위해 색, 모양, text 설정
    text(c,d, '   End Effector', 'color', 'b', 'FontSize', 10);
    hold off
end