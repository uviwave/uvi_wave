function  alfa=regdaub(L)

%REGDAUB     Estimates a regularity index for Daubechies' filters.
%
%	     ALPHA = REGDAUB (L) obtains a sharper regularity estimate for
%	     the wavelet and scale functions of orthonormal Daubechies' 
%	     filters, with L coefficients.
%		
%	     The method is based on a generalization of a technique 
%	     used by Riesz. It works very well for small values of L, but
%	     does not give good asymptotic results.
%
%	     See also: DAUB, TRIGPOL, DIEZMO, TEMPREG, SPECREG
%
%	     References: I. Daubechies, "Orthonormal Bases of Compactly
%			 Supported Wavelets", Commun. on Pure and Appl.
%			 Math., November 1988

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

if rem(L,2)
   error( 'Error: L must be even!!!')
end

if L==2
	alfa=0;
	return
end

N=L/2;

a=trigpol(N);           % Calculate trigonometric polynomial.

dN=2*N-3;               % dN size of matrix T.

aux=diezmo(a(2:length(a)-1),2);
a_par=[aux zeros(1,dN-length(aux))];
aux=diezmo(a,2);
a_impar=[aux zeros(1,dN-length(aux))];

for cont=1:2:dN-1			% obtain T matrix.
	T(cont,1:dN)=a_par;
	T(cont+1,1:dN)=a_impar;
	a_par=[0 a_par(1:length(a_par)-1)];
	a_impar=[0 a_impar(1:length(a_par)-1)];
	end
end

T(dN,1:dN)=a_par;

radio_esp=max(abs(eig(T)));             % compute spectral radius.

alfa=N-1-0.5*log2(radio_esp);           % regularity estimation.






