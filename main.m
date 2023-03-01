%% MOTION MAGNFICICATION USING SPLIT SPECTRUM PROCESSING/ BAND PASS FILTER
%% creating simulation frames
% bunun yerine videoReadFunction() ile herhangi videoyu okuyabilirsin ve
% frameler �zerinde tek tek i�lem yapabilirsin.
A=zeros(128,128);
r = 35; %radius
m = {64,64}; %midpoint
A(m{:})=1;
B = bwdist(A) <= r;
B=im2double(B);
f=5; % frekans
A1=0.25;%kayma miktar�
fs=30;%frame
alpha=5;

for i=1:180
    J = imtranslate(B,[0, A1.*sin(2*pi.*(f./fs).*i)],'FillValues',0);
    sim{i}=J;
%     imshow(J);
    J1 = imtranslate(B,[0, A1.*(1+alpha)*sin(2*pi.*(f./fs).*i)],'FillValues',0);
    sim_gt{i}=J1;% kesin referans olu�turma
end

frames=sim;% here you can use videoReadFunction() and frames will be uploaded
num_frames=180;% write down how many frames you want to read (I write 180 frames because simulation has 180 frames)
min_size = min([size(frames{1},1) size(frames{1},2)]);%g�r�nt� piramidinde seviye de�erini belirlemek i�in yard�mc�
depth = floor(log(min_size)/ log(2)) - 4;% g�r�nt� piramidi i�in seviye de�eri
%% SSP de�erleri
windowSize=11;% ssp i�in pencere geni�li�i
overlap_c=10;%bir sonraki gauss pencere i�in �teleme miktar�
f1=4;%al�ak kesim frekans�
f2=7;%y�ksek kesim frekans�
Fs=30;% video �er�eve h�z�
window=gaussianwindow_BP(windowSize,overlap_c,f1,f2,num_frames,Fs);%ssp i�in gauss pencerelerin olu�turulmas�
%% UZAMSAL AYRI�TIRMA
%% Laplace g�r�nt� piramitleri
for j=1:num_frames
    gauss_pyramids{j}= gauss_pyramid(double(frames{j}),depth);
    lapl_pyramids{j}= lapl_pyramid_2d(gauss_pyramids{j});
end
for j=1:depth+1
    clear L2D
    for i=1:num_frames
        L2D(:,i)= reshape(lapl_pyramids{i}{j}(:,:),size(lapl_pyramids{i}{j},1)*size(lapl_pyramids{i}{j},2),1);
    end
    L_2D{j}=L2D;% bu a�amadan sonra s�zge�leme i�lemi yap�l�yor
    % ister Bantge�iren s�zge� ile yap ister SSP ile yap 
end
clear L2D
%% SSP ortalama - ZAMANSAL ��LEME - F�LTRELEME B�L�M�

for i=1:depth+1
    meanSSPOut{i}=split_spectrum_mean(L_2D{i}',window);
    i
end
alpha=5; % b�y�tme fakt�r�
magIm=L_2D;
for i=1:depth+1
    magIm{i} = L_2D{i}' + (1+alpha).*meanSSPOut{i};% b�y�tme i�in alpha ile �arp�p as�l de�erlerin �zerine eklendi�i b�l�m
end
%% GER� �ATMA
for j=1:depth+1
    for i=1:num_frames
        % piksellerin g�r�nt� haline getirilmesi
        consImages{j,i}=reshape(magIm{j}(i,:),size(lapl_pyramids{1}{j},1),size(lapl_pyramids{1}{j},2));
    end
end
for i=1:num_frames
    % piramitlerin geri �at�lmas� ve b�y�t�lm�� �er�evelerin elde edilmesi
    output_bp{i}=(collapse_2d(consImages(:,i)));
    imshow(output_bp{i})
end
%% Result 
for i=1:num_frames    
    imshow(frames{i}), title("Original frames")
end

for i=1:num_frames    
    imshow(output_bp{i}), title("Magnified frames")
end

% %% VIDEO MOTION MAGNIFICATION WITH BANDPASS FILTER
% % L_2D SSP ile ayn� i�lemlerin uyguland��� b�l�m 
% for i=1:depth+1
%     iirFilterOut{i}=bandpass_iir_filter(L_2D{i},f1,f2,fs);
%     i
% end
% alpha=5;
% mag_iir_out=L_2D;
% for  i=1:depth+1
%     mag_iir_out{i} = L_2D{i}+ (1+alpha)*iirFilterOut{i};
%     mag_iir_out{i}=permute(mag_iir_out{i}, [2 1 3]);
%     i
% end
% for j=1:depth+1
%     for i=1:num_frames
%         consImages{j,i}=reshape(mag_iir_out{j}(i,:),size(lapl_pyramids{1}{j},1),size(lapl_pyramids{1}{j},2));
%     end
% end
% 
% for i=1:num_frames
%     output_bp{i}=(collapse_2d(consImages(:,i)));
%     imshow(output_bp{i})
% end
% 
% %% Video yazd�rma
% implay(F)
% v = VideoWriter('simulation_video.avi');
% open(v);
% writeVideo(v,F);
% close(v);
