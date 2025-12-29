% Συνάρτηση υπολογισμού της τιμής του Gaussian γραμμικού συνδυασμού σε συγκεκριμένο σημείο 
function result = Gaussian_Calc(population_data, training_data, gauss_number)
    result = 0;
    u1 = training_data(1);
    u2 = training_data(2);

    for i = 0 : gauss_number-1
        % Προσπέλλαση δεδομένων
        w = population_data(i*5+1);
        c1 = population_data(i*5+2);
        c2 = population_data(i*5+3);
        sigma1 = population_data(i*5+4);
        sigma2 = population_data(i*5+5);

        gaussian = exp( - ( (u1 - c1).^2 ./ (2*sigma1.^2) ...
                      + (u2 - c2).^2 ./ (2*sigma2.^2) ) );
        % Συσσώρευτικό αποτέλεσμα
        result = result + w * gaussian;
    end
end
