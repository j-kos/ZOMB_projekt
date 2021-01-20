clear 
close all

%Czestotliwosc szumu
f0=60;
%Częstotliwośc probkowania
fs=250;
%Omega
omega = (2*pi*f0)/fs;
raw_ecg_mat       = load("raw_signal_fantasia_signal_1.mat")'; % zaszumiony sygnal EKG -> wejscie
ekg        = raw_ecg_mat.x;
B = 1;
%Warunki początkowe
A = [2*cos(omega) -1; 1 0];
b = [1;0];
h = [1;0];
noiseEstimator=A*[B;B];
P0 = [1 0; 0 1];
qn=10^(-10); 


for i=2:length(ekg)
    noiseEstimator=A*noiseEstimator;

    rn=(1/length(ekg));
    
    Pn=A*P0*A' + qn*b*b';
    
    Kn=Pn*h*((h'*Pn*h+rn)^-1);
    
    noiseEstimator=noiseEstimator + Kn*(ekg(i)-h'*noiseEstimator);
    
    Pn=(eye(2,2)-Kn*h')*Pn;
    
    P0 = Pn;
    
    filteredSignal(i-1)=ekg(i-1)-noiseEstimator(2);
end
filteredSignal(i)=ekg(i)-noiseEstimator(2);


figure(1)
plot(filteredSignal)
title('Denoise ECG');
xlabel('time');
ylabel('amplitude');
figure(2);
plot(ekg);
title('Original ECG');
xlabel('time');
ylabel('amplitude');