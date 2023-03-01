function [filteredSignal] = bandpass_iir_filter(signal,f1,f2,Fs)
signalLength=size(signal,1);
for i=1:signalLength
    filteredSignal(i,:)=bandpass(signal(i,:),[f1 f2],Fs,'ImpulseResponse','iir');
end
end