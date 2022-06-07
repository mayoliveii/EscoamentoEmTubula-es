clearvars;clc;
%%PARÂMETROS
Q=1.3889e-5; %Vazão (m3/s)
rho=1114; %Massa específica (kg/m3)
CP=55860e3; %Contra-pressão na ANM (Pa)


%%TRECHO 1
C1=3000; %Comprimento Trecho 1 (m)

theta1=90; %Ângulo do Trecho 1 (graus)

theta1_rad=(theta1*pi)/180; %Ângulo do trecho 1 (radianos)

d1=0.0127; %Diâmetro Trecho 1 (m)

rug1=0.0001778; %Rugosidade Trecho 1 (m)

v1=Q/((pi*(d1^2))/4); %Velocidade do esc. no Trecho 1 (m/s)


%%TRECHO 2
C2=5000; %Comprimento Trecho 2 (m)

theta2=0; %Ângulo do Trecho 2 (graus)

theta2_rad=(theta2*pi)/180; %Ângulo do trecho 2 (radianos)

d2=0.009525; %Diâmetro Trecho 2 (m)

rug2=0.0001778; %Rugosidade Trecho 2 (m)

v2=Q/((pi*(d2^2))/4); %Velocidade do esc. no Trecho 2 (m/s)


%%TUBULAÇÃO TOTAL
L=C1+C2; %Comprimento total da tubulação (m)

dL=200; %Comprimento do Segmento (m) - Discretização

MD=[0:dL:L]'; %Vetor "comprimento medido" da tubulação, variando dL em n pontos (metros);


%%CÁLCULO GRADIENTE DE CARGA

for i=1:length(MD)

    %GRADIENTE DE PRESSÃO GRAVITACIONAL
    if MD(i) <= C1
        pgrav(i)=rho*9.81*sin(theta1_rad)*MD(i); %Trecho 1
    else
        pgrav(i)=rho*9.81*sin(theta2_rad)*MD(i); %Trecho 2
    end
    P_GRAV=[pgrav]';
    
    %GRADIENTE DE PRESSÃO POR FRICÇÃO
    
    %Temperatura, Viscosidade, Reynolds, Fator de Fricção
    if MD(i) <= C1
        t(i)=25-0.007*MD(i);
        mi(i)=0.0521*exp(-0.0439*t(i));
        re(i)=(rho*v1*d1)/mi(i);
        if re(i) <= 2300
            fd(i)=64/re(i); %esc. laminar
        else
            fd(i)=0.0055*(1+(2e4*(rug1/d1)+(10e6/Re(i))^(1/3))); %esc. turbulento
        end
        pfric(i)=(fd(i)*rho*(v1^2)/(2*d1))*MD(i);
    else
        t(i)=4;
        mi(i)=0.0521*exp(-0.0439*t(i));
        re(i)=(rho*v1*d1)/mi(i);
        if re(i) <= 2300
            fd(i)=64/re(i); %esc. laminar
        else
            fd(i)=0.0055*(1+(2e4*(rug2/d2)+(10e6/Re(i))^(1/3))); %esc. turbulento
        end
        pfric(i)=(fd(i)*rho*(v1^2)/(2*d2))*MD(i);
    end
    T=[t]';    
    MI=[mi]';
    RE=[re]';
    FD=[fd]';
    P_FRIC=[pfric]';
end


%%PRESSÃO MÍNIMA
Y=[0:dL:C1]'; %Vetor profundidade
pmin=CP+P_FRIC(length(MD))-P_GRAV(length(Y)); %Pressão mínima requerida na UEP

for i=1:length(MD)
    PMIN(i)=pmin-P_FRIC(i)+P_GRAV(i);
    P_MIN=[PMIN]'; %Pressão em cada trecho do sistema
end


%%RESULTADOS
RES=[MD T MI RE FD P_FRIC P_GRAV P_MIN]