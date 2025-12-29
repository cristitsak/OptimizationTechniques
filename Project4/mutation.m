% Συνάρτηση μετάλλαξης συντελεστών των gaussian του population εντός αποδεκτών ορίων
function new_data = mutation(data, population_size, bounds, N_gaussians)
    new_data = data;
    Pm = 0.1;
    
    for k = 1:population_size
        for j = 1:N_gaussians
            idx = (j-1)*5 + 1;
            
            if rand() < Pm
                range = bounds.w(2) - bounds.w(1);
                new_data(k, idx) = data(k, idx) + randn() * 0.1 * range;
                new_data(k, idx) = max(bounds.w(1), min(bounds.w(2), new_data(k, idx)));
            end
            
            if rand() < Pm
                range = bounds.c1(2) - bounds.c1(1);
                new_data(k, idx+1) = data(k, idx+1) + randn() * 0.1 * range;
                new_data(k, idx+1) = max(bounds.c1(1), min(bounds.c1(2), new_data(k, idx+1)));
            end
            
            if rand() < Pm
                range = bounds.c2(2) - bounds.c2(1);
                new_data(k, idx+2) = data(k, idx+2) + randn() * 0.1 * range;
                new_data(k, idx+2) = max(bounds.c2(1), min(bounds.c2(2), new_data(k, idx+2)));
            end
            
            if rand() < Pm
                range = bounds.sigma1(2) - bounds.sigma1(1);
                new_data(k, idx+3) = data(k, idx+3) + randn() * 0.1 * range;
                new_data(k, idx+3) = max(bounds.sigma1(1), min(bounds.sigma1(2), new_data(k, idx+3)));
            end
            
            if rand() < Pm
                range = bounds.sigma2(2) - bounds.sigma2(1);
                new_data(k, idx+4) = data(k, idx+4) + randn() * 0.1 * range;
                new_data(k, idx+4) = max(bounds.sigma2(1), min(bounds.sigma2(2), new_data(k, idx+4)));
            end
        end
    end
end