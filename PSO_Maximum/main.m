%% clean workspace
clc
clear

%% init parameters
c1 = 1.49445;
c2 = 1.49445;

maxgen=300;      
sizepop=20;   

Vmax=0.5;
Vmin=-0.5;
popmax=2;
popmin=-2;

%% init particles and velocity
for i=1:sizepop
    % generate population by random
    pop(i,:)=2*[rand rand];    %init
    V(i,:)=0.5*[rand rand];  %init
    %compute fitness
    fitness(i)=fun(pop(i,:));   
end

%% individual maximum and global maximum
[bestfitness bestindex] = max(fitness);
zbest = pop(bestindex,:);   %global maximum
gbest=pop;    %individual maximum
fitnessgbest=fitness;   %for individual
fitnesszbest=bestfitness;   %for global

%% search the maximum by iterations
for i=1:maxgen
    
    for j=1:sizepop
        
        %update velocity
        V(j,:) = V(j,:) + c1*rand*(gbest(j,:) - pop(j,:)) + c2*rand*(zbest - pop(j,:));
        V(j,find(V(j,:)>Vmax)) = Vmax;
        V(j,find(V(j,:)<Vmin)) = Vmin;
        
        %update population
        pop(j,:) = pop(j,:) + V(j,:);
        pop(j,find(pop(j,:)>popmax)) = popmax;
        pop(j,find(pop(j,:)<popmin)) = popmin;
        
        %fitness
        fitness(j) = fun(pop(j,:)); 
    end
    
    for j=1:sizepop
        
        %update individual maximum
        if fitness(j) > fitnessgbest(j)
            gbest(j,:) = pop(j,:);
            fitnessgbest(j) = fitness(j);
        end
        
        %update social maximum
        if fitness(j) > fitnesszbest
            zbest = pop(j,:);
            fitnesszbest = fitness(j);
        end
    end
    xx(i,:) = zbest;
    yy(i) = fitnesszbest;    
        
end
%% analyze results
plot(yy)
title('best individual fitness','fontsize',12);
xlabel('iters','fontsize',12);ylabel('fitness','fontsize',12);
pause(20);
