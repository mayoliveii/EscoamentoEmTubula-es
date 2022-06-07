%% Razão de solubilidade 
pb=2635;
API=40;
T=220.33;
dg=0.8;
n=8
p=linspace(2400,3200,n); %Faixa de pressões
  for i = 1:8
       a = 2.8869 - (14.1811 - 3.3093 * log10(pb)^0.5);
      Rs(i) = dg * (((API^(0.989))/(T^(0.172)) * 10^a)^1.2255);
  end
%  for i = 1:n
%     if p(i) > pb
%       a = 2.8869 - 14.1811 - 3.3093 * log10((pb)^0.5);
%       Rs(i) = dg * ((API^(0.989)/(( T+459.67)^(0.172) * 10^a)^1.2255));
%     else
%       a = 2.8869 - 14.1811 - 3.3093 * log10((p(i))^0.5);
%       Rs(i) = dg * (API^(0.989)/(( T+459.67)^(0.172) * 10^a)^1.2255);
%     end
 
  TABELA = [Rs]