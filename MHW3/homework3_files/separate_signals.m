function [speech_recv, music_recv] = separate_signals(mixed_spec,Bmusic,Bspeech, niter)

F = size(mixed_spec,1); T = size(mixed_spec,2);

B = [Bmusic Bspeech];
W = 1 + rand(size(B,2), T);

ONES = ones(F,T);

for i=1:niter 
    
    % update activations
    W = W .* (B'*( mixed_spec./(B*W+eps))) ./ (B'*ONES);
    
    % update dictionaries
    %B = B .* ((mixed_spec./(B*W+eps))*W') ./(ONES*W');
end
sumB = sum(B);
B = B*diag(1./sumB);
W = diag(sumB)*W;

music_recv = mixed_spec .* ((B(:,1:200)*W(1:200,:) ./ (B*W)));
speech_recv = mixed_spec .* ((B(:,201:end)*W(201:end,:) ./ (B*W)));

end