
%Reading the music files

[speech,Fs_speech]= audioread('/Applications/speech8khz.wav');
[music,Fs_music]= audioread('/Applications/music16khz.wav');

%upsampling
x=upsample(speech,3);
NFFT0 = length(x);
Y0 = fft(x,NFFT0);
magnitudeY0 = abs(Y0);
figure(1);
freq=(0:NFFT0-1) * (Fs_speech*3) / NFFT0;
plot(freq,magnitudeY0);
title('After upsampling for speech8khz');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

%filter design
Hd = fdesign.lowpass('Fp,Fst,Ap,Ast',0.22,0.28,1,90);
d = design(Hd,'equiripple');
b1=coeffs(d);
C= struct2cell(b1);
A= cell2mat(C);

%downsampling 
down=filter(A,1,x);
x1=downsample(down,4);
NFFT = length(x1);
Y = fft(x1,NFFT);
magnitudeY = abs(Y);
figure(2);
freq1=(0:NFFT-1) * (3*Fs_speech/4) / NFFT;
plot(freq1,magnitudeY);
title('With AA, After upsampling and downsampling for speech8khz');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

%upsampling
x_m=upsample(music,3);
NFFT0_m = length(x_m);
Y0_m = fft(x_m,NFFT0_m);
magnitudeY0_m= abs(Y0_m);
figure(3);
freqm=(0:NFFT0_m-1) * (Fs_music*3) / NFFT0_m;
plot(freqm, magnitudeY0_m);
title('After upsampling for music16khz');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

%downsampling 
down_m=filter(A,1,x_m);
x1_m=downsample(down_m,4);
NFFT_m = length(x1_m);
Y_m= fft(x1_m,NFFT_m);
magnitudeY_m = abs(Y_m);
figure(4);
freq1=(0:NFFT_m-1) * (3*Fs_music/4) / NFFT_m;
plot(freq1,magnitudeY_m);
title('With AA, After upsampling and downsampling for music16khz');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
