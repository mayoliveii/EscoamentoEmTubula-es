function [seno,errop]=senoex2(n,x)
% Mayara Camilo de Oliveira
% EXERCÍCIO DESAFIO   ~~METÓDOS NUMÉRICOS~~
% n= Quantidade de termos
% x= Valor de x de seno(x) 
%% PROCESSAMENTO
switch nargin
    case 0
        error('Informe a quantidade de termos e o valor de x');
    case 1
        error('Informe o valor de x');
end
seno=0;
i=1;
k=1;
while (1)
    fat=1;
    for j=1:k
        fat=fat*j;
    end
    seno = seno + ((-1)^(i+1) * x^(k) / fat) ;
    k=k+2;
    i=i+1;
    errop = abs((sin(n)-(seno))/(sin(n)*100)); %erro percentual
    if i>n,break,end

end



    
    

 