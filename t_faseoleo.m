clearvars;clc; clear;

%% Coleta de dados do usuário
pmin=input('Insira uma Pressão Mínima (psi): ');
pmax=input('Insira uma Pressão Máxima (psi): ');
pb=input('Insira uma Pressão de Bolha (psi): ');
T=input('Insira uma Temperatura em Fahrenheit: ');
API=input('Insira o grau API: ');
dg=input('Insira a Gravidade Específica do Gás: ');
do=input('Insira a Gravidade Específica do Óleo: ');
%% tabela
n=input('Insira o número de linhas da tabela: ');
p=linspace(pmin,pmax,n)'; %Faixa de pressões
%% TRATAMENTO DE DADOS
% Propriedades Pseudocríticas
if dg < 0.75
    Ppc=677+(15.0*dg)-(37.5*(dg^2)); %Ppc em psi
    Tpc=168+(325*dg)-(12.5*(dg^2)); %Tpc em Rankine
else
    Ppc=706-(51.7*dg)-(11.1*(dg^2));
    Tpc=187+(330*dg)-(71.5*(dg^2));
end

% Propriedades Pseudoreduzidas
for i=1:length(p)
    Ppr(i)=p(i)/Ppc;
end

Tpr=(T+459.67)/Tpc;

%% Dados standard
Psc=14.7; %psi (pressão - superfície)
Tsc=60; %Fahrenheit (temperatura - superfície)
R=10.73; % T em #Rankine (constante dos Gases Reais)

%% PROPRIEDADES FASE ÓLEO
% Razão de solubilidade 
for i = 1:length(p)
       a = 2.8869 - (14.1811 - 3.3093 * log10(pb)^0.5);
      Rs(i) = dg * (((API^(0.989)/(( T + 459.67)^(0.172))) * 10^a)^1.2255);
end
%Fator volume formação
  Bob = Rs .* ((dg/do)^(0.526)) + 0.986 *T;
%   p1= -6.58511 +2.91329*log10(Bob);
%   p2= -0.2768*((log(Bob))^2);
for i = 1:length(p)
      Bo(i)= 1 + 10.^(-6.58511 + 2.91329 * log10(Bob(i))-0.2768 * (log10(Bob(i))^2));
end
%Compressibilidade do óleo

  for i = 1:length(p)
    if p(i) >= pb
        Co(i) = 1.705e-7 .* (Rs(i)^(0.69357)) * (dg^(0.1885)) * (API^(0.3272)) * ((T+459.67)^(0.6729)) * (p(i)^(-0.5906)); 
    else
       Co(i) = 0;
    end
  end
  % Viscosidade
a2 = 10.313 * (log(T)) - 36.447;
for i = 1:length(p)
  Mi_oleo(i)= 3.141e10 * (T^(-3.444)) * ((log(API))^a2);
end
%% Gerador de tabela PVT
Tabela= [p Rs Bo Co Mi_oleo]