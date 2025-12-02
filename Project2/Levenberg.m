classdef Levenberg
    properties
        func        
        epsilon     
        point       
        gamma       
        item        
        m_value     
        maxIter     
    end

    methods
        function obj = Levenberg(f, epsilon, gamma0, initial, item)
            obj.func = f;
            obj.epsilon = epsilon;
            obj.point = initial(:);
            obj.gamma = gamma0;
            obj.item = item;
            obj.m_value = 0.01;    
            obj.maxIter = 1000;
        end

        function data = minimize(obj)
            h = 1e-5;  % για numeric Hessian
            data = zeros(obj.maxIter,3); % [iteration, x, y]
            iter = 0;

            % Αποθήκευση αρχικού σημείου
            data(1,:) = [iter, obj.point(:)'];

            while iter < obj.maxIter
                iter = iter + 1;

                % Numeric gradient
                grad_f = [ ...
                    (obj.func(obj.point(1)+h,obj.point(2)) - obj.func(obj.point(1)-h,obj.point(2)))/(2*h); ...
                    (obj.func(obj.point(1),obj.point(2)+h) - obj.func(obj.point(1),obj.point(2)-h))/(2*h) ...
                    ];

                if norm(grad_f) < obj.epsilon
                    break
                end

                % Numeric Hessian
                H = [ ...
                    (obj.func(obj.point(1)+h,obj.point(2)) - 2*obj.func(obj.point(1),obj.point(2)) + obj.func(obj.point(1)-h,obj.point(2)))/h^2, ...
                    (obj.func(obj.point(1)+h,obj.point(2)+h) - obj.func(obj.point(1)+h,obj.point(2)-h) ...
                    - obj.func(obj.point(1)-h,obj.point(2)+h) + obj.func(obj.point(1)-h,obj.point(2)-h))/(4*h^2); ...
                    (obj.func(obj.point(1)+h,obj.point(2)+h) - obj.func(obj.point(1)+h,obj.point(2)-h) ...
                    - obj.func(obj.point(1)-h,obj.point(2)+h) + obj.func(obj.point(1)-h,obj.point(2)-h))/(4*h^2), ...
                    (obj.func(obj.point(1),obj.point(2)+h) - 2*obj.func(obj.point(1),obj.point(2)) + obj.func(obj.point(1),obj.point(2)-h))/h^2 ...
                    ];

                % Levenberg-Marquardt direction
                d = -(H + obj.m_value*eye(2))\grad_f;

                % Compute gamma based on chosen method
                g = gamma_value(obj.item, obj.func, obj.gamma, obj.point, d, grad_f);

                % Candidate new point
                new_point = obj.point + g*d;
                f_new = obj.func(new_point(1), new_point(2));
                f_old = obj.func(obj.point(1), obj.point(2));

                % LM rule for lambda (m_value)
                if f_new < f_old
                    obj.point = new_point;        % accept step
                    obj.m_value = obj.m_value / 10;  % more Newton-like
                else
                    obj.m_value = obj.m_value * 10;  % more gradient-like
                end

                % Save trajectory
                data(iter+1,:) = [iter, obj.point(:)'];
            end

            % Remove extra preallocated rows
            data = data(1:iter,:);
        end
    end
end
