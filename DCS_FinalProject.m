%% Digital Communications System (2021 Spring) 
%%           Final Project                     
%             2019146018 송연주                            

close all;clear;clc;

%% 1) Random binary 송신 신호 생성
n = 10^7;
a_n = 2*floor(2*rand(1,n)) - 1;   % P(1) = P(-1) = 0.5   

%% 2) BPSK 변조 후 AWGN 채널 통과할 때 BER
% y = x + n
% n ~ N(0,N0/2)

SNR_dB = 0:2:20;
SNR = 10.^(SNR_dB/10);

x = a_n;
BER = zeros(1,length(SNR_dB));
noise_AWGN = sqrt(0.5).*randn(1,n);   

for k=1:length(SNR)
    y = (sqrt(SNR(k))*x) + noise_AWGN;
    BER(k) = length(find((y.*x)<0));
end
BER=BER/n;

% AWGN 채널 시뮬레이션
semilogy(SNR_dB,BER,'co','linewidth',2.0);
hold on

% AWGN 채널 이론값
AWGN_theory_ber = 0.5.*erfc(sqrt(SNR));         % Pb = Q(sqrt(2SNR))
semilogy(SNR_dB,AWGN_theory_ber,'b--','linewidth',2.0);
hold on

%% 3) Rayleigh 페이딩 채널
% y = hx + n  
% h ~ CN(0,1)
% n ~ CN(0,N0)

h = sqrt(0.5).*(randn(1,n) + 1i*randn(1,n)); 
noise_Rayleigh = sqrt(0.5).*(randn(1,n) + 1i*randn(1,n));

for k=1:length(SNR)
    y = h.*((sqrt(SNR(k))*x)) + noise_Rayleigh;
    r = conj(h)./abs(h).*y;         % coherent detection
    BER(k)=length(find((r.*x)<0));
end
BER=BER/n;

% Rayleigh 채널 시뮬레이션 
semilogy(SNR_dB,BER,'ms', 'linewidth' ,2.0);
hold on

% Rayleigh 채널 이론값
Rayleigh_theory_ber = 0.5*(1-(sqrt(SNR./(1+SNR))));
semilogy(SNR_dB, Rayleigh_theory_ber,'r-','linewidth',2.0);

% 최종 결과 그래프 설정
title('Bit Error Rate, AWGN vs. Rayleigh')
xlabel('SNR (dB)')
ylabel('P_{b}')
legend( 'AWGN (sim)','AWGN (theory)','Rayleigh (sim)','Rayleigh (theory)')
axis ([0 20 1e-6 10^0])
grid