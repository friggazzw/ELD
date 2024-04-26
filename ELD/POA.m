function[fbest,Xbest,conv]=POA(SearchAgents,Max_iterations,lowerbound,upperbound,dimension,X)

fit=zeros(1,size(X,1));
conv=zeros(1,Max_iterations);
a=1;

for i =1:SearchAgents
    L=X(i,:);
    fit(i)=fitness(L);
end

for t=1:Max_iterations
    
    [best , location]=min(fit);
    if t==1
        Xbest=X(location,:);                                        
        fbest=best;                                          
    elseif best<fbest
        fbest=best;
        Xbest=X(location,:);
    end

    k=randperm(SearchAgents,1);
    X_FOOD=X(k,:);
    F_FOOD=fit(k);
    
    
    for i=1:SearchAgents
        % Exploration phase
        I=round(1+rand(1,1));
        if fit(i)> F_FOOD
            X_new=X(i,:)+ rand(1,1).*(X_FOOD-I.* X(i,:)); 
        else
            X_new=X(i,:)+ rand(1,1).*(X(i,:)-1.*X_FOOD); 
        end
        
        X_new= max(X_new,lowerbound);
        X_new = min(X_new,upperbound);
        f_new = fitness(X_new);                 
        if f_new <= fit (i)                     
            X(i,:) = X_new;
            fit (i)=f_new;
        end
        
        % Development phase
        X_new=X(i,:)+0.2*(1-t/Max_iterations).*(2*rand(1,dimension)-1).*X(i,:);
         
        X_new= max(X_new,lowerbound);
        X_new = min(X_new,upperbound); 
        f_new = fitness(X_new);
        if f_new <= fit (i)
            X(i,:) = X_new;
            fit (i)=f_new;
        end
        
    end
    conv(a)=fbest;
    a=a+1;
end
fbest = Fuel_cost(Xbest);
end