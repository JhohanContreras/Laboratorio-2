function Q = EpsonC4_IC(X)
    x = X(1); y = X(2); z = X(3);
    phi = X(4); theta = X(5); psi = X(6);
    XTCP = [x y z]'; 
    RTCP = rpy2r(phi,theta,psi);
    
    x04 = x - 65*RTCP(1,3);
    y04 = y - 65*RTCP(2,3);
    z04 = z - 65*RTCP(3,3);
    e04 = sqrt(x04^2+y04^2);
    
    q1 = [atan2(y04,x04), atan2(y04,x04), atan2(y04,x04)+pi, atan2(y04,x04)+pi];
    q2 = [atan2(e04-100,z04-320)-acos(sqrt((e04-100)^2+(z04-320)^2)/(2*250)),...
          atan2(e04-100,z04-320)+acos(sqrt((e04-100)^2+(z04-320)^2)/(2*250)),...
          atan2(e04+100,z04-320)-acos(sqrt((e04+100)^2+(z04-320)^2)/(2*250)),...
          atan2(e04+100,z04-320)+acos(sqrt((e04+100)^2+(z04-320)^2)/(2*250))];
    q2_ = -q2;
     q3 = [acos(((e04-100)^2+(z04-320)^2-2*250^2)/(2*250^2)),...
          -acos(((e04-100)^2+(z04-320)^2-2*250^2)/(2*250^2)),...
          acos(((e04+100)^2+(z04-320)^2-2*250^2)/(2*250^2)),...
          -acos(((e04+100)^2+(z04-320)^2-2*250^2)/(2*250^2))];
    q3_ = -q3 + pi/2;
    
    q4 = zeros(1,4);
    q5 = zeros(1,4);
    q6 = zeros(1,4);
    for i = 1:4
        mp = RTCP(1,3)*sin(q2(i)+q3(i))*cos(q1(i))+RTCP(2,3)*sin(q2(i)+q3(i))*sin(q1(i))+RTCP(3,3)*cos(q2(i)+q3(i));
        
        try
            q4(1,i) = atan2(RTCP(2,3)*cos(q1(i))-RTCP(1,3)*sin(q1(i)),RTCP(1,3)*cos(q2(i)+q3(i))*cos(q1(i))+RTCP(2,3)*cos(q2(i)+q3(i))*sin(q1(i))+RTCP(3,3)*sin(q2(i)+q3(i)));
            q5(1,i) = atan2(sqrt(1-mp^2),mp);
            q6(1,i) = atan2(RTCP(1,2)*sin(q2(i)+q3(i))*cos(q1(i))+RTCP(2,2)*sin(q2(i)+q3(i))*sin(q1(i))+RTCP(3,3)*cos(q2(i)+q3(i)),RTCP(1,2)*sin(q2(i)+q3(i))*cos(q1(i))+RTCP(2,1)*sin(q2(i)+q3(i))*sin(q1(i))+RTCP(3,1)*cos(q2(i)+q3(i)));
        catch
            warning('Configuración ' + string(i) + ' no valida');
            q1(1,i)=0;
            q2_(1,i)=0;
            q3_(1,i)=0;
        end
    end
    
    Q = rad2deg([q1' q2_' q3_' q4' -q5' q6']);
end