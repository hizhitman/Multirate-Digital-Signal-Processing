%Filter Design
[speech,fs]=audioread('/Applications/speech8khz.wav');
rp = 0.004; 
rs = 0.003; 
f = [0.45*(fs/2) 0.55*(fs/2)]; 
a = [1 0]; 
dev = [rp rs];
[n,fo,ao,w] = firpmord(f,a,dev,fs);
n=2*floor(n/2)-1;
b = firpm(n,fo,ao,w);
display(n);
typeoffilter=firtype(b);

freqz(b); %filter plots

h= b.* real(exp(1j*-1*pi*(0: n)));
zerophase(dfilt.dffir(conv(b, b) - conv(h,h))); %T_zp plot

H_0_0=b(1:2:end); %polyphase decomposition
H_1_0=b(2:2:end); %polyphase decomposition


x_d=downsample([speech;0], 2); % ;0 adds one zero to the end. This essentially equates the sizes of the two vectors. This indirectly starts x from x(-1)
s_d=downsample([zeros(1, size(speech,2));speech],2); %we are essentially adding one 0 before the whole vector to delay the vector by one sample

t_0=filter(H_0_0,1,x_d);%outputs of the polyphase filters
t_1=filter(H_1_0,1,s_d);

v_d_0=t_0+t_1;%final analysis bank outputs after passing through the IDFT matrix of order 2, without the 1/2 factor
v_d_1=t_0-t_1;
%output_v=[v_d_0;v_d_1];

u_0=v_d_0+v_d_1;%The inputs for the K_0 filters are obtained by passing the previous outputs  through the DFT matrix of order 2
u_1=v_d_0-v_d_1;

%Case1
op1=filter(H_1_0,1,u_0);
op2=filter(H_0_0,1,u_1);

op_com1=upsample(op1,2);
op_com2=upsample(op2,2);
op_com1=[0;op_com1]; %We delay the first output since the commutator reaches it finally
op_com2=[op_com2;0]; %We start with the second output since the commutator starts from it
final_output1=[op_com1;op_com2];%the final output is the concatenation of these two outputs

figure(1);
L = length(op_com1);
Y = fft(op_com1);
f_vector = (-L/2:L/2-1)*2*pi/L;
plot(f_vector, fftshift(abs(Y)));
title('Magnitude Spectrum of output of v_d_0 for Case 1');
xlabel('Frequency');
ylabel('Magnitude')
xlim([-pi, pi]);
xticks((-2:2)*pi/2);
xticklabels({ '-\pi','-0.5\pi', '0', '0.5\pi', '\pi'});

figure(2);
L = length(op_com2);
Y = fft(op_com2);
f_vector = (-L/2:L/2-1)*2*pi/L;
plot(f_vector, fftshift(abs(Y)));
title('Magnitude Spectrum of output of v_d_1 for Case 1');
xlabel('Frequency');
ylabel('Magnitude')
xlim([-pi, pi]);
xticks((-2:2)*pi/2);
xticklabels({ '-\pi','-0.5\pi', '0', '0.5\pi', '\pi'});

%Case2
opp1=filter(H_0_0,1,u_0);
opp2=filter(H_1_0,1,u_1);

opp_com1=upsample(opp1,2);
opp_com2=upsample(opp2,2);
opp_com1=[0;opp_com1];
opp_com2=[opp_com2;0];
final_output2=[opp_com1;opp_com2]

figure(3);
L = length(opp_com1);
Y = fft(opp_com1);
f_vector = (-L/2:L/2-1)*2*pi/L;
plot(f_vector, fftshift(abs(Y)));
title('Magnitude Spectrum of output of v_d_0 for Case 2');
xlabel('Frequency');
ylabel('Magnitude')
xlim([-pi, pi]);
xticks((-2:2)*pi/2);
xticklabels({ '-\pi','-0.5\pi', '0', '0.5\pi', '\pi'});

figure(4);
L = length(opp_com2);
Y = fft(opp_com2);
f_vector = (-L/2:L/2-1)*2*pi/L;
plot(f_vector, fftshift(abs(Y)));
title('Magnitude Spectrum of output of v_d_1 for Case 2');
xlabel('Frequency');
ylabel('Magnitude')
xlim([-pi, pi]);
xticks((-2:2)*pi/2);
xticklabels({ '-\pi','-0.5\pi', '0', '0.5\pi', '\pi'});

%final output plots

figure(5);
L = length(final_output1);
Y = fft(final_output1);
f_vector = (-L/2:L/2-1)*2*pi/L;
plot(f_vector, fftshift(abs(Y)));
title('Magnitude Spectrum of final audio output for Case 1');
xlabel('Frequency');
ylabel('Magnitude')
xlim([-pi, pi]);
xticks((-2:2)*pi/2);
xticklabels({ '-\pi','-0.5\pi', '0', '0.5\pi', '\pi'});


figure(6);
L = length(final_output2);
Y = fft(final_output2);
f_vector = (-L/2:L/2-1)*2*pi/L;
plot(f_vector, fftshift(abs(Y)));
title('Magnitude Spectrum of final audio output for Case 2');
xlabel('Frequency');
ylabel('Magnitude')
xlim([-pi, pi]);
xticks((-2:2)*pi/2);
xticklabels({ '-\pi','-0.5\pi', '0', '0.5\pi', '\pi'});
