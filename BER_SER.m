%{

ECE3141 Semester 1 2021 - Phase-Shift-Keying (PSK) 

- Written by Yuen Fuat & Surya Kannan
- Last edited 16/05/21

Based on M level chosen, the script will output 2 semilog plots showing how
the bit error rate BER, and symbol error rate SER change with respect to
EB/N0 (SNR/bit).

 
RUN INSTRUCTIONS: 
- run the whole m-file
%}


close all; clear all; clc;
%define Q(x) as a symbol so it can be used for calculation.
syms Q(x) real;


%Initial value
% fc: Carrier frequency
% Eb: Energy per bit
% N0: Noise density
% T: symbol duration
fc = 100e3; Eb = 1; T = 0.1e-3;
Eb_N0_dB = 0:10; 

%Convert from dB to absolute Eb/N0
Eb_N0_real = 10.^(Eb_N0_dB/10);

%definition of Q(x)
%Pb: BER & Ps:SER
Q(x) = 0.5*erfc(x/sqrt(2));
Pb_2 = Q(sqrt(2*Eb_N0_real));
Ps_2 = Pb_2;
Pb_4 = Q(sqrt(2*Eb_N0_real));
Ps_4 = erfc(sqrt(Eb_N0_real));

inner = 2*Eb_N0_real*log2(8);
Ps_8 = 2*Q(sqrt(inner)*sin(pi/8));
Pb_8 = Ps_8/log2(8);

%Plot BER in base-10 logarithmic scale with respect to Eb/N0
semilogy(Eb_N0_dB,Pb_2);
hold on;
semilogy(Eb_N0_dB,Pb_4);
hold on;
semilogy(Eb_N0_dB,Pb_8);
grid on;
legend('BPSK', 'QPSK', '8-PSK');
xlabel('SNR/bit Eb/N0 (dB)');
ylabel('Bit Error Rate BER');
title('Bit error rate probability curve for 2,4,8- PSK modulation');
figure

%Plot SER in base-10 logarithmic scale with respect to Eb/N0
semilogy(Eb_N0_dB,Ps_2);
hold on;
semilogy(Eb_N0_dB,Ps_4);
hold on;
semilogy(Eb_N0_dB,Ps_8);
grid on;
legend('BPSK', 'QPSK', '8-PSK');
xlabel('SNR/bit Eb/N0 (dB)');
ylabel('Symbol Error Rate SER');
title('Symbol error rate probability curve for 2,4,8- PSK modulation');