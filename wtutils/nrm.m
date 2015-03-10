function tn=nrm(t)

%NRM    Creates a normalized version of a matrix.
%
%	NRM(X) will return a matrix equal to X but rescaled
%	in the range (0,1) and fixing the mean value to 0.5.
%       NRM is used by BANDADJ to normalize the wavelet 
%       transform subbands.
%
%	See also: BANDADJ, BANDEXT, EXTBAND

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
%  Modified by: Santiago Gonzalez Sanchez
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------


M=max(max(t));
m=min(min(t));
med=mean(mean(t));
if abs(M-med)>abs(m-med)
	mx=M-med;
else
	mx=med-m;
end
if mx
	tn=.5/mx*(t-med)+0.5;
else
	tn=0.5*ones(size(t));
end

