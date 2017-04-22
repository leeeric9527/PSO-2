function indiFit=fitness(x,cityCoor,cityDist)
%% compute the individual fitness
%x           input     individual
%cityCoor    input     city coordinate
%cityDist    input     city distance
%indiFit     output    fitness

m = size(x,1);
n = size(cityCoor,1);
indiFit = zeros(m,1);
for i=1:m
    for j=1:n-1
        indiFit(i) = indiFit(i)+cityDist(x(i,j),x(i,j+1));
    end
    indiFit(i) = indiFit(i)+cityDist(x(i,1),x(i,n));
end
end
