clear;
close all;
clc;
global N a b
N = 20;
a = 0;
b = 7.85e-2;
x = linspace(a,b,N);
tSpan = [0 500];
IC = zeros(7*N,1); 
for i=1:N
    IC(i)=0.02;
    IC(N+i)=0.02;
    IC(2*N+i)=0.01;
    IC(3*N+i)=0.02;
    IC(4*N+i)=0;
    IC(5*N+i)=300;
    IC(6*N+i)=300;
end
[tSol,C] =  ode15s('scm',tSpan,IC); 
C(:,1) = 0.02;
C(:,N+1) = 0.02;
C(:,2*N+1) = 0.01;
C(:,3*N+1) = 0;
C(:,5*N+1) = 650;
C(:,6*N+1) = 650;
Cm_1(:,1:N) = C(:,1:N);
Cs_1(:,1:N) = C(:,N+1:2*N);
Cm_2(:,1:N) = C(:,2*N+1:3*N);
Cs_2(:,1:N) = C(:,3*N+1:4*N);
th(:,1:N)=C(:,4*N+1:5*N);
T_f(:,1:N)=C(:,5*N+1:6*N);
T_s(:,1:N)=C(:,6*N+1:7*N);
M = length(tSol);
figure(1)
% mesh(x,tSol,Cs_1)
for i=1:N
    plot(tSol,1-Cm_1(:,i)./Cm_1(1,1))
    hold on
end
figure(2)
for i=1:N
    plot(tSol,T_s(:,i))
    hold on
end
% mesh(x,tSol,Cm_1)
