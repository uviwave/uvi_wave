function xhat=mycceps(x,L)

%MYCCEPS     Complex Cepstrum
%
%	     CX = MYCCEPS (X,L) calculates complex cepstrum of the
%	     real sequence X. L is the number of points of the fft
%	     used. L is optional and its default value is 1024 points.
%
%	     See also: FC_CEPS, INVCCEPS, REMEZWAV.


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

if nargin < 2
   L=1024;
end

H = fft(x,L);

%% H must not be zero
ind=find(abs(H)==0);
if length(ind) > 0 
   H(ind)=H(ind)+1e-25;
end

logH = log(abs(H))+sqrt(-1)*rcunwrap(angle(H));

xhat = real(ifft(logH));
