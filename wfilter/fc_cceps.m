function  h=fc_cceps(poly,ro)

%FC_CCEPS    Performs a factorization using complex cepstrum.
%
%	     H = FC_CCEPS (POLY,RO) provides H that is the spectral
%	     factor of a FIR transfer function POLY(z) with non-negative 
%	     frequency response. This methode let us obtain lowpass
%	     filters of a bank structure without finding the POLY zeros.
%	     The filter obtained is minimum phase (all zeros are inside
%	     unit circle).
%		
%	     RO is a parameter used to move zeros out of unit circle.
%	     It is optional and the default value is RO=1.02.
%
%	     See also: INVCCEPS, MYCCEPS, REMEZWAV.
%
%	     References: P.P Vaidyanathan, "Multirate Systems and Filter
%			 Banks", pp. 849-857, Prentice-Hall, 1993


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
%       Author: Jose Martin Garcia
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------

if nargin < 2
	ro=1.02;
end

L=1024;   % number points of fft.

N=(length(poly)-1)/2;

%% Moving zeros out of unit circle
roo=(ro).^[0:2*N];
g=poly./roo;

%% Calculate complex cepstrum of secuence g
ghat=mycceps(g,L);

%% Fold the anticausal part of ghat, add it to the causal part and divide by 2
gcausal=ghat(1 : L/2);
gaux1=ghat(L/2+1 : L);
gaux2=gaux1(L/2 :-1: 1);
gantic=[0 gaux2(1 : L/2-1)];

xhat=0.5*(gcausal+gantic);

%% Calculate cepstral inversion
h=invcceps(xhat,N+1);
 
%% Low-pass filter has energie sqrt(2)
h=h*sqrt(2)/sum(h);
