function X=initialization(SearchAgents_no,dim,ub,lb)

    X = zeros(SearchAgents_no,dim);
    for i=1:dim
        ub_i=ub(i);
        lb_i=lb(i);
        X(:,i)=rand(SearchAgents_no,1).*(ub_i-lb_i)+lb_i;
    end

end