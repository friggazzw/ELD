function[fbest,Xbest,conv]=IPOA(SearchAgents,Max_iterations,lowerbound,upperbound,dimension,X)


fit=zeros(1,SearchAgents);
conv=zeros(1,Max_iterations);
a=1;

for i =1:SearchAgents
    L=X(i,:);
    fit(i)=fitness(L);
end

[best , location]=min(fit);
Xbest=X(location,:);                                        
fbest=best;
X_new=X(1,:);

for t=1:Max_iterations
    
    k=randperm(SearchAgents,1);
    X_FOOD=X(k,:);
    F_FOOD=fit(k);
    QF=t^((2*rand()-1)/(1-Max_iterations)^2); 
    G=2*(1-(t/Max_iterations));
    
     for i=1:SearchAgents
        % Exploration phase
        I=round(1+rand(1,1));
        if F_FOOD < fit(i)
            X_new=X(i,:)+ rand(1,1).*(X_FOOD-I.* X(i,:)); 
        else
            for j=1:dimension
                r1=rand;
                r2=2*rand*pi;
                X_new(j)=r1*X(i,j) + (1-r1)*X_FOOD(j)+sin(r2)*(X(i,j)-X_FOOD(j)); 
            end
        end
        X_new = max(X_new,lowerbound);
        X_new = min(X_new,upperbound);
        f_new = fitness(X_new);
        if f_new <= fit (i)
            X(i,:) = X_new;
            fit (i)= f_new;
        end
        
        % Development phase
        r1=2*rand*pi;
        X_new = QF.*X(i,:)+(2*rand(1,dimension)-1).*(Xbest-X(i,:))+sin(r1)*G;
        X_new = max(X_new,lowerbound);
        X_new = min(X_new,upperbound); 
        f_new = fitness(X_new);
        if f_new <= fit (i)
            X(i,:) = X_new;
            fit (i)= f_new;
        end
    end
    
    [best , location]=min(fit);
    if best<fbest
        fbest=best;
        Xbest=X(location,:);
    end
    
    % Dimensional variation strategy
    TD=trnd(25,1,dimension);
    for j=1:dimension
        X_new=Xbest;
        X_new(j)=X_new(j)+TD(j)*rand;
        X_new(j)= max(X_new(j),lowerbound(j));
        X_new(j)= min(X_new(j),upperbound(j));
        fnew=fitness(X_new);
        if fnew<fbest
           fbest=fnew;
           Xbest=X_new;
        end
    end
    conv(a)=fbest;
    a=a+1;
end
fbest = Fuel_cost(Xbest);
end