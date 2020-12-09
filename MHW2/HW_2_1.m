nasacolor=imread("TarantulaNebula.jpg");
figure;
image(nasacolor)
nasa=sum(nasacolor,3,'double'); %sum up red+green+blue
m=max(max(nasa)); %find the max value
nasa=nasa*255/m;
figure;
colormap(gray(256))
image(nasa)
title('Grayscale NASA photo');
[U S V]=svd(nasa);
figure;
semilogy(diag(S))

nasa100=U(:,1:100)*S(1:100,1:100)*V(:,1:100)';
nasa50=U(:,1:50)*S(1:50,1:50)*V(:,1:50)';
nasa25=U(:,1:25)*S(1:25,1:25)*V(:,1:25)';
figure
image(nasa100)
title("nasa100")
figure;
image(nasa50)
title("nasa50")
figure;
image(nasa25)
title("nasa25")