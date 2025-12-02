clc; clear; close all;

f = @(x, y) x.^3 .* exp(- x.^2 - y.^4);

% 3D διάγραμμα συνάρτηση f
[xg, yg] = meshgrid(-5:0.1:5, -5:0.1:5);
zg = f(xg, yg);

figure;
surf(xg, yg, zg);
xlabel('x'); ylabel('y'); zlabel('f(x, y)');
title('Επιφάνεια της f(x,y)');
hold on;

% Αρχικοποίηση δεδομένων
startingPoints = [0 0; -1 -1; 1 1];
epsilon = 0.001;
gamma0 = 1;

all_results = cell(3,3);

% Δεδομένα για όλα τα είδη γ και για διαφορετικά starting points
for i = 1:3           % method of γ
    for j = 1:3       % starting point
        fprintf('Μέθοδος %d, αρχικό σημείο %d, %d\n', i, startingPoints(j,1), startingPoints(j,2));
        
        obj = SteepestDescent(f, startingPoints(j,:), epsilon, gamma0, i);
        trajectory = obj.sD();
        
        % Έλεγχος για κενά αποτελέσματα
        if isempty(trajectory) || size(trajectory, 1) < 2
            fprintf('Warning: Empty or short trajectory for method %d with starting point %d, %d\n', i, startingPoints(j,1), startingPoints(j,2));
            all_results{i,j} = [];
            continue;
        end
        
        all_results{i,j} = trajectory;
        fprintf('Επαναλήψεις: %d, Τελικό σημείο: (%.4f, %.4f)\n', ...
                size(trajectory, 1), trajectory(end, 2), trajectory(end, 3));

    end
end

legend show;

%% Διάγραμμα Επαναλήψεων και Αρχικού Σημείου
figure;
iterations = zeros(3,3);

for i = 1:3
    for j = 1:3
        if ~isempty(all_results{i,j}) && size(all_results{i,j}, 1) > 0
            iterations(i,j) = all_results{i,j}(end, 1) + 1; % +1 γιατί ξεκινάει από 0
        else
            iterations(i,j) = 0;
        end
    end
end

bar(iterations);
xlabel('Μέθοδος γ');
ylabel('Επαναλήψεις');
title('Αριθμός επαναλήψεων');
set(gca, 'XTickLabel', {'Σταθερό γ', 'Golden Section', 'Armijo'});
legend('Start (0,0)', 'Start (-1,-1)', 'Start (1,1)');

%% === 3 SEPARATE FIGURES ===

colors = {'red', 'blue', 'green'};
method_names = {'Σταθερό γ', 'Golden Section', 'Armijo'};

for i = 1:3
    figure('Position', [200 + 300*(i-1), 200, 600, 500]);

    % Contour
    contour(xg, yg, zg, 10);
    hold on; grid on;
    title(['Τροχιές Σύγκλισης - ', method_names{i}]);
    xlabel('x'); ylabel('y');

    % Add trajectories for the 3 starting points
    for j = 1:3
        if ~isempty(all_results{i,j}) && size(all_results{i,j}, 1) > 1
            data = all_results{i,j};

            % Line
            plot(data(:,2), data(:,3), '-', ...
                'LineWidth', 1.2, ...
                'Color', colors{j}, ...
                'DisplayName', ['Start ', num2str(j)]);

            % Markers
            plot(data(:,2), data(:,3), 'o', ...
                'LineWidth', 1, ...
                'MarkerSize', 4, ...
                'Color', colors{j}, ...
                'MarkerFaceColor', colors{j});
        end
    end

    legend show;
    colorbar;
end
