classdef Newton
    properties
        func
        epsilon
        point
        gamma
        counter
        item
    end 

    methods
        function obj = Newton(f, e, g, initial, i)
            obj.func = f;
            obj.epsilon = e;
            obj.point = initial(:);
            obj.gamma = g;
            obj.counter = 0;
            obj.item = i;
        end

        function data = minimize(obj)
            h = 1e-5;
            maxIter = 1000;
            data = zeros(maxIter, 3);

            data(1,:) = [0, obj.point'];

            numericGrad = @(p) [
                (obj.func(p(1)+h, p(2)) - obj.func(p(1)-h, p(2))) / (2*h);
                (obj.func(p(1), p(2)+h) - obj.func(p(1), p(2)-h)) / (2*h)
            ];

            grad_f = numericGrad(obj.point);

            while norm(grad_f) >= obj.epsilon && obj.counter < maxIter

                hessian = @(p) [
                    (obj.func(p(1)+h, p(2)) - 2*obj.func(p(1), p(2)) + obj.func(p(1)-h, p(2))) / h^2, ...
                    ( obj.func(p(1)+h, p(2)+h) - obj.func(p(1)+h, p(2)-h) ...
                    - obj.func(p(1)-h, p(2)+h) + obj.func(p(1)-h, p(2)-h) ) / (4*h^2) ;
                    
                    ( obj.func(p(1)+h, p(2)+h) - obj.func(p(1)+h, p(2)-h) ...
                    - obj.func(p(1)-h, p(2)+h) + obj.func(p(1)-h, p(2)-h) ) / (4*h^2), ...
                    (obj.func(p(1), p(2)+h) - 2*obj.func(p(1), p(2)) + obj.func(p(1), p(2)-h)) / h^2
                ];

                H = hessian(obj.point);

                % FIX: ensure positive definiteness
                [~, p] = chol(H);
                if p ~= 0
                    H = H + 1e-3 * eye(2);
                end

                d = -H \ grad_f;

                % Armijo / golden / fixed step
                if obj.item ~= 1
                    g = gamma_value(obj.item, obj.func, obj.gamma, obj.point, d, grad_f);      % golden / Armijo
                else 
                    g = obj.gamma;
                end

                obj.point = obj.point + g*d;
                obj.counter = obj.counter + 1;

                grad_f = numericGrad(obj.point);
                data(obj.counter+1,:) = [obj.counter, obj.point'];
            end

            data = data(1:obj.counter,:);
        end
    end
end
