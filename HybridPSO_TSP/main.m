clc;clear

%% load data
data =load('eil51.txt');
cityCoor = [data(:,2) data(:,3)]; % coordinate of cities

figure
plot(cityCoor(:,1),cityCoor(:,2),'ms','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g')
legend('City Position')
ylim([4 78])
title('Distribution of Cities','fontsize',12)
xlabel('km','fontsize',12)
ylabel('km','fontsize',12)
%ylim([min(cityCoor(:,2))-1 max(cityCoor(:,2))+1])

grid on

%% distance between two cities
n = size(cityCoor,1);            %number of cities
cityDist = zeros(n,n);           %distance matrix
for i=1:n
    for j=1:n
        if i~=j
            cityDist(i,j)=((cityCoor(i,1)-cityCoor(j,1))^2+...
                (cityCoor(i,2)-cityCoor(j,2))^2)^0.5;
        end
        cityDist(j,i)=cityDist(i,j);
    end
end
nMax=200;                      
indiNumber=1000;               
individual=zeros(indiNumber,n);
% init
for i=1:indiNumber
    individual(i,:)=randperm(n);    
end

%% fitness
indiFit = fitness(individual,cityCoor,cityDist);
[value,index] = min(indiFit);
tourPbest = individual;                              %current best individual
tourGbest = individual(index,:) ;                    %current global best 
recordPbest = inf*ones(1,indiNumber);                %record best individual
recordGbest = indiFit(index);                        %record global best
xnew1 = individual;

%% search best path
L_best=zeros(1,nMax);
for N=1:nMax
    
    indiFit=fitness(individual,cityCoor,cityDist);
    
    %update
    for i=1:indiNumber
        if indiFit(i)<recordPbest(i)
            recordPbest(i)=indiFit(i);
            tourPbest(i,:)=individual(i,:);
        end
        if indiFit(i)<recordGbest
            recordGbest=indiFit(i);
            tourGbest=individual(i,:);
        end
    end
    
    [value,index]=min(recordPbest);
    recordGbest(N)=recordPbest(index);
    
    %% intersect
    for i=1:indiNumber
       % with the best individual
        c1=unidrnd(n-1); %generate intersect position
        c2=unidrnd(n-1); %generate intersect position
        while c1==c2
            c1=round(rand*(n-2))+1;
            c2=round(rand*(n-2))+1;
        end
        chb1=min(c1,c2);
        chb2=max(c1,c2);
        cros=tourPbest(i,chb1:chb2);
        ncros=size(cros,2);      
        % rm the same elements
        for j=1:ncros
            for k=1:n
                if xnew1(i,k)==cros(j)
                    xnew1(i,k)=0;
                    for t=1:n-k
                        temp=xnew1(i,k+t-1);
                        xnew1(i,k+t-1)=xnew1(i,k+t);
                        xnew1(i,k+t)=temp;
                    end
                end
            end
        end
        %insert the cros area
        xnew1(i,n-ncros+1:n)=cros;
        %accepted if shorter
        dist=0;
        for j=1:n-1
            dist=dist+cityDist(xnew1(i,j),xnew1(i,j+1));
        end
        dist=dist+cityDist(xnew1(i,1),xnew1(i,n));
        if indiFit(i)>dist
            individual(i,:)=xnew1(i,:);
        end
        
        % interset with best global
        c1=round(rand*(n-2))+1;  %generate the cross position
        c2=round(rand*(n-2))+1;  %generate the cross position
        while c1==c2
            c1=round(rand*(n-2))+1;
            c2=round(rand*(n-2))+1;
        end
        chb1=min(c1,c2);
        chb2=max(c1,c2);
        cros=tourGbest(chb1:chb2); 
        ncros=size(cros,2);      
        %rm the same elements
        for j=1:ncros
            for k=1:n
                if xnew1(i,k)==cros(j)
                    xnew1(i,k)=0;
                    for t=1:n-k
                        temp=xnew1(i,k+t-1);
                        xnew1(i,k+t-1)=xnew1(i,k+t);
                        xnew1(i,k+t)=temp;
                    end
                end
            end
        end
        %insert the cross area
        xnew1(i,n-ncros+1:n)=cros;
        %accepted if shorter
        dist=0;
        for j=1:n-1
            dist=dist+cityDist(xnew1(i,j),xnew1(i,j+1));
        end
        dist=dist+cityDist(xnew1(i,1),xnew1(i,n));
        if indiFit(i)>dist
            individual(i,:)=xnew1(i,:);
        end
        
       %% variation
        c1=round(rand*(n-1))+1;   %generate the variation position
        c2=round(rand*(n-1))+1;   %generate the variation position
        while c1==c2
            c1=round(rand*(n-2))+1;
            c2=round(rand*(n-2))+1;
        end
        temp=xnew1(i,c1);
        xnew1(i,c1)=xnew1(i,c2);
        xnew1(i,c2)=temp;
        
        %accepted if shorter
        dist=0;
        for j=1:n-1
            dist=dist+cityDist(xnew1(i,j),xnew1(i,j+1));
        end
        dist=dist+cityDist(xnew1(i,1),xnew1(i,n));
        if indiFit(i)>dist
            individual(i,:)=xnew1(i,:);
        end
    end

    [value,index]=min(indiFit);
    L_best(N)=indiFit(index);
    tourGbest=individual(index,:); 
    
end

%% plot results
figure
plot(L_best)
title('procedure')
xlabel('iters')
ylabel('fitness')
grid on


figure
hold on
plot([cityCoor(tourGbest(1),1),cityCoor(tourGbest(n),1)],[cityCoor(tourGbest(1),2),...
    cityCoor(tourGbest(n),2)],'ms-','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g')
hold on
for i=2:n
    plot([cityCoor(tourGbest(i-1),1),cityCoor(tourGbest(i),1)],[cityCoor(tourGbest(i-1),2),...
        cityCoor(tourGbest(i),2)],'ms-','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g')
    hold on
end
legend('path')
scatter(cityCoor(:,1),cityCoor(:,2));
title('path','fontsize',10)
xlabel('km','fontsize',10)
ylabel('km','fontsize',10)

grid on
ylim([4 80]);
