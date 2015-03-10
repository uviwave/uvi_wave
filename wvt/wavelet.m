function [f,w]=wavelet(h,g,j,pl)

%WAVELET    Construct the wavelet and scale functions associated to a
%           pair of wavelet filters
% 
%           [S,W] = WAVELET(H,G,J) generates the compactly supported 
%           wavelet and scale functions using a successive filtering 
%           or cascade algorithm. J is the number of steps. The first 
%           argument H is the lowpass filter and the second argument G 
%           the highpass filter.
%
%           [S,W] = WAVELET(H,G,J,PL) will also plot the functions
%           according to the following values of PL: 
%
%		PL=0 -> Time domain plot. 
%		PL=1 -> Frequency domain plot.
%
%
%           See also: MULTIRES, MRES2D, WT, WT2D.


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
%               Sergio J. Garcia Galan
%  Modified by: Santiago Gonzalez Sanchez
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------



h=h(:)';	% Arrange the filters so that they are row vectors
g=g(:)';

hh=h;			% At the 1st scale, the wavelet and scale 
gg=g;			% functions are the same filters.

if j==0,		% At the 0 scale, the wavelet and scale  	
	hh=1;		% functions are d(t)
	gg=1;
end;

if j>1			% For more than 1 scale, filters must be
			% interpolated and iterated.
		
			% First, calculate the (j-1)-scale Scale
			% function:
	for k=2:j-1
		h1=[h;zeros(2^(k-1)-1,length(h))];	% interpolated h
		h1=h1(:)';				% with 2^(k-1)-1
		h1=h1(1:length(h1)-2^(k-1)+1);		% zeros
		hh=conv(h1,hh)*sqrt(2);	
	end

			% And now the j-scale wavelet function
			% based on the previous scale function

	g1=[g;zeros(2^(j-1)-1,length(g))];	% interpolated g
	g1=g1(:)';			
	g1=g1(1:length(g1)-2^(j-1)+1);
	gg=conv(g1,hh)*sqrt(2);	

			% And the j-scale Scale function
			% Based on the (j-1)-scale Scale function

	h1=[h;zeros(2^(j-1)-1,length(h))];	% interpolated h
	h1=h1(:)';			
	h1=h1(1:length(h1)-2^(j-1)+1);
	hh=conv(h1,hh)*sqrt(2);	
end;

f = hh;			% f holds the scale function
w = gg;			% w holds the wavelet function

%%%%%%%% PLOT RESULT IF 4 PARAMETERS ARE GIVEN %%%%%%%%

if nargin==4
	if pl==0			% TWO SUBPLOTS IN TIME
		subplot(2,1,1)
		plot(f)
		title('Scale function')
		subplot(2,1,2)
		plot(w)
		title('Wavelet function')
		xlabel('n')
	end
	if pl==1			% TWO SUBPLOTS IN FREQUENCY
		subplot(2,1,1)
		n=2^(ceil(log2(length(f))));
		t=fft(f,n);
		t=t(1:n/2+1);
		plot([0:2*pi/n:pi],abs(t))	
		title('Spectrum of Scale function')
		subplot(2,1,2)
		n=2^(ceil(log2(length(w))));
		t=fft(w,n);
		t=t(1:n/2+1);
		plot([0:2*pi/n:pi],abs(t))	
		title('Spectrum of Wavelet function')
		xlabel('w (radians)')
	end
end
