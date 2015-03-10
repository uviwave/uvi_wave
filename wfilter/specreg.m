function alfa=specreg(H,N)

%SPECREG    Estimates regularity order by a brute force method. 
% 	
%	    ALPHA = SPECREG (H,N) gives an estimation of regularity order
%	    of filter H which has N zeros at z = -1. ALPHA=n+t where n is 
%	    the number of times that H is continously differentiable and the
%	    n-th derivate is Holder continous with exponent t.
%	    This is a brute force method based on Fourier Transform.
%
%	    See also: TEMPREG, REGDAUB
%
%	    References: I. Daubechies, "Ten Lectures on Wavelets",
%			page 216, SIAM, 1992 

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


%% Calculate m0(z) polynomial,  m0(1)=1
m0=1/sum(H)*H;

%% Remove N zeros at z = -1
for cont=1:N
	R=deconv(m0,[1/2 1/2]);
	m0=R;
end;

% Fourier Transfor of R(z): R(e^jw)
Rw=fft(R,length(R)*64);

maximo=max(abs(Rw));

alfa=N-log2(maximo)-1;

