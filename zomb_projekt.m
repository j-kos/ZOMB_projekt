%%%%%%%%%%%%%%%%%%%% DANE WEJSCIOWE %%%%%%%%%%%%%%%%%%
clear
close all

fir_length        = 100; % dlugosc filtru 
raw_ecg_mat       = load("raw_signal_person1.mat")'; % zaszumiony sygnal EKG -> wejscie
raw_ecg{1}        = raw_ecg_mat.raw_ecg;
raw_ecg_mat       = load("raw_signal_person3.mat")'; % zaszumiony sygnal EKG -> wejscie
raw_ecg{2}        = raw_ecg_mat.raw_ecg;
raw_ecg_mat       = load("raw_signal_person9.mat")'; % zaszumiony sygnal EKG -> wejscie
raw_ecg{3}        = raw_ecg_mat.raw_ecg;

Fs                = 500; %czestotliwoosc probkowania sygnalu
window            = 20; %wielkość okna filtru medianowego

for m = 1:length(raw_ecg)
    
    t             = linspace(0,1-1/Fs,length(raw_ecg{m})); %podstawa czasu
    
%     figure()
%     plot(t, raw_ecg{m}); %wykres surowego sygnału EKG
%     title(sprintf('Raw ECG data no.%u',m))
    
    figure()
    plot(t(5000:6000), raw_ecg{m}(5000:6000)); %wykres surowego sygnału EKG
    title(sprintf('Raw ECG data no.%u',m))
    
    amplitude_array = [0.1 2 4 10]; %amplituda szumu
    n_array         = [5e-2 5e-3 1e-3 1e-4]; %wspolczynnik szybkosci uczenia
    noise_freq      = 50; %czestotliwosc szumu

    % Wektory sluzace do testow metody
    % Bedziemy testowac metode dla roznych amplitud oraz wspolczynnikow
    % szybkosci uczenia

    figure()
    for j =1:length(amplitude_array)

        for k=1:length(n_array)

            % Inizjalizacja wektorow
            coefficients_sin  = zeros(1,fir_length,"double");
            ref_sin           = zeros(1,fir_length,"double");
            coefficients_cos  = zeros(1,fir_length,"double");
            ref_cos           = zeros(1,fir_length,"double");

            filtered_ecg      = zeros(1,length(raw_ecg{m}), "double"); %odszumiony sygnal EKG

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Wykonaj obliczenia
            offset_sin = 0;
            offset_cos = 0;

            for i=1:length(raw_ecg{m})
                % Generacja referencyjnego sygnalu szumu
                ref_noise = amplitude_array(j)*sin(2*pi/20*(i-1));
                ref_noise1 = amplitude_array(j)*cos(2*pi/20*(i-1));

                % Filtr FIR
                [filtered_sample,offset,ref_sin] = zomb_filter(double(ref_noise), ...
                    offset_sin, ...
                    ref_sin,coefficients_sin, ...
                    fir_length);

                [filtered_sample1,offset_cos,ref_cos] = zomb_filter(double(ref_noise1), ...
                    offset_cos, ...
                    ref_cos, ...
                    coefficients_cos, ...
                    fir_length);
                % Sygnal referencyjny r(n) = w1(n)*x1(n) + w2(n)*x2(n)
                fir = filtered_sample1 + filtered_sample;
                output_signal = raw_ecg{m}(i) - fir;

                % Filtr adaptacyjny LMS
                coefficients_sin = zomb_lms(output_signal, ...
                    offset_sin, ...
                    ref_sin, ...
                    coefficients_sin, ...
                    fir_length, ...
                    n_array(k));
                coefficients_cos = zomb_lms(output_signal, ...
                    offset_cos, ...
                    ref_cos, ...
                    coefficients_cos, ...
                    fir_length, ...
                    n_array(k));
                % Odfiltrowany sygnal EKG
                filtered_ecg(i) = output_signal;

            end

            % Filtr medianowy 
            median_filter_output = zomb_median(filtered_ecg,window);

            % Wizualizacja danych
%             subplot(4,4,k+((j-1)*4))
%             plot(t, median_filter_output);
%             title(sprintf('Filtered ECG data n = %0.1e, A = %u',n_array(k),amplitude_array(j)));
            
            figure
            plot(t(5000:6000),median_filter_output(5000:6000));
            title(sprintf('Filtered ECG data n = %0.1e, A = %u',n_array(k),amplitude_array(j)));
        end
    end
end
  
  
  
