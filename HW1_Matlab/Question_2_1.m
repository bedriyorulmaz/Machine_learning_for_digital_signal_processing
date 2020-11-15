%% We read the notes in note folder and get the spectrum.
clear all;

notesfolder = 'notes15';
listname = dir([notesfolder filesep '*.wav']);
notes = [];
for k = 1:length(listname)
    [s, fs] = audioread([notesfolder filesep listname(k).name]);
    s = s(:, 1);
    s = resample(s, 16000, fs);
    spectrum = stft(s', 2048, 256, 0, hann(2048));
    %Find the central frame 
    middle = ceil(size(spectrum, 2) /2); 
    note = abs(spectrum(:, middle)); 
    %Clean up everything more than 40 db below the peak 
    note(find(note<max(note(:))/100)) = 0 ;
    note = note/norm(note);
    %normalize the note to unit length 
    notes = [notes, note];
end

%% We read the 'polyushka'. We use stft function for spectrum.
[m, fs]=audioread("polyushka.wav");

m = resample(m, 16000, fs);
spectrum_m = stft(m', 2048, 256, 0, hann(2048));
note_m=spectrum_m;
sphase=spectrum_m./(abs(spectrum_m)+eps);
%% Matrix calculations
% NW = M  -->  W = N^-1 * M
% We find the inverse of N as using the 'pinv' function
% We did multiplication and reconstructing signal process
x = pinv(notes);
W= x * note_m;
W(find(W<0)) = 0 ;
W = real(W);
M=notes * W;

reconstructedsignal = stft(M.*sphase,2048,256,0,hann(2048));
reconstructedsignal = 100 * resample(reconstructedsignal, fs, 16000); % 40 db

filename = 'results/reconstructed_polyushka.wav';
audiowrite(filename,reconstructedsignal, fs);

%%
 

