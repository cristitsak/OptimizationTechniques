classdef Bisection
    properties
        func
        l_value
        a_start
        b_start
        e_value
    end

    methods
        % Constructor
        function obj = Bisection(f, l, e, a, b)
            obj.func = f;
            obj.l_value = l;
            obj.a_start = a;
            obj.b_start = b;
            obj.e_value = e;
        end
        
        % Συνάρτηση που μας επιστρέφει όλα τα δεδομένα για τα διαγράμματα
        function output = Iter(obj)
            alpha = obj.a_start;
            beta = obj.b_start;
            iter = 0;
            
            % Pre-allocate memory
            max_iterations = 100;
            a_history = zeros(max_iterations, 1);
            b_history = zeros(max_iterations, 1);
            
            % Πρώτη τιμή πίνακα
            a_history(1) = alpha;
            b_history(1) = beta;
            
            while (beta - alpha) > obj.l_value
                midpoint = (alpha + beta) / 2;
                x1k = midpoint - obj.e_value;
                x2k = midpoint + obj.e_value;

                f_x1k = obj.func(x1k);
                f_x2k = obj.func(x2k);

                if f_x1k < f_x2k
                    beta = x2k;
                else
                    alpha = x1k;
                end

                iter = iter + 1;
                
                % Εισαγωγή στοιχείου σε πίνακα για διάγραμμα προόδου τιμών
                % α - β
                a_history(iter + 1) = alpha;
                b_history(iter + 1) = beta;
                
            end
            
            % Αν βρεθεί η ρίζα πριν την 100στη επανάληψη, μειώνω μέγεθος
            % πίνακα
            a_history = a_history(1:iter+1);
            b_history = b_history(1:iter+1);
            
            % Τελικό αποτέλεσμα
            output.iterations = iter;
            output.a_history = a_history;
            output.b_history = b_history;
        end
    end
end