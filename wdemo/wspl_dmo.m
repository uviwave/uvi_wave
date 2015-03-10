%WSPL_DMO   demo script on spline biorthogonal filter generation.
%
%           WSPL_DMO is a demo script that illustrates the generation
%           of spline biorthogonal filters that lead to wavelet
%           bases. It also includes a demo for the cascade algorithm
%           used to obtain a discrete approximation of the continuous
%           scale and wavelet functions, and wavelet packet function too.
%   
%           WSPL_DMO may be accessed from the 'Filter Design' menu
%	    section of WTDEMO, choosing the 'Spline' option.


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
%       Author: Nuria Gonzalez Prelcic
%  Modified by: Santiago Gonzalez Sanchez
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------

figure(1)
set (1,'Position',[100,100,400,400]);
echo on

%--------------------------------------------------------

% We will establish the following notation for the different filters:
%
%    h  : analysis lowpass filter 
%    g  : analysis highpass filter
%    rh : synthesis lowpass filter 
%    rg : synthesis highpass filter

% Press any key to continue ...
pause
%--------------------------------------------------------

% Now, we are going to generate biorthogonal filters. There are different
% families, but we have implemented the spline wavelets. In this case
% we have to generate two different filters, and from them we obtain the
% pair we need to complete the set.


         [h,g,rh,rg]=wspline(3,7);
         clg
         subplot(221); plot(h); title('h');
         subplot(222); plot(g): title('g'); 
         subplot(223); plot(rh); title('rh');
         subplot(224); plot(rg); title('rg');

% 3 and 7 specify the number of zeros in z=-1 required for H(z) and RH(z) 
% respectively.

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

         subplot(221), plot(w,20*log10(magH)), title('|H|[dB]')
         subplot(222), plot(w,20*log10(magG)), title('|G|[dB]')
         subplot(223), plot(w,20*log10(magRH)), title('|RH|[dB]')
         subplot(224), plot(w,20*log10(magRG)), title('|RG|[dB]')

         figure(2)
         set (2,'Position',[600,100,400,400])
         subplot(221), plot(w,phaseH), title('arg(H)')
         subplot(222), plot(w,phaseG), title('arg(G)')
         subplot(223), plot(w,phaseRH), title('arg(RH)')
         subplot(224), plot(w,phaseRG), title('arg(RG)')

% You can observe how these filters are linear phase.

% Press any key to continue ...
pause
%--------------------------------------------------------

% In the next figure you can observe the dual scale and wavelet
% functions. Note how these filters lead to antisymmetric wavelet
% functions.

         [s,w]=wavelet(rh,rg,6);
         figure(1)
         subplot(211), plot(s), title('Synthesis Scale function');
         subplot(212), plot(w), title('Synthesis Wavelet function');
         
         hrev=h(length(h):-1:1); grev=g(length(g):-1:1);
         [sd,wd]=wavelet(hrev,grev,6);
         figure(2); 
         subplot(211), plot(sd), title('Analysis Scale function');
         subplot(212), plot(wd), title('Analysis Wavelet function');
 
% It has been considered that the approximation is good enough
% with 6 iterations of the algorithm.

% Press any key to continue ...
pause
%--------------------------------------------------------

% If we choose other arguments for the wspline function,
% we can obtain symmetric wavelet functions.

         [h,g,rh,rg]=wspline(2,6);

         [s,w]=wavelet(rh,rg,6);
         figure(1)
         subplot(211), plot(s), title('Synthesis Scale function');
         subplot(212), plot(w), title('Synthesis Wavelet function');
         
         hrev=h(length(h):-1:1); grev=g(length(g):-1:1);
         [sd,wd]=wavelet(hrev,grev,6);
         figure(2)
         subplot(211), plot(sd), title('Analysis Scale function');
         subplot(212), plot(wd), title('Analysis Wavelet function');

% Press any key to continue ...
pause
%--------------------------------------------------------
clg

% Moreover, we can obtain any wavelet packet function using these
% filters by means of "wavepack" function.

	figure(1), clg
	subplot(211)
	wavepack(rh,rg,6,6,0);
	subplot(212)
	wavepack(rh,rg,6,6,1);

% For example, figure 1 shows time and frequency response of the
% synthesis wavelet packet corresponding to the 6th node in a six
% levels depth transformation.
% Figure 2 shows the function corresponding to the analysis stage.

	figure(2)
	subplot(211)
	wavepack(h,g,6,6,0);
	subplot(212)
	wavepack(h,g,6,6,1);
 

% Press any key to continue ...
pause
%-------------------------------------------------------- 

% With these examples is possible to achieve arbitrarily high regularity.
% Being M the first argument of wspline and N the second one, for large
% M, the analysis wavelet will belong to C^k if N>4.165M+5.165(k+1).
% In the next figure you can observe an analysis wavelet not very
% regular. This is due to the relation between M and N (3 and 3 for the
% example).

         [h,g,rh,rg]=wspline(3,3);

         [s,w]=wavelet(rh,rg,6);
         figure(1)
         subplot(211), plot(s), title('Synthesis Scale function')
         subplot(212), plot(w), title('Synthesis Wavelet function')
         
         hrev=h(length(h):-1:1); grev=g(length(g):-1:1);
         [sd,wd]=wavelet(hrev,grev,6);
         figure(2)
         subplot(211), plot(sd), title('Analysis Scale function')
         subplot(212), plot(wd), title('Analysis Wavelet function')

% Press any key to finish...
pause
%------------------------------------------------------

echo off
close(1)
close(2)
