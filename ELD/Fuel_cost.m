function value = Fuel_cost(X)

global Fuel_data pmin

[np,d] = size(X);
for i = 1:np
    for j = 1 : d        
        Fule_cost(i,j) = Fuel_data(j,1)*(X(i,j).^2) + Fuel_data(j,2)*X(i,j) + Fuel_data(j,3) + abs(Fuel_data(j,4)* sin(Fuel_data(j,5)*(pmin(j)-X(i,j))));
    end
end
value = sum(Fule_cost, 2);

end
