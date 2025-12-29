%% 3D plot της προσεγγιστικής συνάρτησης f για εύρος τιμών
func = @(x, y) sin(x + y) .* sin(y.^2);
u1_range_test = [-20, 13];
u2_range_test = [-17, 19];
u1_range = [-1, 2];
u2_range = [-2, 1];
[x, y] = meshgrid(linspace(u1_range_test(1), u1_range_test(2), 100), linspace(u2_range_test(1), u2_range_test(2), 100));
z = func(x, y);
surf(x, y, z);
colorbar;
xlabel('u1');
ylabel('u2');
zlabel('f(u1,u2)');
title('Γραφική Παράσταση της sin(u1 + u2) * sin(u2^2)');

%% Δημιουργία Training Data στα οποία ελέγχουμε τη τιμή της αναλυτικής και της f για να ελαχιστοποιήσουμε το σφάλμα
N_train = 100;
data = zeros(N_train, 3);

% Τυχαία δειγματοληψία στο πεδίο ορισμού
data(:, 1) = rand(N_train, 1) * (u1_range(2) - u1_range(1)) + u1_range(1);  % u1
data(:, 2) = rand(N_train, 1) * (u2_range(2) - u2_range(1)) + u2_range(1);  % u2

% Υπολογισμός f για κάθε σημείο
for i = 1:N_train
    data(i, 3) = func(data(i, 1), data(i, 2));
end

%% Παράμετροι
N_gaussians = 15;           % πλήθος γκαουσιανών ανά γραμμικό συνδιασμό
population_size = 50;        % πλήθος δειγμάτων προς σύγκριση - βελτιστοποίηση
chromosome_length = 5 * N_gaussians;  % παράμετροι ανά δείγμα - w, c1, c2, σ1, σ2

%% Αρχικοποίηση Δειγμάτων
population = zeros(population_size, chromosome_length);
bounds.w      = [-3,  3];
bounds.c1     = [-1,  2];
bounds.c2     = [-2,  1];
bounds.sigma1 = [0.2, 1.5];
bounds.sigma2 = [0.2, 1.5];

for i = 1:population_size
    for j = 1:N_gaussians
        idx = (j-1)*5 + 1;

        population(i, idx)   = bounds.w(1)      + diff(bounds.w)      * rand();
        population(i, idx+1) = bounds.c1(1)     + diff(bounds.c1)     * rand();
        population(i, idx+2) = bounds.c2(1)     + diff(bounds.c2)     * rand();
        population(i, idx+3) = bounds.sigma1(1) + diff(bounds.sigma1) * rand();
        population(i, idx+4) = bounds.sigma2(1) + diff(bounds.sigma2) * rand();
    end
end

%% Υπολογισμός του συνολικού σφάλματος(σε όλα τα σημεία) για κάθε γραμμικό συνδυασμό του population 
generation_counter = 1;
final_error = ones(population_size, 1);  % Δε βάζω zero για να μην ισχύει η τερματική συνθήκη από τη πρώτη επανάληψη

while min(final_error) > 0.1 && generation_counter < 800
    generation_counter = generation_counter + 1;    % υπολογισμός εποχών αλγορίθμου
    for j = 1 : population_size
        sum_2 = 0;

        % Υπολογισμός του συνολικού τετραγωνικού σφάλματος της αναλυτικής για όλα τα σημεία
       for iteration_count = 1 : N_train
           current_data = data(iteration_count, :);
           predicted_f = Gaussian_Calc(population(j, :), current_data, N_gaussians);
           actual_f = current_data(3);
           sum_2 = sum_2 + (actual_f - predicted_f) ^2;
       end
       % Υπολισμός και καταχώριση της ρίζας του συνολικού σφάλματος
       rms = sqrt(sum_2 / N_train);
       final_error(j) = rms;
       fprintf("Total error for the %dth analytic is %.4f\n", j, final_error(j));
    end
    % Αποθήκευση της βέλτιστης αναλυτικής έκφρασης
    [~, current_index] = min(final_error);
    best_ever_chromosome = population(current_index, :);
    
    % Επιλογή των πιο δυνατών 
    tournament_data = selection(population, final_error, population_size, chromosome_length);
    % Μείξη gaussian μεταξύ των αναλυτικών
    crossover_data = crossover(tournament_data, population_size, chromosome_length);
    % Προσθήκη θορύβου σε δεδομένα
    mutation_data = mutation(crossover_data, population_size, bounds, N_gaussians);
    % Καταχώρηση νέων gaussian
    population = mutation_data;
    % Ελιτισμός
    population(1, :) = best_ever_chromosome;
end

%% Γραφική Παράσταση της καλύτερης αναλυτικής προσέγγισης
[~, index] = min(final_error);
bestChromosome = population(index, :);

% Δημιουργία πλέγματος (grid)
x_vals = linspace(u1_range_test(1), u1_range_test(2), 100);
y_vals = linspace(u2_range_test(1), u2_range_test(2), 100);
[X, Y] = meshgrid(x_vals, y_vals);
Z = zeros(size(X));     % pre allocate space

for row = 1:size(X, 1)
    for col = 1:size(X, 2)
        current_u = [X(row, col), Y(row, col)];
        
        Z(row, col) = abs(Gaussian_Calc(bestChromosome, current_u, N_gaussians)- func(X(row, col), Y(row, col)));
    end
end

figure;
surf(X, Y, Z, 'EdgeColor', 'none');
shading interp; % Για πιο ομαλή εμφάνιση
colorbar;
title(['Βέλτιστος γραμμικός συνδυασμός Gaussian (Min RMSE: ', num2str(min(final_error)), ')']);
xlabel('u1'); ylabel('u2'); zlabel('f(u1,u2)');
view(3); % Τρισδιάστατη οπτική γωνία