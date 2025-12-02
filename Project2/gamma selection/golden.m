classdef golden
    properties
        func
        g
        a_start
        b_start
        l_value
    end

    methods
        % Constructor
        function obj = golden(func, a_start, b_start, l)
            obj.func = func;
            obj.a_start = a_start;
            obj.b_start = b_start;
            obj.l_value = l;
            obj.g = (sqrt(5)-1)/2;  
        end

        function calculate = Calc(obj)
            % Αρχικοποίηση μεταβλητών
            a = obj.a_start;
            b = obj.b_start;
            x1 = b - obj.g * (b - a);
            x2 = a + obj.g * (b - a);
            fx1 = obj.func(x1);
            fx2 = obj.func(x2);    
            
            k = 2;  

            % Pre allocate memory
            max_iterations = 100;
            a_history = zeros(max_iterations, 1);
            b_history = zeros(max_iterations, 1);
            
            % Αποθήκευση πρώτης τιμής
            a_history(1) = a;
            b_history(1) = b;
           
            while (b - a) > obj.l_value
                if fx2 < fx1
                    a = x1;
                    x1 = x2;
                    fx1 = fx2;
                    x2 = a + obj.g * (b - a);
                    fx2 = obj.func(x2);
                else
                    b = x2;
                    x2 = x1;
                    fx2 = fx1;
                    x1 = b - obj.g * (b - a);
                    fx1 = obj.func(x1);
                end
                a_history(k) = a;
                b_history(k) = b;
                k = k + 1;
            end

            % Αν βρεθεί η ρίζα πριν την 100στη επανάληψη, μειώνω μέγεθος
            % πίνακα
            a_history = a_history(1:k);
            b_history = b_history(1:k);
    
            % Τελικό αποτέλεσμα προς επιστροφή
            calculate.iterations = k;
            calculate.a_history = a_history;
            calculate.b_history = b_history;
        end
    end
end