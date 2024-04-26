function [fMin,bestX,Convergence_curve ] = SSA(pop,M,lb,ub,dim,x)  

fobj=@fitness;
P_percent = 0.2;
pNum = round( pop *  P_percent );
Convergence_curve=zeros(1,M);

fit=zeros(1,pop);
for i =1:pop
    L=x(i,:);
    fit(i)=fobj(L);
end

pFit = fit;                      
pX = x;                         
[fMin,bestI] = min( fit );
bestX = x( bestI,:);

for t=1:M   
    
    [~,sortIndex]=sort( pFit );
    [fmax,B]=max( pFit );
    worse= x(B,:);       
    r2=rand;
    

    if r2<0.8
        for i=1 : pNum                                                   
            r1=rand(1);
            x( sortIndex( i ),: ) = pX( sortIndex( i ), : )*exp(-(i)/(r1*M));
            x( sortIndex( i ),: ) = Bounds( x( sortIndex( i ), : ), lb, ub );
            fit( sortIndex( i ) ) = fobj( x( sortIndex( i ), : ) );   
        end
    else
        for i=1 : pNum   
            x( sortIndex( i ),: ) = pX( sortIndex( i ), : )+randn(1)*ones(1,dim);
            x( sortIndex( i ),: ) = Bounds( x( sortIndex( i ), : ), lb, ub );
            fit( sortIndex( i ) ) = fobj( x( sortIndex( i ), : ) );
        end
    end

    [~, bestII ] = min( fit );      
    bestXX = x( bestII, : );            


    for i=( pNum + 1 ) : pop 
        A=floor(rand(1,dim)*2)*2-1;
        if i>(pop/2)
            x( sortIndex(i),:)=randn(1)*exp((worse-pX( sortIndex( i ), : ))/(i)^2);
        else
            x( sortIndex(i),:)=bestXX+(abs(( pX( sortIndex( i ), : )-bestXX)))*(A'*(A*A')^(-1))*ones(1,dim);  
        end  
            x( sortIndex(i),:) = Bounds( x( sortIndex( i ), : ), lb, ub );
            fit( sortIndex(i)) = fobj( x( sortIndex( i ), : ) );
    end
    

    h=randperm(numel(sortIndex));
    b=h(1:20);
    
    for j =  1  : length(b)
        if( pFit( sortIndex( b(j) ) )>(fMin) )
            x( sortIndex( b(j) ), : )=bestX+(randn(1,dim)).*(abs(( pX( sortIndex( b(j) ), : ) -bestX)));
        else
            x( sortIndex( b(j) ), : ) =pX( sortIndex( b(j) ), : )+(2*rand(1)-1)*(abs(pX( sortIndex( b(j) ), : )-worse))/ ( pFit( sortIndex( b(j) ) )-fmax+1e-50);
        end
        x( sortIndex(b(j) ), : ) = Bounds( x( sortIndex(b(j) ), : ), lb, ub );
        fit( sortIndex( b(j) ) ) = fobj( x( sortIndex( b(j) ), : ) );
    end

    for i = 1 : pop 
        if ( fit( i ) < pFit( i ) )
            pFit( i ) = fit( i );
            pX( i, : ) = x( i, : );
        end
        if( pFit( i ) < fMin )
            fMin= pFit( i );
            bestX = pX( i, : );
        end
    end

    Convergence_curve(1,t)=fMin;

end
fMin=Fuel_cost(bestX);
end

% Application of simple limits/bounds
function s = Bounds( s,lowerbound,upperbound)
  X_new=s;
  X_new=max(X_new,lowerbound);
  X_new=min(X_new,upperbound);
  s=X_new;
end