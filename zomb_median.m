function m = zomb_median(signal, w)   
    % Funkcja implementująca filtr medianowy
    % Dane wejsciowe:
    % signal -> sygnał referencyjny 
    % w -> rozmiar okna czasowego
    % Dane wyjściowe:
    % m - przefiltrowany sygnał
    signal = signal(:)';
    w2 = floor(w/2);
    w = 2*w2 + 1;

    n = length(signal);
    m = zeros(w,n+w-1);
    sample0 = signal(1); 
    samplel = signal(n);

    for i=0:(w-1)
        m(i+1,:) = [sample0*ones(1,i) signal samplel*ones(1,w-i-1)];
    end
    m = median(m);
    m = m(w2+1:w2+n);