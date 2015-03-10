function y=aprox(x,h,rh,sc);

%  APROX    Obtain a projection on the approximation space in the context
%           of the multiresolution analysis. 
%	
%	    Y = APROX (X,H,RH,SC) calculates the approximation of signal 
%           in X at the scale SC, using the analysis lowpass filter H and
%           the synthesis one RH.
%
%	    If APj is the approximation of X at scale 2^j, and DEi 
%           are the DETAIL outputs, for i=1...j, then
%
%		X = AP  + DE + ... + DE
%		      j	    j          1
%
%	    See also: DETAIL, MULTIRES, MRES2D, WT.	


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
%               Nuria Gonzalez Prelcic
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------

x=x(:)';
h=h(:)';
rh=rh(:)';

lx=length(x);
lf=length(h)+length(rh);
dd=floor((lf)/2)-1;
d=dd;
if sc>1
	for i=2:sc
		d=d+dd*2^(i-1);
	end
end

tt=x;

for i=1:sc,
	tt=conv(h,tt);
	tt=tt(1:2:length(tt));
end
for i=1:sc,
	tt=[tt;zeros(1,length(tt))];
	tt=conv(rh,tt(:)');
end

y=tt(1+d:lx+d);
