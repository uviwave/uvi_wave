function w=wavepack(h0,h1,j,i,pl)

%WAVEPACK    Constructs any wavelet packet function associated to a
%	     pair of wavelet filters.
%
%	     W = WAVEPACK(H,G,J,I) generates a discrete wavelet packet
%	     using a cascade algorithm. The first argument H is the
%	     lowpass filter and G is the highpass filter. J is the number
%	     of steps; the level of the tree-structured filter bank.
%	     I ranges from 0 to 2^J-1, and selects one "leave" of the
%	     J-steps tree.
%
%	     W = WAVEPACK(H,G,J,I,PL) will plot the function according to
%	     the following values of PL:
%
%		PL=0 -> Time domain plot. 
%		PL=1 -> Frequency domain plot.
%
%
%           See also: WAVELET, WPK.


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
%	Author: Santiago Gonzalez Sanchez
%	e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------


if (i<0)|(i>(2^j-1))
	disp('Wrong wavelet packet specification.')
	disp('i must be between 0 and 2^j-1')
	return
end

aux=i;			% We construct a vector containing the path through
for k=1:j-1		% the filter bank tree.
	tree_path=[rem(aux,2) tree_path];	% 0: lowpass filter, 1: highpass filter
	aux=floor(aux/2);			% The filter associated with tree_path(i)
end						% has to be interpolated with 2^(i-1)-1 zeros
tree_path=[aux tree_path];			% between each sample.

h0=h0(:)';	% Arrange the filters so that they are row vectors
h1=h1(:)';

if j==0		% At the first scale, the wavelet packet id d(t)
	w=1;
else		% For more than 1 scale, filters must be
		% interpolated and iterated

	eval(['w=h' int2str(tree_path(1)) ';'])		% 0: lowpass filter, 1: highpass filter
	for k=2:j
		eval(['hh=h' int2str(tree_path(k)) ';'])
		hh=[hh;zeros(2^(k-1)-1,length(hh))];	% interpolated h0/h1
		hh=hh(:)';				% with 2^(k-1)-1
		hh=hh(1:length(hh)-2^(k-1)+1);		% zeros
		w=conv(hh,w)*sqrt(2);
	end
end

% Plot the result if 5 input arguments are given

if nargin==5
	if pl==0		% Plot in time
		plot(w)
		titulo=['Wavelet Packet function: level ' int2str(j) ', node ' int2str(i)];
		title(titulo)
		xlabel('n')
	elseif pl==1		% Plot in frequency
		n=2^(ceil(log2(length(w))));
		t=fft(w,n);
		t=t(1:n/2+1);
		plot([0:2*pi/n:pi],abs(t))	
		title('Magnitude spectrum of Wavelet Packet function')
		xlabel('w (radians)')
	end
end

		
	
