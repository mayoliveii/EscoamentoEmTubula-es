clearvars;clc;
%% Coleta dados
CP= 55860000; %contrapressão na ANM (Pascal)    
L1= 3000;  %comprimento do trecho 1 (m)
L2=5000;   %comprimento do trecho 2 (m)
Lt= L1+L2; %comprimento total da tubulação (m)
yi= 3000; %profundidade (m)
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
yy=0:dL:Lt; %%profundidade
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
    T(i)=4;
    yy(i)=yi;
    mi(i)= 0.0521*exp(-0.043*T(i));
    A(i)= (pi*(d2)^2)/4;
    v(i)= Q/A(i);
    Re(i)= (rho*v(i)*d2)/(mi(i));
    fd(i)=64/(Re(i));
    end
end
[t]=[T]';
[a]=[A]';
[V]=[v]';
[YY]=[yy]';
[RE]=[Re]';
[MI]=[mi]';
[FD]=[fd]';
table(YY,t,V,RE,MI,FD,'VariableNames',{'profundidade (m)','Temperatura(°C)','Velocidade (m/s)','Reynolds','Viscosidade (Pa.s)','Fator de fricção'})