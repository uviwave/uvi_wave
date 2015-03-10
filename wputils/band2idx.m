function [j,i]=band2idx(basis,n)

%BAND2IDX    [J,I]=BAND2IDX(BASIS,N) returns the level J and the
%	     node I of the wavelet packet tree that correspond to
%	     the N-th element of BASIS vector.
%
%            [J,I] may be used as input arguments in WAVEPACK, for
%            obtaining the analysis or synthesis wavelet packet
%            corresponding to BASIS(N).
%
%	     Remarks:
%	     - This function works with 1-D signals only.
%            - BASIS must be ordered according to the filter
%	       bank tree in order to obtain correct outputs.
%
%            Run the script 'BASIS' for help on the basis format.
%            See also: WAVEPACK.


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


j=basis(n);
basis=j-basis(1:n-1);
i=sum(2.^basis);

% Another long function !
