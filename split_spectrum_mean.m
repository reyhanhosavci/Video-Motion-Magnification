function [meanOutput] = split_spectrum_mean(signal,window)
signalSize=size(signal,2);
N=size(signal,1);
numWindow=size(window,2);
real_inv=0;
for i=1:numWindow
    windowR=repmat(window(:,i),1,signalSize);
    Fs=fft(signal.*hamming(N))./N;
    R=Fs.*windowR.*sqrt(N);    
    iR=ifft(R);
    iR=iR.*N;
    real_inv=real(iR)+real_inv;   
end
meanOutput=real_inv./numWindow;
end

