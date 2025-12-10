% --- Figure 1: 3D visualization ---
figure(1); clf;

func = @(x_1, x_2) (1/3) * x_1.^2 + 3 * x_2.^2;

[x, y] = meshgrid(-10:0.1:5, -8:0.1:12);
z = func(x, y);

surf(x, y, z);
xlabel('x'); ylabel('y'); zlabel('f(x, y)');
title('Επιφάνεια της f(x,y)');
shading interp;
hold on;

% --- Figure 2: 4 subplots for 4 γ values ---
figure(2); clf;

e = 0.001;
gamma = [0.1, 0.3, 3, 5];
starting_point = [-1, -1];

colors = lines(length(gamma));

idx = 1;

for g = gamma
    fprintf("------ γ = %.2f-------\n", g);
    subplot(2,2,idx);  % --- διαφορετικό tab στο ίδιο παράθυρο
    hold on; grid on;

    xlabel('x'); ylabel('y');
    title(sprintf('Trajectory για \\gamma = %.2f', g));

    sd_object = SteepestDescent(func, starting_point, e, g, 1);
    results = sd_object.sD();

    if isempty(results)
        idx = idx + 1;
        continue;
    end

    fprintf('Επαναλήψεις: %d, Τελικό σημείο: (%.4f, %.4f)\n', ...
        size(results, 1), results(end, 2), results(end, 3));

    traj_x = results(:, 2);
    traj_y = results(:, 3);

    plot(traj_x, traj_y, 'o-', 'Color', colors(idx,:), 'LineWidth', 2);

    % αρχικό σημείο
    plot(traj_x(1), traj_y(1), 'ks', 'MarkerSize', 8, 'MarkerFaceColor', 'y');

    % τελικό σημείο
    plot(traj_x(end), traj_y(end), 'kp', 'MarkerSize', 12, 'MarkerFaceColor', 'g');

    idx = idx + 1;
end
