clearvars; clear; clc;
%% Dados GERAIS do enunciado
e= 1.778e-5; %rugosidade em metro”
Q= 0.03154; %vazão em m³/s
Mi= 0.001; %viscosidade em Pa.s
rho= 1042.49 ; %massa específica do fluido em kg/m³
dL_DC=304.8; %comprimento do DC em metro
dL_HWDP= 457.2; %comprimento do HWDP em metro
dL_t= 762; %profundidade total em metro
theta= 90; % ângulo da tubulação
dP_p= 10325; % Peneiras operando a pressão atmosférica em Pa
dP_s= 482633; %Equipamentos de Sup. Tipo IV em Pa
dP_b= 689476; %Jatos da broca em Pa

%% Cálculo da perda de carga PARA A TUBULAÇÃO
%*******************PARA O DC**************************************
D= 0.13017; %diâmetro em metro DC
A= pi*D^2/4; %área em m² 
v= Q/A; %velocidade em m/s
Re= rho*v*D/Mi;
   if Re <= 2300
       fd=64/Re; %esc. laminar
   else
       fd=0.0055*(1+((2e4*(e/D)+(10^6/Re))^(1/3)));%esc. turbulento
   end
dP_f_DC=  fd*rho*(v^2)/(2*D)*dL_DC;
%*******************PARA O HWDP**************************************
D2= 0.168275; %diâmetro em metro DC
A2= pi*D2^2/4; %área em m² 
v2= Q/A2; %velocidade em m/s
Re2= rho*v2*D2/Mi;
   if Re2 <= 2300
       fd2=64/Re2; %esc. laminar
   else
       fd2=0.0055*(1+((2e4*(e/D2)+(10^6/Re2))^(1/3)));%esc. turbulento
   end
dP_f_HWDP=  fd2*rho*(v2^2)/(2*D2)*dL_HWDP;
%******************PARCELA GRAVITACIONAL*****************************
dP_g= - rho*9.81*sin(theta*pi/180)*dL_t;

%**************PERDA DE CARGA TOTAL DA COLUNA************************
dP_coluna= -dP_f_DC -dP_f_HWDP - dP_g;

%% PERDA DE CARGA NO ANULAR 
%*******************PARA O DC**************************************
sf= sqrt(2/3);
d_o = 0.37465; %diâmetro externo em metro
d_i= 0.244475; %diâmetro interno em metro
d_h_DC=sf*(d_o - d_i);
A3= pi*d_h_DC^2/4; %área em m² 
v3= Q/A3; %velocidade em m/s
Re3= rho*v3*d_h_DC/Mi;
   if Re3 <= 2300
       fd3=64/Re3; %esc. laminar
   else
       fd3=0.0055*(1+((2e4*(e/d_h_DC)+(10^6/Re3))^(1/3)));%esc. turbulento
   end
dP_f2_DC=  fd3*rho*(v3^2)/(2*d_h_DC)*dL_DC;
%****************PARA O HWDP***************************************
d_o = 0.37465; %diâmetro externo em metro
d_i2= 0.20955; %diâmetro interno em metro
d_h_HWDP=sf*(d_o - d_i2);
A4= pi*d_h_HWDP^2/4; %área em m² 
v4= Q/A4; %velocidade em m/s
Re4= rho*v4*d_h_HWDP/Mi;
   if Re4 <= 2300
       fd4=64/Re4; %esc. laminar
   else
       fd4=0.0055*(1+((2e4*(e/d_h_HWDP)+(10^6/Re4))^(1/3)));%esc. turbulento
   end
dP_f2_HWDP=  fd4*rho*(v4^2)/(2*d_h_HWDP)*dL_HWDP;

%**************PERDA DE CARGA TOTAL DO ANULAR***********************
dP_anular= -dP_f2_DC -dP_f2_HWDP + dP_g;

%% CÁLCULO DA PRESSÃO DE BOMBEIO
P_bombeio= dP_coluna + dP_b + dP_anular +dP_p +dP_s;
Pbom= P_bombeio/10^5;
disp([' a) R: A pressão de bombeio é: ',num2str(Pbom),'bar'])
%% PRESSÃO DE FUNDO ATUANDO NO FINAL DA FASE
P_fundo= dP_coluna + dP_b;
Pfund= P_fundo/10^5;
disp([' b) R: A pressão de fundo no final da fase 14 3/4" a uma profundidade de 2500 ft é: ',num2str(Pfund),'bar'])


