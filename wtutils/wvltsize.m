function s=wvltsize(lx,k)

% WVLTSIZE  Calculates the final size of a Wavelet transform.
%
%           WVLTSIZE (LX,K) returns the size of the K-scales 
%           wavelet transform of a vector of length LX. 
%           The length of the wavelet transform may be grater
%           than the original signal because of the method
%           used to transform odd length signals.
%
%           See also: MAXRSIZE, WT, IWT, WT2D, IWT2D.
%

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
%       Author: Sergio J. Garcia Galan 
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------


lo(1)=lx;

for i=1:k
	lo(i+1)=floor((lo(i)+1)/2);	
end
s=sum(lo(2:k+1))+lo(k+1);
