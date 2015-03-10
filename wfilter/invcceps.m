function  x=invcceps(xhat,L)

%INVCCEPS    Complex cepstrum Inversion
%
%	     X= INVCCEPS (CX,L) recovers X from its complex cepstrum sequence 
%	     CX. X has to be real, causal, and stable (X(z) has no zeros  
%	     outside unit circle) and x(0)>0. L is the length of the 
%	     recovered secuence.
%
%	     See also: MYCCEPS, FC_CCEPS, REMEZWAV.
%
%	     References: P.P Vaidyanathan, "Multirate Systems and Filter
%			 Banks", pp. 849-857, Prentice-Hall, 1993


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


x=zeros(1,L);

%% First point of x
x(1)=exp(xhat(1));

%% Recursion to obtain the other point of x
for muestra=1:L-1
   for k=1:muestra
	x(muestra+1)=x(muestra+1)+k/muestra*xhat(k+1)*x(muestra-k+1);
   end
end
