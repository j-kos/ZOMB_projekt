function coefficients = zomb_lms(sample,offset,buffer,coefficients,fir_length,n)
    
    % Funkcja aktualizujaca wektor wspolczynnikow 
    
    % Dane wejsciowe:
    % sample -> sygnal ze sprzezenia zwrotnego E(n)
    % offset -> wskazuje ostatnie zapisane miejsce w wektorze buffer i
    % coefficients
    % buffer -> wektor sygnalu referencyjnego
    % coefficients -> wektor wspolczynnikow filtru FIR
    % fir_length -> szerokosc wektora coefficients i buffer
    % n -> szybkosc uczenia
    
    % Dane wyjsciowe:
    % coefficients -> zaktualizowany wektor wspolczynnikow filtru FIR
    
    coeff = 1; %wskazuje na aktualne miejsce w wektorze coefficients
    coeff_end = fir_length; %ostatni element wektoru coefficients
    buffer_val = 1 + offset; %wskazuje na aktualne miejsce w wektorze buffer
    
    % Aktualizacja wspolczynnik (uczenie)
    while(buffer_val >= 1)
       coefficients(coeff) = coefficients(coeff) + buffer(buffer_val)*sample*n;
       buffer_val = buffer_val - 1;
       coeff = coeff + 1;
    end
    
    buffer_val = fir_length;
    
    while(coeff <= coeff_end)
        coefficients(coeff) = coefficients(coeff) +  buffer(buffer_val)*sample*n;
         buffer_val = buffer_val - 1;
        coeff = coeff + 1;
    end

end 