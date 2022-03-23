function dCdt = scm(t,y)
%Parameters
global N a b T
u = 2; %m/s
R_w = 1.81e-8; %m1 
delta_c = 3e-5; %m
e_wc = 0.41;
P = 1.01325e5; % Pa
%T = 700; %K
D = (9.56e-10)*T^1.75;
k_me = 0.75*D/R_w;
R = 8.314; %J/mol
C_t = P/(R*T);
TOSC = 200;
k1 = 9.18e18*exp(-105e3/(R*T))/T;
k2 = 9.2e13*exp(-80e3/(R*T))*200;
k3 = 1.8e7*exp(-75e3/(R*T))*200;
Ka1 = 65.5*exp(7.99e3/(R*T));
%Getting Concentrations
h = (b-a)/N; 
%A
Cm_1(1) = 0.02;
Cm_1(2:N)=y(2:N);
Cs_1(1)=0.02;
Cs_1(1:N)=y(N+1:2*N);
%O2 
Cm_2(1) = 0.01;
Cm_2(2:N)=y(2*N+2:3*N);
Cs_2(1) = 0.01;
Cs_2(2:N)=y(3*N+2:4*N);
%th 
th(1:N) = y(4*N+1:5*N);
dCdt = zeros(5*N,1);
%Gas Balance
dCdt(1) =  -u*(Cm_1(2)-Cm_1(1))/h - k_me*(Cm_1(1)-Cs_1(1))/R_w;
dCdt(2*N+1) =  -u*(Cm_2(2)-Cm_2(1))/h - k_me*(Cm_2(1)-Cs_2(1))/R_w;

for i=2:N
    dCdt(i) = -u*(Cm_1(i)-Cm_1(i-1))/h - k_me*(Cm_1(i)-Cs_1(i))/R_w;
    dCdt(2*N+i) = -u*(Cm_2(i)-Cm_2(i-1))/h - k_me*(Cm_2(i)-Cs_2(i))/R_w;
end
%Washcoat Balance
for i=1:N
    r1 = k1*Cs_1(i)*Cs_2(i)/(1+Ka1*Cs_1(i))^2;
    r2 = k2*Cs_2(i)*(1-th(i));
    r3 = k3*Cs_1(i)*th(i);
    dCdt(N+i) = (k_me/(e_wc*delta_c))*(Cm_1(i)-Cs_1(i)) + (-r1 - r3)/(e_wc*C_t);
    dCdt(3*N+i) = (k_me/(e_wc*delta_c))*(Cm_2(i)-Cs_2(i)) + (-0.5*r1-0.5*r2)/(e_wc*C_t);
    dCdt(4*N+i) =  (r2-r3)/(2*TOSC);
end

end