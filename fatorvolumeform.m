clear;clearvars;

pb=2800; %2200-2800
dg=0.8;
T=80; %farenheit
API=37.9;
n=8;
do=0.85;
pmin=2200;
pmax=2800;
p=linspace(pmin,pmax,n)'; %Faixa de pressões
%RSO
a=10e-10


% 
%  if p <= pb
%       j(i)= exp(4.768 - 0.8359 *log(Rs(i)+300));
%       k= 0.555 + 133.5/(Rs(i) + 300);
%       Mi_o(i) = j.* (Mi_od).^k;
%   else
%       miob(i) = j.* Mi_od.^k;
%       alpha(i) = 6.5698e-7*log(miob(i))^2 - (1.48211e-5) * log(miob(i))+2.27877e-4;
%       bheta(i) = 2.24623e-2*log(miob(i)) + 0.873204;
%       Mi_o(i)= miob(i) * exp(alpha(i) * ((p(i)-pb)^bheta(i)));
      
      
      
for i = 1:length(p)
a = 2.8869 - (14.1811 - 3.3093 * log10(p(i)))^0.5;
Rs(i)= dg * (((API^0.989)/(T^0.172)*10^a)^1.2255);
end
RS= [Rs]'



  %Viscosidade
%óleo morto - bergman
X = 1*exp(22.33 - 0.194*API + 0.00033 * API^2 - (3.2-0.0185*API)*log(T+310));
mi_od= 1*exp(X) -1;
%óleo saturado - bergman
for i=1:n
    if p(i) < pb
    aa(i)= exp(4.768-0.8359*log(Rs(i)+300));
    bb(i)= 0.555 + (133.5/(Rs(i)+300));
    mi_ob(i)= (aa(i))*(mi_od^bb(i));
    end
end
for i=1:n
    if p(i) > pb
    alpha(i)= 6.5698e-7 * log(mi_ob(i))^2 - (1.48211e-5) * log(mi_ob(i)) + 2.27877e-4;
    bheta(i)= 2.24623e-2 * log(mi_ob(i)) + 0.873204;
    mi_o(i)= mi_ob(i) * exp(alpha(i)* ((p(i)- pb)^bheta(i)))
    end
end
for i=1:n
    if p(i)== pb
    as(i)= exp(4.768-0.8359*log(Rsb+300));
    bs(i)= 0.555 + (133.5/(Rsb+300));
    mi_ob(i)= (as(i))*(mi_od^bs(i))   
    end
end




%Bo
  
for i = 1:length(p)
    Bob(i) = Rs(i) .* ((dg/do)^0.526)+ 0.986*T;
    Bo(i)=  1 + 10^(-6.58511+2.91329*log10(Bob(i))-0.27683*((log10(Bob(i)))^2));
end
BO= [Bo]'
%       Bo(i)= 1 + 10.^(-6.58511 + 2.91329 * log10(Bob(i))-0.2768 * (log10(Bob(i))^2));
% end
% BO= [Bo]'log(10)