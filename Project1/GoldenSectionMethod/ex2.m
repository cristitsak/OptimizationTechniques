clc; close all;

% Αρχικοποίηση μεταβλητών
a0 = -1;
b0 = 3;

% Ορισμός συναρτήσεων
funcs = {@(x) 5.^x + (2 - cos(x)).^2, ...
         @(x) (x-1).^2 + exp(x-5) .* sin(x+3), ...
         @(x) exp(-3*x) - (sin(x-2)-2).^2};
func_names = {'f1: 5^x + (2-cos(x))^2', ...
              'f2: (x-1)^2 + e^{(x-5)}sin(x+3)', ...
              'f3: e^{-3x} - (sin(x-2)-2)^2'};

% Εύρος τιμών l
lambda_values = linspace(0.001, 0.1, 800);

% Διάγραμμα l- πλήθος υπολογισμών f
for func_idx = 1:3
    figure;
    k = zeros(length(lambda_values), 1);
    
    for i = 1:length(lambda_values)
        l = lambda_values(i);
        golden_obj = golden(funcs{func_idx}, a0, b0, l);
        result = golden_obj.Calc();
        k(i) = result.iterations;
    end

    % Χρήση stairs για βηματική συμπεριφορά
    [lambda_sorted, sort_idx] = sort(lambda_values);
    k_sorted = k(sort_idx);
    
    stairs(lambda_sorted, k_sorted, 'LineWidth', 2);
    
    xlabel('Lambda Values');
    ylabel('Number of Iterations');
    title(sprintf('Golden Section Method - %s', func_names{func_idx}));
    grid on;

    
end

l_values = [0.001, 0.005, 0.01];  

for func_idx = 1:3
    figure;
    hold on;
    
    colors = ['r', 'g', 'b'];  % Χρώματα για τα διαφορετικά l
    
    for i = 1:length(l_values)
        l = l_values(i);
        golden_obj = golden(funcs{func_idx}, a0, b0, l);
        result = golden_obj.Calc();
        
        k_values = 1:length(result.a_history);
        
        % Plot τα a_k (κάτω άκρο)
        plot(k_values, result.a_history, 'o-', 'LineWidth', 1.5, ...
             'Color', colors(i), 'MarkerSize', 4, ...
             'DisplayName', sprintf('a_k (l=%.3f)', l));
        
        % Plot τα b_k (άνω άκρο) 
        plot(k_values, result.b_history, 's-', 'LineWidth', 1.5, ...
             'Color', colors(i), 'MarkerSize', 4, ...
             'DisplayName', sprintf('b_k (l=%.3f)', l), ...
             'LineStyle', '--');
    end
    
    xlabel('Αριθμός Επαναλήψεων (k)');
    ylabel('Άκρα Διαστήματος [a_k, b_k]');
    title(sprintf('Εξέλιξη Διαστήματος - %s', func_names{func_idx}));
    legend('show', 'Location', 'best');
    grid on;
    hold off;
end