classdef SteepestDescent
    properties
        current_point
        e
        gamma
        func
        counter
        item
    end

    methods
        function obj = SteepestDescent(f, initial, e_value, g_value, i)
            obj.current_point = initial;
            obj.e = e_value;
            obj.gamma = g_value;
            obj.func = f;
            obj.counter = 0;
            obj.item = i;
        end

        function minimize = sD(obj)
            maxIter = 1000;
            minimize = zeros(maxIter, 3); % [iteration, x, y]
            
            % Αποθήκευση αρχικού σημείου
            minimize(1, :) = [0, obj.current_point(:)'];
            
            % Για κάποιο λόγο στον υπολογιστή μου δεν αναγνωρίζει το syms
            numericGrad = @(p) [
                (obj.func(p(1)+1e-5, p(2)) - obj.func(p(1)-1e-5, p(2))) / (2e-5);
                (obj.func(p(1), p(2)+1e-5) - obj.func(p(1), p(2)-1e-5)) / (2e-5)
            ];
            
            grad_f = numericGrad(obj.current_point);
            obj.counter = 1;
            
            while norm(grad_f) >= obj.e && obj.counter < maxIter
                d = -1 * grad_f;
                
                % Armijo / golden / fixed step
                if obj.item ~= 1
                    g = gamma_value(obj.item, obj.func, obj.gamma, obj.current_point, d, grad_f);      % golden / Armijo
                else 
                    g = obj.gamma;
                end
                
                % Ενημέρωση σημείου
                obj.current_point = obj.current_point(:) + g * d;
                obj.counter = obj.counter + 1;
                
                % Αποθήκευση αποτελέσματος
                minimize(obj.counter, :) = [obj.counter-1, obj.current_point(:)'];
                
                % Υπολογισμός νέας κλίσης
                grad_f = numericGrad(obj.current_point);
                
                % Έλεγχος για NaN τιμές
                if any(isnan(obj.current_point)) || any(isnan(grad_f))
                    warning('NaN values detected at iteration %d', obj.counter);
                    break;
                end
            end
            
            % Κόψιμο στον πραγματικό αριθμό επαναλήψεων
            minimize = minimize(1:obj.counter, :);
        end
    end
end