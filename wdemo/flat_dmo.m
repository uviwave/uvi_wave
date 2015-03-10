%FLAT_DMO   Demo script on Maximally Flat filters
%
%           FLAT_DMO is a demo script that illustrates the generation
%           of maximally flat orthogonal filters that lead to wavelet
%           bases. It also includes a demo for the cascade algorithm
%           used to obtain a discrete approximation of the continuous
%           scale and wavelet functions, and wavelet packet function too.
%   
%           FLAT_DMO may be accessed from the 'Filter Design' menu
%	    section of WTDEMO, choosing the 'Maximal Flatness' option.

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
%      Authors: Santiago Gonzalez Sanchez
%		Nuria Gonzalez Prelcic
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

% We will generate a set of maximally flat filters using MAXFLAT function.
% Two parameters have to be passed to this function: the degree of
% flatness at w=0 and at w=pi radians.
 
         [h,g,rh,rg]=maxflat(8,8);
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

         figure(2)
         set (2,'Position',[600,100,400,400]);
         subplot(221), plot(w,phaseH); title('arg(H)');
         subplot(222), plot(w,phaseG); title('arg(G)');
         subplot(223), plot(w,phaseRH); title('arg(RH)');
         subplot(224), plot(w,phaseRG); title('arg(RG)');

% The number of zeros at w=pi is equal to NPI=8.

% Press any key to continue ...
pause
%--------------------------------------------------------
clg

% MAXFLAT returns half band filters only if both degrees of flatness
% are equal. Let's see an example.

	figure(1), subplot(111)
	plot(w,abs(H))
	hold on, plot(w,abs(G),'r'), hold off
	xlabel('rad'), ylabel('|H|, |G|')
	figure(2)
	plot(w,abs(H).^2+abs(G).^2)
	title('N0=Npi=8')

% Figure 1 shows the magnitude spectrum of the lowpass and highpass
% filters, and figure 2 the overall power response for the filters with the
% same flatness in w=0 and w=pi. As you can see, they are quadrature
% mirror filters and cover all the spectrum.

% Press any key to continue ...
pause
%--------------------------------------------------------
	
% If we use different degrees, only the lowpass filters are correct
% (analysis and synthesis ones), because the algorithm assumes we
% are dealing with halfband orthogonal filters.

	[h1,g1,rh1,rg1]=maxflat(8,2);
	H1=freqz(h1,1,128);
	figure(1)
	plot(w,abs(H1))
	xlabel('rad'), ylabel('|H|')

% As a consequence, the highpass filters given by MAXFLAT in these
% cases cannot be used with our wavelet or wavelet packet transform
% functions, because they assume half band filters in their algorithms.

% Press any key to continue ...
pause
%--------------------------------------------------------

% The filters lead to a scale and wavelet function by means
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
	wavepack(rh,rg,6,6,0);
	subplot(212)
	wavepack(rh,rg,6,6,1);

% For example, figure 1 shows time and frequency response of the
% synthesis wavelet packet corresponding to the 6th node in a six
% levels depth transformation.

% As a consequence of the filter orthogonality, the analysis function
% comes from simply time-reversing the synthesis one.

% Press any key to finish ...
pause
%--------------------------------------------------------

echo off
close(1)
