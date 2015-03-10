function fase=atang2(R)

%ATANG2    PHASE=ATANG2(R) returns the phase contribution of
%	   a real zero. Linear terms have been removed. It is
%	   an auxiliary function used by SYMLETS.

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


w=[0:2*pi/1e3:2*pi];	%frequency axis

fas=atan( (1+R)/(1-R)*tan(w/2) );

if R<1
	fase=fas-w;
	cte=-pi;
else
	fase=fas+w;
	cte=pi;
end;
u=ceil(pi*1000/(2*pi))+2;
fase(u:1001)=fase(u:1001)-cte;
