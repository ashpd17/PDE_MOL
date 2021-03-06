function dCdt = scm(t,y)
%Parameters
global N a b
u = 2; %m/s
R_w = 1.81e-8; %m
delta_c = 3e-5; %m
delta_w = 63.6e-6; %m
e_wc = 0.41;
P = 1.01325e5; % Pa
%T = 700; %K
k_f = 0.0386; %W/m.K
k_w = 1.5;%W/m.K
Cpf = 1068; %J/kg.K
Cpw = 1000; %J/kg.K
rho_w = 2000; %kg/m3
rho_f = 0.6; %kg/m3
H1 = 283e3; %J/mol
H2 = 100e3; %J/mol
H3 = 183e3; %J/mol
hf = 3.2*(k_f/(4*R_w));
R = 8.314; %J/mol
TOSC = 200;
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
%Temp
T_f(1) = 650;
T_s(1) = 650;
T_f(2:N) = y(5*N+2:6*N);
T_s(2:N) = y(6*N+2:7*N);
dCdt = zeros(7*N,1);

%Diffusivity and Kinetic Constant
D = zeros(N,1);
k1 = zeros(N,1);
k2 = zeros(N,1);
k3 = zeros(N,1);
Ka1 = zeros(N,1);
k_me = zeros(N,1);
for i=1:N
    D(i) = (9.56e-10)*T_f(i)^1.75;
    k_me(i) = 0.75*D(i)/R_w;
    k1(i) = 9.18e18*exp(-105e3/(R*T_f(i)))/T_f(i);
    k2(i) = 9.2e13*exp(-80e3/(R*T_f(i)))*200;
    k3(i) = 1.8e7*exp(-75e3/(R*T_f(i)))*200;
    Ka1(i) = 65.5*exp(7.99e3/(R*T_f(i)));
end

%Gas Balance
dCdt(1) =  -u*(Cm_1(2)-Cm_1(1))/h - k_me(1)*(Cm_1(1)-Cs_1(1))/R_w;
dCdt(2*N+1) =  -u*(Cm_2(2)-Cm_2(1))/h - k_me(1)*(Cm_2(1)-Cs_2(1))/R_w;

for i=2:N
    dCdt(i) = -u*(Cm_1(i)-Cm_1(i-1))/h - k_me(i)*(Cm_1(i)-Cs_1(i))/R_w;
    dCdt(2*N+i) = -u*(Cm_2(i)-Cm_2(i-1))/h - k_me(i)*(Cm_2(i)-Cs_2(i))/R_w;
end
%Washcoat Balance
C_t = P/(R*T_f(1));
for i=1:N
    r1 = k1(i)*Cs_1(i)*Cs_2(i)/(1+Ka1(i)*Cs_1(i))^2;
    r2 = k2(i)*Cs_2(i)*(1-th(i));
    r3 = k3(i)*Cs_1(i)*th(i);
    dCdt(N+i) = (k_me(i)/(e_wc*delta_c))*(Cm_1(i)-Cs_1(i)) + (-r1 - r3)/(e_wc*C_t);
    dCdt(3*N+i) = (k_me(i)/(e_wc*delta_c))*(Cm_2(i)-Cs_2(i)) + (-0.5*r1-0.5*r2)/(e_wc*C_t);
    dCdt(4*N+i) =  (r2-r3)/(2*TOSC);
end

%Energy Balance
for i=2:N-1
    r1 = k1(i)*Cs_1(i)*Cs_2(i)/(1+Ka1(i)*Cs_1(i))^2;
    r2 = k2(i)*Cs_2(i)*(1-th(i));
    r3 = k3(i)*Cs_1(i)*th(i);
    dCdt(5*N+i) = -u*(T_f(i)-T_f(i-1))/h + (hf/(R_w*rho_f*Cpf))*(T_s(i)-T_f(i));
    dCdt(6*N+i) = (k_w/(rho_w*Cpw))*(T_s(i+1)-2*T_s(i)+T_s(i-1))/h^2 - (hf/(delta_w*rho_w*Cpw))*(T_s(i)-T_f(i))+(delta_c/(delta_w*rho_w*Cpw))*(r1*H1+r2*H2+r3*H3);
end
dCdt(6*N+1) = dCdt(6*N+2);
dCdt(7*N) = dCdt(7*N-1);
end