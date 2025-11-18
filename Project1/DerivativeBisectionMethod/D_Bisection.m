classdef D_Bisection
    properties
        func
        l_value
        a_value
        b_value
        n_value
    end

    methods 
        function obj = D_Bisection(func, a_start, b_start, l)
            obj.func = func;
            obj.a_value = a_start;
            obj.b_value = b_start;
            obj.l_value = l;   
            
            % Καθορισμός πλήθους επαναλήψεων n από περιορισμούς
            n = 1;
            while (1/2)^n > l / (obj.b_value - obj.a_value)
                n = n + 1; 
            end 
            obj.n_value = n;
        end
        
        % Δε με άφηνε να χρησιμοποιήσω τη sym οπότε το πήγα παραδοσιακά
        function derivative = numerical_derivative(obj, x)
            h = 1e-6; 
            derivative = (obj.func(x + h) - obj.func(x - h)) / (2 * h);
        end
        
        function result = Calc(obj)
            a = obj.a_value;
            b = obj.b_value;

            % Pre-allocate space για καταχώρηση τιμών
            a_history = zeros(obj.n_value, 1);
            b_history = zeros(obj.n_value, 1);
            
            for i = 1:obj.n_value

                a_history(i) = a;
                b_history(i) = b;
                
                midpoint = (a + b) / 2;
                midpoint_derivative = obj.numerical_derivative(midpoint);

                if abs(midpoint_derivative) == 0
                    fprintf('Η ρίζα είναι το %.4f', midpoint);
                    break;
                elseif midpoint_derivative > 0
                    b = midpoint;
                else 
                    a = midpoint;
                end
            end
            
            % Τελικά αποτελέσματα που επιστρέφονται για γραφήματα
            result.iterations = i; 
            result.a_history = a_history(1:i);
            result.b_history = b_history(1:i);
        end
    end
end