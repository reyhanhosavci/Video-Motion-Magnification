%% windowSize
%% overlap_c
%% cutoffFreq1
%% cutoffFreq2
%% signalLength
%% Fs
function [window] = gaussianwindow_BP(windowSize,overlap_c,cutoffFreq1, cutoffFreq2,signalLength,Fs )
x=(0:signalLength/2-1)*Fs/signalLength; 
n=1:windowSize;

w = gausswin(windowSize);
% w = gausswin(windowSize);
% w= w.*sqrt(signalLength/sum(w.^2));

overlap_c=windowSize-overlap_c;
cutoffFreq1=floor(cutoffFreq1*signalLength/Fs+1);
cutoffFreq2=floor(cutoffFreq2*signalLength/Fs);
window=zeros(signalLength,1);
n=n+cutoffFreq1;
i=1;
while i>0
      window(n,i)=w;
    [w,n]=sigshift(w,n,overlap_c);
    if n(end)>cutoffFreq2
        break;
    end
    i=i+1;
end
disp('Number of windows:')
disp(i)
window=window(1:signalLength,:);
figure, 
plot(x,window(1:signalLength/2,:));
end
