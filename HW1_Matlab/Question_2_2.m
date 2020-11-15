%% Question 2.2
clear all;

notesfolder = 'Audio';
listname = dir([notesfolder filesep '*.aif']);

%% We read littlestar_piano.aif file
[l, fs_lp] = audioread([notesfolder filesep listname(1).name]);
l = l(:, 1);
l = resample(l, 16000, fs_lp);
spectrum_lp = stft(l', 2048, 256, 0, hann(2048));
s_lp=spectrum_lp;

s_lp(find(s_lp<max(s_lp(:))/100)) = 0 ;
s_lp = s_lp/norm(s_lp);

sphase_lp=spectrum_lp./(abs(spectrum_lp)+eps);

%% We read silentnigth_guitar.aif file
[s, fs] = audioread([notesfolder filesep listname(2).name]);
s = s(:, 1);
s = resample(s, 16000, fs);
spectrum = stft(s', 2048, 256, 0, hann(2048));
s_q=spectrum;

s_q(find(s_q<max(s_q(:))/100)) = 0 ;
s_q = s_q/norm(s_q);

sphase=spectrum./(abs(spectrum)+eps);
%% We read silentnigth_piano.aif file
[m, fsp] = audioread([notesfolder filesep listname(3).name]);
m = m(:, 1);
m = resample(m, 16000, fsp);
spectrum_p = stft(m', 2048, 256, 0, hann(2048));
s_p=spectrum_p;

s_p(find(s_p<max(s_p(:))/100)) = 0 ;
s_p = s_p/norm(s_p);

sphase_p=spectrum_p./(abs(spectrum_p)+eps);
%% Matrix transformation 
% We calculate Lg = Sg * Sp^-1 * Lp 
sphase_sqlp=pinv(sphase_p)*sphase_lp;
sphase_lq=sphase*sphase_sqlp;
s_sqlp=pinv(s_p)*s_lp;
s_lq=s_q * s_sqlp;

reconstructedsignal_quitar=1000*stft(s_lq.*sphase_lq,2048,256,0,hann(2048));
reconstructedsignal_quitar = resample(reconstructedsignal_quitar, fs, 16000);

filename = 'results/reconstructed_littlestar_guitar.wav';
audiowrite(filename,reconstructedsignal_quitar,fs);

