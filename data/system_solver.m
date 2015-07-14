clear

syms f1 f2 ksv1 ksv2 clear

% (f1/(1+ksv1*Q))+(f2/(1+ksv2*Q))== I/I0

I0 = 2376.4;
Ione = 2148.6; % from analyzed data
Q1 = 1;
I10 = 1000.8;
Q10 = 10;
I21 = 736.52;
Q21 = 21;

eq1=(f1/(1+Q1*ksv1))+(f2/(1+Q1*ksv2))==(Ione/I0);
eq2=(f1/(1+Q10*ksv1))+(f2/(1+Q10*ksv2))==(I10/I0);  
eq3=(f1/(1+Q21*ksv1))+(f2/(1+Q21*ksv2))==(I21/I0);
eq4= f1 + f2 == 1;

%solve([x^2+y == 5, x^2+y^2 == 7],[x, y])

[solf1, solf2, solksv1, solksv2] = vpasolve([eq1, eq2, eq3, eq4], [f1, f2, ksv1, ksv2])