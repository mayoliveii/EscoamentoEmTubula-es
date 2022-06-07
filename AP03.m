clearvars;clc;
%% Coleta dados
CP= 55860; %contrapressão na ANM (kPascal)    
L1= 3000;  %comprimento do trecho 1 (m)
disp(['Comprimento do Trecho 01: ',num2str(L1),'m'])
L2=5000;   %comprimento do trecho 2 (m)
disp(['Comprimento do Trecho 02: ',num2str(L2),'m'])
Lt= L1+L2; %comprimento total da tubulação (m)
disp(['Comprimento total da tubulação: ',num2str(Lt),'m'])
yi= 3000; %profundidade (m)
disp(['Profundidade total: ',num2str(yi),'m'])
d1= 0.0127; %diâmetro 1 (m)
T_s= 25;  %temperatura da superfície (°C)
T2= 4;
disp(['Temperatura na superfície: ',num2str(T_s), '°C'])
disp(['Temperatura no Trecho 2: ',num2str(T2), '°C (cte)'])
e= 0.000178; % porosidade absoluta (m)
d2= 0.00952; % diâmetro 2 (m)
g=9.81;   %gravidade (m/s²)
dL= 200; %m
n= Lt/dL; %números de linha 
rho=1114; % massa específica do MEG (kg/m³)
Q= 1.3889e-5; %vazão (m³/s)
a=-0.007; %coeficiente angular do perfil de temperatura para o Trecho 01
yy=0:dL:Lt; %%profundidade
LL=0:dL:Lt;%comprimento total da tubulação
theta1= pi/2; %ângulo do Trecho 1 (rad)
theta2= 0; %ângulo do Trecho 2 (rad)
disp(['Ângulo de inclinação do trecho 1: ',num2str(theta1), ' rad'])
disp(['Ângulo de inclinação do trecho 2: ',num2str(theta2), ' rad'])
disp(['Número de linhas da tabela: ',num2str(n)])
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
        for j=1:length(LL)
            if LL(j) < 3000
            PC_f(j)= ((fd(i)*rho*(v(i)^2)*LL(j))/(2*d1))/1000; %kPascal
            sumf(j)=sum+PC_f(j);
            PC_g(j)= (rho*g*sin(theta1)*LL(j))/1000; %kPascal
            sumg(j)=sum+PC_g(j);
            Pmin(j)= CP +sumf(j) - sumg(j);
            end
        end
    else %TRECHO 02 - TEMPERATURA CONSTANTE (4°C)- PROFUNDIDADE CONSTANTE y=3000m
    T(i)=4; 
    yy(i)=yi;
    mi(i)= 0.0521*exp(-0.043*T(i));
    A(i)= (pi*(d2)^2)/4;
    v(i)= Q/A(i);
    Re(i)= (rho*v(i)*d2)/(mi(i));
    fd(i)=64/(Re(i));
       for j=1:length(LL)
           if LL(j) >= 3000
           PC_f(j)= (((fd(i)*rho*(v(i)^2))/(2*d2))*LL(j))/1000; %kPascal
           sumf(j)=sum+PC_f(j);
           PC_g(j)=0;
           sumg(j)=sum+PC_g(j);
           Pmin(j)= CP +sumf(j) - sumg(j);
           end
       end
    end
end
[t]=[T]';
[a]=[A]';
[V]=[v]';
[YY]=[yy]';
[RE]=[Re]';
[MI]=[mi]';
[FD]=[fd]';
[PC_F]=[PC_f]';
[PC_G]=[PC_g]';
[P_min]=[Pmin]';

table(YY,t,V,RE,MI,FD,PC_F,PC_G,P_min,'VariableNames',{'profundidade (m)','Temperatura(°C)','Velocidade (m/s)','Reynolds','Viscosidade (Pa.s)','Fator de fricção','Perda de Carga por fricção(kPa)','Perda de carga gravitacional(kPa)','Pressão mínima (kPa)'})