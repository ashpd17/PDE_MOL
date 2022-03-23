clear;
clc;
global N a b
N = 10;
a = 0;
b = 7.85e-2;
x = linspace(a,b,N);
tSpan = [0 1000];
IC = zeros(5*N,1); 
for i=1:N
    IC(i)=0.02;
    IC(N+i)=0.02;
    IC(2*N+i)=0.01;
    IC(3*N+i)=0.02;
    IC(4*N+i)=0;
end
[tSol,C] =  ode15s('scm',tSpan,IC); 
C(:,1) = 0.02;
C(:,N+1) = 0.02;
C(:,2*N+1) = 0.01;
C(:,3*N+1) = 0.01;
Cm_1(:,1:N) = C(:,1:N);
Cs_1(:,1:N) = C(:,N+1:2*N);
Cm_2(:,1:N) = C(:,2*N+1:3*N);
Cs_2(:,1:N) = C(:,3*N+1:4*N);
th(:,1:N)=C(:,4*N+1:5*N);
M = length(tSol);
figure(1)
for i=1:N
    plot(tSol,Cm_1(:,i))
    hold on
end
figure(2)
surf(x,tSol,Cs_1)

