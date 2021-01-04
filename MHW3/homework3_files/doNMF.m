function B = doNMF(trainfcs,K,niter,Binit,Winit)

F = size(trainfcs,1); T = size(trainfcs,2);

ONES = ones(F,T);
B = Binit(1:F,1:K);
W = Winit(1:K,1:T);

for i=1:niter 
    
    % update activations
    W = W .* (B'*( trainfcs./(B*W+eps))) ./ (B'*ONES);
    
    % update dictionaries
    B = B .* ((trainfcs./(B*W+eps))*W') ./(ONES*W');
end
sumB = sum(B);
B = B*diag(1./sumB);
  
end