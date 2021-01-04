%{
This is a template main script for signal separation problem 

%}
%clear all;

musicw = audioread('musicf1.wav');
speechw = audioread('speechf1.wav');
mixedw = audioread('mixedf1.wav');


% ADD CODE TO COMPUTE MAG. SPECTOROGRAMS OF MUSIC AND SPEECH

music_spectrum = stft(musicw', 2048, 256, 0, hann(2048));
music_spec = abs(music_spectrum);


speech_spectrum = stft(speechw', 2048, 256, 0, hann(2048));
speech_spec = abs(speech_spectrum);


% ADD CODE TO CPMPUTE MAG. SPECTROGRAM AND PHASE OF MIXED
mixed_spectrum = stft(mixedw', 2048, 256, 0, hann(2048));
mixed_spec = abs(mixed_spectrum);
mixed_phase = mixed_spectrum ./ (abs(mixed_spectrum) + eps);


%
K = 200;
niter = 250;

Bminit = load('Bminit.mat');
Bminit = Bminit.Bm;
Wminit = load('Wminit.mat');
Wminit = Wminit.Wm;

Bsinit = load('Bsinit.mat');
Bsinit = Bsinit.Bs;
Wsinit = load('Wsinit.mat');
Wsinit = Wsinit.Ws;

Bm = doNMF(music_spec,K,niter,Bminit,Wminit);
Bs = doNMF(speech_spec,K,niter,Bsinit,Wsinit);

% ADD CODE TO SEPARATE SIGNALS
% INITIALIZE WEIGHTS INSIDE separate_signals using rand() function
[speech_recv, music_recv] = separate_signals(mixed_spec,Bm,Bs, niter);



% ADD CODE TO MULTIPLY BY PHASE AND RECONSTRUCT TIME DOMAIN SIGNAL
reconstructedSpeech = stft(speech_recv.*mixed_phase,2048,256,0,hann(2048));
reconstructedMusic = stft(music_recv.*mixed_phase,2048,256,0,hann(2048));
% WRITE TIME DOMAIN SPEECH AND MUSIC USING audiowrite with 16000 sampling
% frequency
audiowrite('ReconstructedSpeech.wav',reconstructedSpeech,16000);
audiowrite('ReconstructedMusic.wav',reconstructedMusic,16000);


