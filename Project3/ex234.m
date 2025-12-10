% Αρχικοποίηση Δεδομένων
e_value = 0.01;
range = {[-10, 5], [-8, 12]};
s = [5, 15, 0.1];
g = [0.5, 0.1, 0.2];
sP = {[5, -5], [-5, 10], [8, -10]};

% Συνάρτηση
func = @(x1, x2) (1/3)*x1.^2 + 3*x2.^2;

colors = ['r','g','b'];

for i = 1:length(s)
    s_value = s(i);
    g_value = g(i);
    starting_point = sP{i};

    % Εκτέλεση μεθόδου
    steepestP = SteepestProjection(func, e_value, g_value, s_value, starting_point, range);
    data = steepestP.sP();  % Στήλες: [iteration, x1, x2]
    
    iter = data(:,1);
    x1 = data(:,2);
    x2 = data(:,3);
    f_values = func(x1, x2);

    %% Plot 1 – f vs Sequence of points
    figure;
    plot(iter(1:length(f_values)), f_values(1:length(f_values)), 'o-', 'LineWidth', 2, 'Color', colors(i), 'MarkerSize', 6);   
    xlabel('Iteration Counter');
    ylabel('f(x_1, x_2)');
    title(sprintf('f vs Step Sequence για Αρχικό [%g, %g]', starting_point(1), starting_point(2)));
    grid on;

    %% Plot 2 – 3D τροχιά σύγκλισης
    figure;
    plot3(x1, x2, f_values, '-o', 'Color', colors(i), 'LineWidth', 2, 'MarkerSize', 4);
    xlabel('x_1'); ylabel('x_2'); zlabel('f(x_1, x_2)');
    title(sprintf('Τροχιά σύγκλισης (x_1, x_2, f) για Αρχικό [%g, %g]', starting_point(1), starting_point(2)));
    grid on;
end
