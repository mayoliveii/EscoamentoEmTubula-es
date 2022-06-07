clear;clearvars;

pb=1500; %2200-2800
dg=0.8;
T=80; %farenheit
API=28;
n=20;
do=0.85;
pmin=14.7;
pmax=2000;
p=linspace(pmin,pmax,n)'; %Faixa de pressões
%RSO
for i = 1:length(p)
a = 2.8869 - (14.1811 - 3.3093 * log10(p(i)))^0.5;
Rs(i)= dg * (((API^0.989)/(T^0.172)*10^a)^1.2255);
end
RS= [Rs]'

%Bo
for i = 1:length(p)
    Bob(i) = Rs(i) .* ((dg/do)^0.526)+ 0.986*T;
    Bo(i)=  1 + 10^(-6.58511+2.91329*log10(Bob(i))-0.27683*((log10(Bob(i)))^2));
end
BO= [Bo]';

%Co
  for i = 1:length(p)
    if p(i) >= pb
        Co(i) = 1.705e-7 .* (Rs(i)^(0.69357)) * (dg^(0.1885)) * (API^(0.3272)) * ((T+459.67)^(0.6729)) * (p(i)^(-0.5906));
    else
        Co(i)=0;
%       syms Bob Bo
%       derivBo= diff(Bo,p,1);
% %       derivRs= diff(Rs(i),p,1);
%       Co(i) = 1/(Bo(i))*derivBo + Bg(i)/Bo(i)*derivRs;
    end
  end
  CO = [Co]'