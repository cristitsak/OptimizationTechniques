clc; clear; close all;

f = @(x, y) x.^3 .* exp(- x.^2 - y.^4);

% Grid για contour και surface
[xg, yg] = meshgrid(-3:0.05:3, -3:0.05:3);
zg = f(xg, yg);

%% === Εμφάνιση επιφάνειας ===
figure;
surf(xg, yg, zg);
xlabel('x'); ylabel('y'); zlabel('f(x, y)');
title('Επιφάνεια της f(x,y)');
shading interp;
hold on;

%% === Run all 3 γ methods for all 3 starting points ===
methodNames = {'Σταθερό γ', 'Golden Section', 'Armijo'};
startingPoints = [0 0; -1 -1; 1 1];
epsilon = 1e-3;
gamma0 = 0.1;  % αρχικό gamma για fixed-step
all_results = cell(3,3);

for method = 1:3
    for sp = 1:3
        
        fprintf("\n--- Μέθοδος (%s), Αρχικό σημείο (%.1f, %.1f) ---\n", ...
             methodNames{method}, startingPoints(sp,1), startingPoints(sp,2));

        % Δημιουργία αντικειμένου Lavenberg
        obj = Levenberg(f, epsilon, gamma0, startingPoints(sp,:), method);
        
        % Εκτέλεση minimize
        trajectory = obj.minimize();

        % Έλεγχος για κενή τροχιά
        if isempty(trajectory)
            fprintf("Empty trajectory!\n");
            all_results{method,sp} = [];
            continue;
        end

        % Αποθήκευση αποτελεσμάτων
        all_results{method,sp} = trajectory;

        fprintf("Επαναλήψεις: %d | Ελάχιστο σημείο: (%.4f, %.4f)\n", ...
            size(trajectory,1), trajectory(end,2), trajectory(end,3));
    end
end


%% === Bar plot iterations ===
figure;
iterations = zeros(3,3);

for i = 1:3
    for j = 1:3
        if ~isempty(all_results{i,j})
            iterations(i,j) = size(all_results{i,j},1);
        end
    end
end

bar(iterations);
xlabel('Μέθοδος \gamma');
ylabel('Αριθμός Επαναλήψεων');
set(gca, 'XTickLabel', methodNames);
legend('Start (0,0)', 'Start (-1,-1)', 'Start (1,1)');
title('Σύγκριση Επαναλήψεων');

%% === 3 contour plots (1 for each γ method) ===
colors = {'red', 'blue', 'green'};

for method = 1:3
    figure;
    contour(xg, yg, zg, 20);
    hold on;
    grid on;
    title("Τροχιές Σύγκλισης - " + methodNames{method});
    xlabel('x'); ylabel('y');

    for sp = 1:3
        
        traj = all_results{method,sp};
        if isempty(traj), continue; end

        plot(traj(:,2), traj(:,3), '-', ...
            'Color', colors{sp}, 'LineWidth', 1.2, ...
            'DisplayName', sprintf("Start %d", sp));

        plot(traj(:,2), traj(:,3), 'o', ...
            'Color', colors{sp}, 'MarkerFaceColor', colors{sp}, 'MarkerSize', 4);
    end

    legend show;
    colorbar;
end
