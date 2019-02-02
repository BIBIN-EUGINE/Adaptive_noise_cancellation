recObj = audiorecorder;
disp('Start speaking.')
% Record audio from the PC/mic.
recordblocking(recObj, 25);
disp('End of Recording.');
% Store data in double-precision array.
Orginal_signal = getaudiodata(recObj);

tic;
Orginal_signal = Orginal_signal/rms(Orginal_signal); % normalising the orginal signal
reference_signal = wgn(200000,1,-7);% White gaussian noise as reference signal
f = fir1(2,0.4);%  fir1 filter
reference_signal = filter(f,1,reference_signal); %Filtering the reference signal
primary = Orginal_signal + reference_signal; %Adding the noise to orginal signal


%intialization
N=length(primary); %lenght of the primary signal
u=zeros(1,2);% current values of reference in filter
w=zeros(1,2);% filter weights
e=zeros(1,N);% Denoised signal
mu=0.0005;   %Learning parameter
 
% LMS filter
 for n=1:N
     u(1) = reference_signal(n);
     y=u*w'; %filter noise signal
     e(n)=primary(n)-y;
     w = w + 2*mu*e(n).* u; % finding new filter coeff.
     u(2)=u(1); % assigning new values of reference signal
 end
 
sound(e);% Playing the denoised signal
 
%ploting  Signals in time domain
figure(1);
subplot(2,2,1);
plot(Orginal_signal);
xlabel('n');
ylabel('Orginal_Signal(n)');
title('Orginal Signal');
subplot(2,2,2);
plot(reference_signal);
xlabel('n');
ylabel('Reference_Signal(n)');
title('Reference Signal');
subplot(2,2,3);
plot(primary);
xlabel('n');
ylabel('Primary_Signal(n)');  
title('Primary Signal');
subplot(2,2,4);
plot(e);
ylabel('Denoised Signal');
title('Denoised Signal');


%ploting Signals in frequency domain
figure(2);
freqz(Orginal_signal);
title('Orginal Signal');
figure(3);
freqz(primary);
title('Primary Signal');
figure(4);
freqz(reference_signal);
title('Reference Signal');
figure(5);
freqz(e);%frequency response of denoised signal
title('Denoised Signal');
 
 % variance and snr
disp('variance of noise signal');
disp(var(reference_signal));% variance of the reference signal
figure(6);
snr(Orginal_signal,8000);% snr value of orginal signal
figure(7);
snr(primary,8000);% snr value of primary signal
figure(8);
snr(e,8000);% snr value of denoised signal
toc;
 

