classdef SteepestProjection
    properties
        f
        epsilon
        gamma
        sigma
        current_point
        range_x
        range_y
        counter
    end

    methods
        function obj = SteepestProjection(func, e, g, s, point, range)
            obj.f = func;
            obj.epsilon = e;
            obj.gamma = g;
            obj.sigma = s;
            obj.current_point = point(:);
            obj.range_x = range{1};
            obj.range_y = range{2};
            obj.counter = 0;
        end

        function minimize = sP(obj)
            maxIter = 500;
            minimize = zeros(maxIter, 3); % [iteration, x, y]

            % Υπολογισμός grad με παραδοσιακό τρόπο
            numericGrad = @(p) [
                (obj.f(p(1)+1e-5, p(2)) - obj.f(p(1)-1e-5, p(2))) / (2e-5);
                (obj.f(p(1), p(2)+1e-5) - obj.f(p(1), p(2)-1e-5)) / (2e-5)
            ];

            % Έλεγχος αρχικού σημείου
            if ~obj.withinBounds(obj.current_point)
                fprintf("starting point not within bounds - projecting... \n");
                obj.current_point = obj.projection(obj.current_point);
            end

            minimize(1,:) = [0, obj.current_point(:)'];
            grad_f = numericGrad(obj.current_point);
            obj.counter = 1;
            
            while norm(grad_f) >= obj.epsilon && obj.counter < maxIter

                d = -grad_f;

                % Ενημέρωση σημείου
                new_point = obj.current_point + obj.sigma * d;

                % Έλεγχος και προβολή αν χρειάζεται
                if ~obj.withinBounds(new_point)
                    fprintf("Iteration %d: point out of bounds - projecting\n", obj.counter);
                        new_point = obj.projection(new_point);
                end
                
                obj.current_point = obj.current_point + obj.gamma * (new_point - obj.current_point);
                minimize(obj.counter+1,:) = [obj.counter, obj.current_point(:)'];

                obj.counter = obj.counter + 1;
                grad_f = numericGrad(obj.current_point);
                
            end
            
            % Περικοπή του πίνακα αποτελεσμάτων
            minimize = minimize(1:obj.counter, :);
        end

        function inside = withinBounds(obj, p)
            inside = (p(1) >= obj.range_x(1) && p(1) <= obj.range_x(2) && ...
                      p(2) >= obj.range_y(1) && p(2) <= obj.range_y(2));
        end

        function x_bar = projection(obj,p)
            
            % Προβολή στα όρια
            x_proj = max(obj.range_x(1), min(p(1), obj.range_x(2)));
            y_proj = max(obj.range_y(1), min(p(2), obj.range_y(2)));
            
            x_bar = [x_proj; y_proj];
        end
    end
end