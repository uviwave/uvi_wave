function fase=atang1(R,alfa)

%ATANG1    PHASE=ATANG1(R,ALFA) returns the phase contribution
%	   of a complex pair of zeros. Linear terms have been
%	   removed. It is an auxiliary function used by SYMLETS.

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


w=[0:2*pi/1e3:2*pi];		%frequency axis

fas=atan( (1-R^2)*sin(w)./((1+R^2)*cos(w)-2*R*cos(alfa)) );

zero=acos(2*R*cos(alfa)/(1+R^2));
u1=ceil(zero*1000/(2*pi))+1;
u2=ceil((2*pi-zero)*1000/(2*pi))+1;
if (1-R^2)*sin(zero)<0
	cte=pi;
	fase=fas+w;
else
	fase=fas-w;
	cte=-pi;
end
fase(u1:1001)=fase(u1:1001)-cte;
fase(u2:1001)=fase(u2:1001)-cte;

