clear all; clc; clearvars;
pb=2480;
dg=0.8;
T=580-459.67; %temperatura em farenheit
API=37.9;
n=8;

pmin=input('Insira uma Pressão Mínima (psi): ');
pmax=input('Insira uma Pressão Máxima (psi): ');
p=linspace(pmin,pmax,n)'; %Faixa de pressões

for i = 1:length(p)
a = 2.8869 - (14.1811 - 3.3093 * log10(p(i)))^0.5;
Rs(i)= dg * (((API^0.989)/(T^0.172)*10^a)^1.2255);
end
RS= [Rs]';
tabela = [p  RS]
fprintf('Pressão              RSO     \n')
fprintf('%4.3f          %4.3f \n',tabela)

% num2str(Rs);
% disp(Rs);disp(p) ;
%(((API^(0.989))/((T+460)^(0.172)) * 10^a)^1.2255