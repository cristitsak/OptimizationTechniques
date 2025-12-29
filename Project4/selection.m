% Συνάρτηση υλοποίηση tournament selection
function new_data = selection(data, error, population_size, length)
    new_data = zeros(population_size, length);
    for k = 1 : population_size
        value1 = randi(population_size);
        value2 = randi(population_size);
        value3 = randi(population_size);
        
       competitiors = [error(value1), error(value2), error(value3)];
       [~, index] = min(competitiors);
        
       if index == 1
            new_data(k, :) = data(value1, :);
       elseif index == 2
           new_data(k, :) = data(value2, :);
       elseif index == 3
           new_data(k, :) = data(value3, :);
       end
       
    end

end