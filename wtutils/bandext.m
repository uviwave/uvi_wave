function [bnd,x1,y1,x2,y2] = bandext(wx,k,q,a,sizx,sizy)

%BANDEXT  Extracts a subband from a Wavelet transform.
%
%         BANDEXT (WT,K,Q,BT) extracts the subband from scale Q 
%         specified by parameter BT from the K-scales Wavelet 
%         transform WT. The BT specification must be:
%               0 : Lowpass residue if Q=K. If Q<>K returns 
%                   the coords. of a non existing band.
%               1 : Horizontal high frequency band.
%               2 : Vertical high frequency band. 
%               3 : Diagonal high frequency band.
%         
%	  BANDEXT(WT,K,Q,BT,SIZX,SIZY) can be also used, providing
%	  the number of columns SIZX and rows SIZY of the original
%	  signal. This must be used if any of that sizes is not a power
%	  of two. By default, they are set the largest as possible. 
%
%         [BAND,X1,Y1,X2,Y2] = BANDEXT (...) will also 
%         return the coordinates of the subband. 
%
%         This function also works with 1D wavelet vectors.
%
%         See also: BANDSITE, BANDINS, BANDADJ, WT, WT2D.


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
%  Modified by: Santiago Goznalez Sanchez
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------

if nargin==4
	sizx=maxrsize(size(wx,2),k);
	sizy=maxrsize(size(wx,1),k);
end

[x1,y1,x2,y2] = bandsite(sizx,sizy,k,q,a);
if x1>0
	bnd=wx(y1:y2,x1:x2);
end

%%%%   Sorry, I'll shorten this large function any day !!!! 
