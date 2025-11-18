function display_results()
    clc; close all;

    % Αρχικοποίηση Μεβαλητών
    a0 = -1;
    b0 = 3;
    l0 = 0.01;
    e0 = 0.001;

    % Συναρτήσεις
    funcs = {@(x) 5.^x + (2 - cos(x)).^2, ...
             @(x) (x-1).^2 + exp(x-5) .* sin(x+3), ...
             @(x) exp(-3*x) - (sin(x-2)-2).^2};
    func_names = {'f1: 5^x + (2-cos(x))^2', ...
                  'f2: (x-1)^2 + e^{(x-5)}sin(x+3)', ...
                  'f3: e^{-3x} - (sin(x-2)-2)^2'};
    short_names = {'f1', 'f2', 'f3'};

    % Εύρος τιμών για ε και l
    epsilon_values = linspace(0.001, 0.0049, 100);
    lambda_values = linspace(0.01, 0.05, 100);

    % Pre-allocate memory
    results_epsilon = cell(3, 1);
    results_lambda = cell(3, 1);

    % Process all functions in one loop
    for func_idx = 1:3
        fprintf('\n=== Processing function %d: %s ===\n', func_idx, func_names{func_idx});
        
        results_epsilon{func_idx} = cell(length(epsilon_values), 1);
        results_lambda{func_idx} = cell(length(lambda_values), 1);
        
        % ε μεταβαλλόμενο - l σταθερό
        fprintf('Testing epsilon variation...\n');
        for i = 1:length(epsilon_values)
            e = epsilon_values(i);
            bisection_obj = Bisection(funcs{func_idx}, l0, e, a0, b0);
            results_epsilon{func_idx}{i} = bisection_obj.Iter();  
        end
        
        % l μεταβσαλλόμενο - ε σταθερό 
        fprintf('Testing lambda variation...\n');
        for i = 1:length(lambda_values)
            l = lambda_values(i);
            bisection_obj = Bisection(funcs{func_idx}, l, e0, a0, b0);
            results_lambda{func_idx}{i} = bisection_obj.Iter();
        end
        
        % Συνάρτηση για 3 διαφορετικά διαγράμματα
        create_combined_plot(func_idx, epsilon_values, lambda_values, ...
                     results_epsilon{func_idx}, results_lambda{func_idx}, ...
                     func_names{func_idx}, short_names{func_idx}, l0, e0, funcs);
    end
end

function create_combined_plot(func_idx, epsilon_values, lambda_values, ...
                     eps_results, lam_results, func_name, short_name, l0, e0, funcs)

    % Πίνακες για αποθήκευση πλήθους επαναλήψεων
    eps_iters = zeros(length(eps_results), 1);
    lam_iters = zeros(length(lam_results), 1);
    
    % Όπως έχω γράψει το κώδικα επιστρέφω το πλήθος που εκτελέστηκε η
    % λουπα, ωστώσο σε κάθε λούπα κάνουμε 2 υπολογισμούς της συνάρτησης f
    % οπότε πρέπει να διπλασιασουμε το αποτέλεσμα
    for i = 1:length(eps_results)
        eps_iters(i) = 2 * eps_results{i}.iterations;
    end
    
    for i = 1:length(lam_results)
        lam_iters(i) = 2 * lam_results{i}.iterations;
    end
    
    % 3 subplots - Συγκεντρωμένα Αποτελέσματα
    figure('Name', sprintf('Bisection Analysis - %s', short_name), ...
           'Position', [100, 100, 1200, 900]);
    
    % Subplot 1: ε
    subplot(2,2,1);
    stairs(epsilon_values, eps_iters, 'LineWidth', 2);
    xlabel('Epsilon Values');
    ylabel('Number of Iterations');
    title(sprintf('Epsilon Variation (Fixed λ=%.3f)', l0));
    grid on;
    
    % Subplot 2: l  
    subplot(2,2,2);
    stairs(lambda_values, lam_iters, 'LineWidth', 2, 'Color', [0.85 0.33 0.10]);
    xlabel('Lambda Values');
    ylabel('Number of Iterations');
    title(sprintf('Lambda Variation (Fixed ε=%.3f)', e0));
    grid on;
    
    % Subplot 3: a - b 
    subplot(2,2,[3,4]);
    
    test_lambda = 0.01;
    a0 = -1;
    b0 = 3;
    e0 = 0.001;
    bisection_obj = Bisection(funcs{func_idx}, test_lambda, e0, a0, b0);
    result = bisection_obj.Iter();
    
    iterations = 0:result.iterations;
    a_values = result.a_history;
    b_values = result.b_history;
    
    % Plot a and b values vs iterations
    plot(iterations, a_values, 'o-', 'LineWidth', 2, ...
         'Color', [0 0.45 0.74], 'DisplayName', 'α values', 'MarkerSize', 4, ...
         'MarkerFaceColor', [0 0.45 0.74]);
    hold on;
    plot(iterations, b_values, 's-', 'LineWidth', 2, ...
         'Color', [0.85 0.33 0.10], 'DisplayName', 'β values', 'MarkerSize', 4, ...
         'MarkerFaceColor', [0.85 0.33 0.10]);
    
    xlabel('Iteration Number');
    ylabel('Interval Boundaries');
    title(sprintf('Interval Evolution (λ=%.3f, ε=%.3f)', test_lambda, e0));
    legend('show', 'Location', 'best');
    grid on;
    hold off;
    
    % Τίτλος για κάθε συνάρτηση
    sgtitle(sprintf('Bisection Method Analysis - %s', func_name), ...
            'FontSize', 14, 'FontWeight', 'bold');
end