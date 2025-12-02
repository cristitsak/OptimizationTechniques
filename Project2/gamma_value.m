function g = gamma_value(i, func, gamma, point, d, grad_f)
    if i == 1       % γ σταθερά
        g = gamma;
    elseif i == 2   % ελαχιστοποίηση ως προς γ (golden method)
        phi_gi = @(gi) func(point(1) + gi*d(1), point(2) + gi*d(2));
        
        a = 0;
        b = 3;
        l = 0.01;

        golden_obj = golden(phi_gi, a, b, l);
        golden_data = golden_obj.Calc();

        numSearch = golden_data.iterations();
        if numSearch > 1
            avg = (golden_data.a_history(numSearch-1) + golden_data.b_history(numSearch-1)) / 2;
            g = avg;
        else
            g = gamma; % fallback
        end

    elseif i == 3   % κανόνας Armijo
        alpha = 0.001;
        beta = 0.25;
        f0 = func(point(1), point(2));
        g = gamma;

        maxArmijo = 50;
        armijo_count = 0;
        
        while func(point(1) + g*d(1), point(2) + g*d(2)) > f0 + alpha * g * (grad_f' * d)
            g = g * beta;
            armijo_count = armijo_count + 1;
            
            if armijo_count > maxArmijo
                warning('Armijo exceeded maximum iterations');
                break;
            end
        end
    end
end