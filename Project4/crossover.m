% Συνάρτηση ανάμειξης δεδομένων μεταξύ gaussian populations
function new_data = crossover(data, population_size, length)
    new_data = zeros(population_size, length);
    for i = 1 : 2 : population_size
        idx1 = i;
        idx2 = i + 1;
        
        if idx2 > population_size
            idx2 = 1;
        end
        
        data_1 = data(idx1, :);
        data_2 = data(idx2, :);
        crossover_point = randi(length - 1);
        new_data(i, :) = [data_1(1:crossover_point), data_2(crossover_point+1:end)];
        new_data(i+1, :) = [data_2(1:crossover_point), data_1(crossover_point+1:end)];
    end
end