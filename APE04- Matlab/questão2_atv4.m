%% DADOS DE ENTRADA

dg=0.75; % Densidade do Gás (/)
mi=1.8e-5; % Viscosidade do Gás (Pa*s)
Qsc=1.607; % Vazão de Superfície (m3/s)
tol=1e5; % Tolerância (Pa)
theta=90; % ângulo de Inclinação (º) 
theta_rad=(theta*pi)/180; %Ângulo de Inclinação (rad)
p_inicial=13830e3;  % Pressão Inicial (Pa)
t_inicial=316.45;  % Temperatura Inicial (K)

psc=101325; % Pressão de Superfície - Separador (Pa)
tsc=288.15; % Temperatura de Superfície - Separador (K)
M_ar=0.02896; % Massa Específica do Ar (kg/mol)
R=8.314; % Cte dos Gases

d=62e-3; % Diâmetro da Tubulação (m)
r=0.0231e-3; % Rugosidade Absoluta da Tubulação (m)

L=1524; % Comprimento do Trecho (m)
dL=762; % Comprimento do Segmento (m)
MD=[0:dL:L]'; % Vetor Comprimento (m)
n=L/dL; % Número de Pontos

t_0=316.45; % Temperatura Inicial (K)
p_0=13830e3; % Pressão Inicial (Pa)

dTdL=0.0375; % Variação de Temperatura (K/m)
dPdL=1.134e3; % Variação de Pressão (Pa/m)

% Temperatura e Pressão Pseudocrítica
if dg < 0.75
    ppc=(677-15*dg-37.5*(dg^2))*6894.76; % Psia para Pa
    tpc=(168+325*dg-12.5*(dg^2))*(5/9); % Rankine para Kelvin
else
    ppc=(706-51.7*dg-11.1*(dg^2))*6894.76; % Psia para Pa
    tpc=(187+330*dg-71.5*(dg^2))*(5/9); % Rankine para Kelvin
end

%% CÁLCULOS

for i=1:n
    t_est(i)=t_0+(dTdL*dL); % Temperatura Estimada
    
    T(i)=(t_0+t_est(i))/2; % Temperatura Média
        
    tpr(i)=T(i)/tpc; % Temperatura Pseudoreduzida
        
    p_est(i)=p_0+(dPdL*dL); % Pressão Estimada 
    
    iter(i)=0;
    
    while (1)
        
        iter(i)=iter(i)+1;
        
        P(i)=(p_0+p_est(i))/2; % Pressão Média 
                          
        ppr(i)=P(i)/ppc; % Pressão Pseudoreduzida
                
        % Fator Z (Papay)
        Z(i)=1-((3.53*ppr(i))/(10^(0.9813*tpr(i))))+((0.274*(ppr(i)^2))/(10^(0.8157*tpr(i))));
                
        % Fator Volume Formação do Gás 
        bg(i)=(psc/tsc)*((T(i)*Z(i))/P(i)); % m3/m3std
                
        % Vazão "in situ"
        Q(i)=Qsc*bg(i); % m3/s
                
        %Velocidade
        v(i)=(4*Q(i))/(pi*(d^2)); % m/s
                
        % Massa Específica
        rho(i)=(M_ar*dg*P(i))/(Z(i)*R*T(i)); % kg/m3
                
        % Número de Reynolds
        re(i)=(rho(i)*v(i)*d)/mi;
                
        if re(i) <= 2300
            fd(i)=64/re(i); %esc. laminar
        else
            fd(i)=0.0055*(1+((((2e4*r)/d)+(1e6/re(i)))^(1/3))); % Esc. Turb. - Hall
        end
                
        % Gradiente Gravitacional
        grad_g(i)=rho(i)*9.81*sin(theta_rad); % Pa/m
                
        % Gradiente de Fricção
        grad_f(i)=(fd(i)*rho(i)*(v(i)^2)/(2*d)); % Pa/m
                
        % Gradiente Total 
        grad_total(i)=(-grad_g(i))+(-grad_f(i)); % Pa/m
                
        % Variação de Pressão
        delta_p(i)=grad_total(i)*dL; % Pa
                
        % Pressão Calculada
        p_calc(i)=p_0-delta_p(i); % Pa
        
        if abs(p_calc(i)-p_est(i)) < tol
            break
        else
            p_est(i)=p_calc(i);
        end
    end
    p_0=p_calc(i);
    t_0=t_est(i);
end

P_CALC=[p_calc]';
TEMP=[t_est]';

ps=[p_inicial t_inicial; P_CALC TEMP];

res=[MD ps];