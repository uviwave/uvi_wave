%BTLMRDMO   Demo script on Battle-Lemarie orthogonal filters
%
%           BTLMRDMO is a demo script that illustrates the generation
%           of Battle-Lemarie orthogonal filters that lead to wavelet
%           bases. It also includes a demo for the cascade algorithm
%           used to obtain a discrete approximation of the continuous
%           scale and wavelet functions, and wavelet packet function too.
%   
%           BTLMRDMO may be accessed from the 'Filter Design' menu
%	    section of WTDEMO, choosing the 'Battle-Lemarie' option.

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
%      Authors: Nuria Gonzalez Prelcic 
%		Santiago Gonzalez Sanchez
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

% We will generate a set of Battle-Lemarie filters using LEMARIE function.
% The argument of this function is the number of coefficients (the same
% for all filters).

         [h,g,rh,rg]=lemarie(16);
         subplot(221); plot(h); title('h');
         subplot(222); plot(g): title('g'); 
         subplot(223); plot(rh); title('rh');
         subplot(224); plot(rg); title('rg');
        
% You can observe how from a single filter (rh) it is possible to obtain
% the remainder ones. Only orthogonal filters verify this property.

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

         figure(2);
         set (2,'Position',[600,100,400,400]);
         subplot(221), plot(w,phaseH); title('arg(H)');
         subplot(222), plot(w,phaseG); title('arg(G)');
         subplot(223), plot(w,phaseRH); title('arg(RH)');
         subplot(224), plot(w,phaseRG); title('arg(RG)');

% Press any key to continue ...
pause
%--------------------------------------------------------

% From these filters we obtain the scale and wavelet function by means
% of a cascade algorithm implemented in WAVELET:


         close(2), clg
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

	clg
	subplot(211)
	wavepack(rh,rg,6,7,0);
	subplot(212)
	wavepack(rh,rg,6,7,1);

% For example, figure 1 shows time and frequency response of the
% synthesis wavelet packet corresponding to the 7th node in a six
% levels depth transformation.

% As a consequence of the filter orthogonality, the analysis function
% comes from simply time-reversing the synthesis one.

% Press any key to finish...
pause
%--------------------------------------------------------

echo off
close(1)
