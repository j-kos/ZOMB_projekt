function [output,offset,buffer] = zomb_filter(sample,offset,buffer,coefficients,fir_length)
 
    % Funkcja implementująca adaptacyjny filtr FIR
    
    % Dane wejsciowe:
    % sample -> probka sygnalu referencyjnego
    % offset -> wskazuje ostatnie zapisane miejsce w wektorze buffer i
    % coefficients
    % buffer -> wektor sygnalu referencyjnego
    % coefficients -> wektor wspolczynnikow filtru FIR
    % fir_length -> szerokosc wektora coefficients i buffer
    
    % Dane wyjsciowe:
    % output -> probka po filtracji
    % offset -> j.w
    % buffer -> j.w
    
    % Inizjalizacja zmiennej wyjsciowej oraz parametrow niezbednych do
    % poprawnego dzialania aplikacji
    output = double(0); 
    coeff = 1; %wskazuje na aktualne miejsce w wektorze coefficients
    coeff_end = fir_length; %ostatni element wektoru coefficients
    buffer_val = 1 + offset; %wskazuje na aktualne miejsce w wektorze buffer
    buffer(buffer_val) = sample;
    
    % Filtracja w oknie
    while(buffer_val >= 1)
        output = output + buffer(buffer_val)*coefficients(coeff);
        buffer_val = buffer_val - 1;
        coeff = coeff + 1;
    end
    
    buffer_val = fir_length;
    
    while(coeff <= coeff_end)
        output = output + buffer(buffer_val)*coefficients(coeff);
        buffer_val = buffer_val - 1;
        coeff = coeff + 1;
    end
    
    offset = offset +1;
    
    if(offset >= fir_length)
       offset = 0; 
    end
    
end