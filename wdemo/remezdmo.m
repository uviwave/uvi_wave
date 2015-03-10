%REMEZDMO   Demo script on Remez filters
%
%           REMEZDMO is a demo script that illustrates the generation
%           of orthonormal filters based on a Remez exchange algorithm
%	    and a spectral factorization. It also includes a demo for
%	    the cascade algorithm used to obtain a discrete approximation
%	    of the continuous scale and wavelet functions, and wavelet
%	    packet function too.
%   
%           REMEZDMO may be accessed from the 'Filter Design' menu
%	    section of WTDEMO, choosing the 'Remez' option.

%-------------------------------------------------------- 
% Copyright (C) 1994, 1995, 1996, by Universidad de Vigo 
%                                                      
%                                                      
% Uvi_Wave is free software; you can redistribute it and/or modify it      
% under the terms of the GNU General Public License as published by the    
% Free Software Foundation; either version 2, or (at your option) any      
% later version.                                                           
%                                                                          
% Uvi_Wave is distributed in the hope that it will be useful, but WITHOUT  
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or    
% FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License    
% for more details.                                                        
%                                                                          
% You should have received a copy of the GNU General Public License        
% along with Uvi_Wave; see the file COPYING.  If not, write to the Free    
% Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.             
%                                                                          
%       Author: Santiago Gonzalez Sanchez
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------

figure(1)
set (1,'Position',[100,100,400,400])
echo on

%--------------------------------------------------------

% First of all we will establish the following notation for the different filters:
%
%    h  : analysis lowpass filter 
%    g  : analysis highpass filter
%    rh : synthesis lowpass filter 
%    rg : synthesis highpass filter

% Press any key to continue ...
pause
%--------------------------------------------------------

% We will generate a set of Remez filters using the REMEZFLT function.
% This function has four input arguments:
%
%	L: length of the desired filters
%	K: degree of flatness at z=-1 (w=pi)
%	B: normalized transition bandwidth

% For this example, we have set L=80, K=2 and B=0.05.

         [h,g,rh,rg]=remezflt(40,2,0.05);
         subplot(221); plot(h); title('h');
         subplot(222); plot(g): title('g'); 
         subplot(223); plot(rh); title('rh');
         subplot(224); plot(rg); title('rg');
        
% They are orthogonal filters, so from a single filter (rh) it is possible
% to obtain the other.

% Press any key to continue ...
pause
%--------------------------------------------------------

% Now, we can observe the frequency responses of these filters:

         [H,w] = freqz(h,1,128);
         magH = abs(H);  phaseH = angle(H);

         [G,w] = freqz(g,1,128);
         magG = abs(G);  phaseG = angle(G);

         [RH,w] = freqz(rh,1,128);
         magRH = abs(RH);  phaseRH = angle(RH);

         [RG,w] = freqz(rg,1,128);
         magRG = abs(RG);  phaseRG = angle(RG);

         subplot(221), plot(w,20*log10(magH)), title('|H| [dB]');
         subplot(222), plot(w,20*log10(magG)), title('|G| [dB]');
         subplot(223), plot(w,20*log10(magRH)), title('|RH| [dB]');
         subplot(224), plot(w,20*log10(magRG)), title('|RG| [dB]');

         figure(2)
         set (2,'Position',[600,100,400,400])
         subplot(221), plot(w,phaseH); title('arg(H)');
         subplot(222), plot(w,phaseG); title('arg(G)');
         subplot(223), plot(w,phaseRH); title('arg(RH)');
         subplot(224), plot(w,phaseRG); title('arg(RG)');

% Press any key to continue ...
pause
%--------------------------------------------------------
close(2)

% By means of the input arguments, we can vary some features of the
% filter. Let us see an example with wider transition bandwidth.

	h1=remezflt(40,2,0.1);
	subplot(111)
	H1=freqz(h1,1,128);
	plot(w,20*log10(magH))
	hold on, plot(w,20*log10(abs(H1)),'r')
	hold off
	ylabel('|H| [dB]'), xlabel('[rad]')
	title('Yellow: B=0.05 , Red: B=0.1')

% Figure 1 shows the magnitude response for this filter and the previous
% one. As you can see, a sharper transition band produces lower stopband
% attenuation.  
	 
% Press any key to continue ...
pause
%--------------------------------------------------------

% The K parameter allows us to control the number of zeros at z=-1 of the
% lowpass filters. The presence of zeros at the aliasing frequency is a
% necessary condition for regularity of the wavelet filters, but does
% not assure it. 

	h1=remezflt(40,15,0.05);
	H1=freqz(h1,1,128);
	plot(w,20*log10(magH))
	hold on, plot(w,20*log10(abs(H1)),'r')
	hold off
	ylabel('|H| [dB]'), xlabel('[rad]')
	title('Yellow: K=2 , Red: K=15')

% Figure 1 shows the spectral responses for the first calculated filter
% and another with same L, B but K=10 instead of 2. The larger attenuation
% around w=pi is due to the higher degree of flatness.
% However the attenuation in the rest of stopband decreases, and the
% transition bandwidth increases.

% Press any key to continue ...
pause
%--------------------------------------------------------

% From the discrete-time filters we obtain the scale and wavelet function
% by means of a cascade algorithm implemented in WAVELET:


         [s,w]=wavelet(rh,rg,6);
         subplot(211), plot(s), title('Synthesis Scale Function')
         subplot(212), plot(w), title('Synthesis Wavelet Function')

% We have considered that with 6 iterations of the algorithm, the
% approximation is good enough.

% Press any key to continue ...
pause
%--------------------------------------------------------

% Moreover, we can obtain any wavelet packet function using these
% filters by means of WAVEPACK function.

	subplot(211)
	wavepack(rh,rg,6,6,0);
	subplot(212)
	wavepack(rh,rg,6,6,1);

% For example, figure 1 shows time and frequency response of the
% synthesis wavelet packet corresponding to the 6th node in a six
% levels depth transformation.

% As a consequence of the filter orthogonality, the analysis function
% comes from simply time-reversing the synthesis one.

% Press any key to finish...
pause
%--------------------------------------------------------

echo off
close(1)
