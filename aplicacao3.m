clearvars;clc;
%% Coleta dados
CP= 55860000; %contrapressão na ANM (Pascal)    
L1= 3000;  %comprimento do trecho 1 (m)
L2=5000;   %comprimento do trecho 2 (m)
Lt= L1+L2; %comprimento total da tubulação (m)
yt= 3000; %profundidade total (m)
d1= 0.0127; %diâmetro 1 (m)
T_s= 25;  %temperatura da superfície (°C)
e= 0.000178; % porosidade absoluta (m)
d2= 0.00952; % diâmetro 2 (m)
g=9.81;   %gravidade (m/s²)
dL= 200;
n= Lt/dL; %números de linha 
disp(['Número de linhas da tabela: ',num2str(n)])
rho=1114; % massa específica do MEG (kg/m³)
Q= 1.3889e-5; %vazão (m³/s)
a=-0.007; %coeficiente angular do perfil de temperatura para o Trecho 01
yy=0:dL:yt; %%profundidade
LL=0:dL:Lt;%comprimento total da tubulação
theta1= pi/2; %ângulo do Trecho 1 (rad)
theta2= 0; %ângulo do Trecho 2 (rad)
sum=0; %somatório 
%%  Perfis de temperatura
% 'varia linearmente' T=ax+b
for i= 1:length(yy) %TRECHO 01 - PROFUNDIDADE DE 0m A 3000m - PERFIL DE TEMPERATURA CARACTERÍSTICO.
    if yy(i) < 3000
    T(i)= a* yy(i)+ 25;
    mi(i)= 0.0521*exp(-0.043*T(i));
    A(i)= (pi*(d1)^2)/4;
    v(i)= Q/A(i);
    Re(i)= (rho*v(i)*d1)/(mi(i));
    fd(i)=64/(Re(i));
    else
    T(i)=0;
    mi(i)= 0.0521*exp(-0.043*T(i));
    A(i)= (pi*(d2)^2)/4;
    v(i)= Q/A(i);
    Re(i)= (rho*v(i)*d2)/(mi(i));
    fd(i)=64/(Re(i));
    end
end

for k=1:length(LL)
    if LL(k) > 3000
        yy(i)= 3000;
    end
end

[t]=[T]';
[a]=[A]';
[V]=[v]';
[YY]=[yy]';
[RE]=[Re]';
[MI]=[mi]';
[FD]=[fd]';

for j=1:length(LL)
    if LL(j) < 3000
    PC_f(j)= (fd(i)*rho*(v(i)^2)*LL(j))/(2*d1); %Pascal
            %sumf(i)=sum+PC_f(i)
    PC_g(j)= rho*g*sin(theta1)*LL(j); %Pascal
            %sumg(i)=sum+PC_g(i)
            %Pmin(i)= CP +sumf(i) - sumg(i)
    else
    PC_f(j)= (fd(i)*rho*(v(i)^2)*LL(j))/(2*d2); %Pascal
            %sumf(i)=sum+PC_f(i)
    PC_g(j)=0;
    end
end
 for k=1:length(LL)
            if LL(k) >= 3000
            PC_f(k)= (fd(k)*rho*(v(k)^2)*LL(k))/(2*d2); %Pascal
            %sumf(i)=sum+PC_f(i)
            PC_g(k)= rho*g*sin(theta2)*LL(k); %Pascal
            %sumg(i)=sum+PC_g(i)
            %Pmin(i)= CP +sumf(i) - sumg(i)
            else
            PC_f(k)=0;
            PC_g(k)=0;
            end
end


[PC_F]=[PC_f]';
[PC_G]=[PC_g]';
x= table(YY,t,V,RE,MI,FD,'VariableNames',{'profundidade(m)','temperatura(°C)','velocidade(m/s)','Reynolds','Viscosidade(Pa.s)','fator de fric'})

%%Cálculos da Equação Gera da Perda de carga
% for j=1:length(LL)
%     mi(i)= 0.0521*exp(-0.043*T(i));
%     A(i)= (pi*(d1)^2)/4;
%     v(i)= Q/A(i);
%     Re(i)= (rho*v(i)*d1)/(mi(i));
%     fd(i)=64/(Re(i));
%     PC_f(i)= (fd(i)*rho*(v(i)^2)*LL(i))/(2*d1); %Pascal
%     sumf(i)=sum+PC_f(i)
%     PC_g(i)= rho*g*sin(theta1)*LL(i); %Pascal
%     sumg(i)=sum+PC_g(i)
%     Pmin(i)= CP +sumf(i) - sumg(i)
%     else
%     T(i)=4;
%     mi(i)= 0.0521*exp(-0.043*T(i));
%     A(i)= (pi*(d2)^2)/4;
%     v(i)= Q/A(i);
%     Re(i)= (rho*v(i)*d2)/(mi(i));
%     fd(i)=64/(Re(i));
%     PC_f(i)= (fd(i)*rho*(v(i)^2)*yy(i))/(2*d2); %Pascal
%     sumf(i)=sum+PC_f(i)
%     PC_g(i)= rho*g*sin(theta2)*yy(i); %Pascal
%     sumg(i)=sum+PC_g(i)
%     Pmin(i)= CP +sumf(i) - sumg(i)
%     end
%     end
% end

% for j=1:length(LL) %%TRECHO 02 - TEMPERATURA CONSTANTE - PROFUNDIDADE CONSTANTE
%     T2(i)=4;
%     yy2(i)=3000;
%     mi2(i)= 0.0521*exp(-0.043*T2(i));
%     A2(i)= (pi*(d2)^2)/4;
%     v2(i)= Q/A2(i);
%     Re2(i)= (rho*v2(i)*d2)/(mi2(i));
%     fd2(i)=64/(Re2(i));
%     PC_f2(i)= (fd2(i)*rho*(v2(i)^2)*LL(i))/(2*d2); %Pascal
%     PC_g2(i)=0;
% end
% [YY2]=[yy2]';
% [Y]=[YY + YY2];
% [PC_F2]=[PC_f2]';
% [PCF]=[PC_F + PC_F2];
% [PC_G2]=[PC_g2]';
% [PCG]=[PC_G + PC_G2];
% [a2]=[A2]';
% [Area]=[a + a2];
% [V2]=[v2]';
% [Vel]=[V + V2];
% [t2]=[T2]';
% [Temp]=[t + t2];
% [RE2]=[Re2]';
% [Rey]=[RE + RE2];
% [MI2]=[mi2]';
% [Visc]=[MI + MI2];
% [FD2]=[fd2]';
% [Fd_]=[FD + FD2];
% % [PMIN]=[Pmin]'
