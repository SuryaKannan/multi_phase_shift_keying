%% 
%{

ECE3141 Semester 1 2021 - Multi-Phase-Key-Shifting (PSK) 

- Written by Yuen Fuat & Surya Kannan
- Last edited 15/05/21

Based on M level chosen, the script will output a scatter plot showing how the 
phase of modulated data (random bits) is affected by Gaussian noise
compared to the ideal phase as per the constellation representation 
of the respective M-PSK. 

The script will also output a desired number symbols of the random bit array
and shows the modulated carrier wave to compare symbols and their phases.
When interpreting the plots, the bit which represents the start of 
a new symbol will correspond to when a phase change occurs.
 
RUN INSTRUCTIONS: 
- run section by section
- changeable parameters can be found in this section

REQUIREMENTS: Communications toolbox package 

%}

clear all; close all; clc;

M = 8; % (M= 2^n, n=1,2,3..) 
number_of_symbols = 3; % number of symbols to plot

%% Setting up PSK system

if M==2
    phaseOffset = 0;
else
    phaseOffset = pi/4;
end

bits = randi([0 1],1020,1); % generate an array of random bits

bits_per_symbol = log2(M);

mpskModulator = comm.PSKModulator('ModulationOrder',M,'PhaseOffset',phaseOffset,'BitInput',true,'SymbolMapping','Gray'); 

awgnChannel = comm.AWGNChannel('EbNo',10,'BitsPerSymbol',bits_per_symbol);

mpskDemodulator = comm.PSKDemodulator('ModulationOrder',M,'PhaseOffset',phaseOffset,'BitOutput',true,'SymbolMapping','Gray'); 

%% Modulation and demodulation of data using system

modData = mpskModulator(bits);

channelOutput = awgnChannel(modData);

deModData = mpskDemodulator(channelOutput);

constellation(mpskModulator) % Will be the same for the demodulator

%% Plotting Results - Ideal vs Received

% finding phasors for M-level
phasor = zeros(1,M);

for i = 1:M
    if M == 2
        phasor(i) = complex(cos(pi*(1-i)),sin(pi*(1-i)));
    elseif M == 4
        phasor(i) = complex(cos((2*i-1)*pi/4),sin((2*i-1)*pi/4));
    else
        phasor(i) = complex(cos(pi/4*(i)),sin(pi/4*(i)));
    end
    
end

scatterplot(channelOutput);
hold on;
scatter(real(phasor),imag(phasor), 'r', 'LineWidth', 6)
legend('noise received','ideal sampled signal')
title("Scatterplot for MPSK after AWGN")
grid on;
hold off

%% Plotting Results - Digital Input vs Modulated Carrier

Fc = 100e3; % carrier wave frequency 
T = 0.1e-3; % symbol period
Eb = 1; % energy per bit                      
Es = Eb*log2(M); % energy per symbol 

definition_sin = 100; % number of values per sine wave 
cycles_per_sym = Fc*T; % number of cycles of carrier per symbol (based on symbol duration) 
scale = cycles_per_sym*definition_sin; % number of values of carrier needed per symbol 

t_digital = (0:T:T*length(bits)-T)'; 

t_modulated=(0:T/scale:T*length(modData)-T/scale)'; % time domain of modulated carrier changes depending on bits/symbol

modulated_carrier = zeros(1,length(t_modulated))';

% based on the phase output from modulator (complex), determine the
% corresponding phase shifted carrier for the relevant symbol
for i = 1:length(modData)
    theta = angle(modData(i));
    modulated_carrier(scale*i-(scale-1):scale*i) = sqrt(2*Es/T)*cos(2*pi*Fc*t_modulated(scale*i-(scale-1):scale*i)-theta);
end

subplot(2,1,1)
stairs(t_digital,bits,'LineWidth',3);
hold on
title("Original Randomly Generated Bit Array ("+num2str(bits_per_symbol)+" bits/symbol)")
xlabel("time (sec)")
ylabel("signal amplitude")
stem(t_digital,bits,'filled','o','LineWidth',0.5,'Marker','square');
legend('Digital Signal (extended)','Digital signal (value)')
hold off
xlim([t_digital(1) t_digital(number_of_symbols*bits_per_symbol+1)])
subplot(2,1,2)
plot(t_modulated,modulated_carrier,'r','LineWidth',1)
title(num2str(M)+"-PSK Modulated Carrier Signal ("+num2str(Fc*T)+" Hz/symbol)")
xlabel("time (sec)")
ylabel("signal amplitude")
xlim([t_modulated(1) t_modulated(number_of_symbols*scale)])
