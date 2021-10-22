function H = generate_print(x0)

Fs=44100;
len=size(x0);
N=len(1);

x=mean(transpose(x0));                                                     %Change the audio from Stereo to mono

orden=88;
beta=1.5;
kaiserWindow=kaiser(orden+1,beta);
hh=fir1(orden, 1/8,'low', kaiserWindow,'noscale');
                                                                           
xf=filter(hh,1,x);
xs=xf(1:8:N-7);                                                            %The sampling frequency is divided by a factor of 8

nwindow=2^11;                                                              %Spectrogram parameters are selected
window=hamming(nwindow);                                                   
noverlap=1828;                                                             
[s,f,t]=spectrogram(xs, window, noverlap, 'yaxis');                        %Spectrogram is generated
[fil,col]=size(s);

vec=floor( [logspace(log10(300),log10(2000),22)/2000]*fil );               %Logarithmically spaced frequency bands are selected
for n=1:col
    for m=1:21
        E(m,n)= mean(abs(s(vec(m):vec(m+1),n)).^2);                        %'E' is a matrix that contains the mean energy of the
    end                                                                    % frequency bands of the spectrogram
end
for n=2:col;
    for m=1:20;                                                            %'H' the Acoustic Fingerprint contains information         
        H(m,n-1)=[E(m+1,n)-E(m,n)] > [E(m+1,n-1)-E(m,n-1)];                % about the relationship of the energy from contiguous
    end                                                                    % frequency bands
end
end
