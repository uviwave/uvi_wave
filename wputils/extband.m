function [b,x1,y1,x2,y2]=extband(w,basis,q,sizx,sizy)

%EXTBAND    Extracts the Wavelet Packet coefficients corresponding to
%           a single subband.
%
%           B = EXTBAND(W,BASIS,N) extracts the N-th subband from
%	    the W transform, which was obtained with BASIS.
%           N=1 indicates the lowest subband or the lowpass iterated
%	    branch.
%
%	    B = EXTBAND(W,BASIS,N,SIZX,SIZY) can be also used, providing
%	    the number of columns SIZX and rows SIZY of the original
%	    signal. This must be used if any of that sizes is not a power
%	    of two. By default, they are set to the size of W.
%
%           [B,X1,Y1,X2,Y2] = EXTBAND (...) will also return
%	    the coordinates of the extracted band.
%
%	    This function works with one dimensional transforms, too.
%	    The X or Y coordinates will be equal to 1 depending on
%	    SIZX, SIZY. 
%
%           See also: INSBAND, SITEBAND, WPK, WPK2D. 

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

if nargin==3
	sizx=size(w,2);
	sizy=size(w,1);
end

[x1,y1,x2,y2]=siteband(sizx,sizy,basis,q);
if x1>0
	b=w(y1:y2,x1:x2);
end

% Another long function!
