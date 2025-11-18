classdef fibonacci
    properties
        func
        a_start
        b_start
        l_value
        n_value
        fib_sequence  % Αποθήκευση ολόκληρης της ακολουθίας
    end
    
    methods
        % Constructor
        function obj = fibonacci(func, a_start, b_start, l)
            obj.func = func;
            obj.a_start = a_start;
            obj.b_start = b_start;
            obj.l_value = l;
            
            % Προϋπολογισμός ολόκληρης της ακολουθίας Fibonacci
            F1 = 1; F2 = 1;
            fib_seq = [F1, F2];
            n = 2;
            
            % Καθορισμός πλήθους επαναλήψεων n από περιορισμούς
            while F2 < (b_start - a_start)/l
                F_temp = F1 + F2;
                F1 = F2;
                F2 = F_temp;
                fib_seq = [fib_seq, F2];
                n = n + 1;
            end
            
            obj.n_value = n;
            obj.fib_sequence = fib_seq;
        end
        
        % Συνάρτηση για εύρεση τιμής ακολουθίας fibonacci στη θέση k
        function fib_num = get_fib(obj, k)
            % Επιστρέφει τον k-οστό Fibonacci από την προϋπολογισμένη ακολουθία
            if k > length(obj.fib_sequence)
                error('Fibonacci number out of precomputed range');
            end
            fib_num = obj.fib_sequence(k);
        end
        
        % Συνάρτηση που μας επιστρέφει όλα τα δεδομένα για διαγράμματα
        function calculate = Calc(obj)
            a = obj.a_start;
            b = obj.b_start;
            n = obj.n_value;
            
            % Αρχικά σημεία
            x1 = a + (obj.get_fib(n-2)/obj.get_fib(n)) * (b - a);
            x2 = a + (obj.get_fib(n-1)/obj.get_fib(n)) * (b - a);

            % f στα αρχικά σημεία
            fx1 = obj.func(x1);
            fx2 = obj.func(x2);

            % Πίνακας για αποθήκευση τιμών α,β για σχετικό διάγραμμα 
            a_history = [a];
            b_history = [b];
            
            % Αλγόριθμος μεθόδου Fibonacci
            for k = n-1:-1:3
                if fx1 > fx2
                    a = x1;
                    x1 = x2;
                    x2 = a + (obj.get_fib(k-1)/obj.get_fib(k)) * (b - a);
                    fx1 = fx2;
                    fx2 = obj.func(x2);
                else
                    b = x2;
                    x2 = x1;
                    x1 = a + (obj.get_fib(k-2)/obj.get_fib(k)) * (b - a);
                    fx2 = fx1;
                    fx1 = obj.func(x1);
                end
                
                % Αποθήκευση history
                a_history(end+1) = a;
                b_history(end+1) = b;
            end

            % Επιστροφή τιμών
            calculate.iterations = n - 2;
            calculate.a_history = a_history;
            calculate.b_history = b_history;
            calculate.fib_sequence = obj.fib_sequence;
        end
    end
end