function r=tempreg(h,N,i)

%TEMPREG    Estimates Holder regularity index.
%
%	    R = TEMPREG (H,N,I) provides an Optimal Holder Regularity 
%	    Estimate, based on the temporal filter response. 
%	    H is the lowpass filter, N is the number of zeros of H at
%	    z=-1 and I is the number of iterations.
%
%	    See also: REGDAUB, SPECREG
%
%	    References: O. Rioul, "Regular Wavelets: A Discrete-Time Approach",
%		        IEEE Trans. on Signal Processing, December 1993

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


h=h*2/sum(h);

% removes all the zeroes at z=-1

for cont=1 :  N-1   
	f=deconv(h,[1/2 1/2]);	
	h=f;
end
f=deconv(h,[1 1]);

% iteration of F(Z):   F(Z)*F(Z^2)*F(Z^4)*..

f_iter=f;
for k=2:i
	g=[f;zeros(2^(k-1)-1,length(f))];
	g=g(:)';
	g=g(1:length(g)-2^(k-1)+1);
	f_iter=conv(f_iter,g);
end

% computation of alfa parameter
for cont=1:2^i
	k=0;
	a(cont)=0;
	while length(f_iter) >= (cont+2^i*k)
		a(cont)=a(cont)+abs(f_iter(cont+2^i*k));
		k=k+1;
	end
end 
maximo=max(a);
alfa=1/i*log2(maximo);

% Holder regularity order
r=N-1-alfa;
