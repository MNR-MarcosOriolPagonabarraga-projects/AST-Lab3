function signal = ReferenceGenerator(t, A, w, phase)

    % Generate signal
    signal = A * sin(w*t + deg2rad(phase));   

end