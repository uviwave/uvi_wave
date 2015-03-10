function [h,g,rh,rg]=wspline(m,n)

% WSPLINE  Generates spline wavelets.
%
%          [H,G,RH,RG]=WSPLINE(M,N) returns the analysis and
%          synthesis filters corresponding to a biortoghonal 
%          scheme with spline wavelets of compact support. 
%          H is the analysis lowpass filter, RH the synthesis 
%          lowpass filter, G the analysis highpass filter and
%          RG the synthesis highpass filter.
%          N and M specify the number of zeros in z=-1 required 
%          for H(z) and RH(z) respectively.
% 
%          N+M must be even. 
%
%          With these examples is possible to achieve arbitrarily 
%          high regularity. For large M, the analysis wavelet
%          will belong to C^k if N>4.165M+5.165(k+1).
%   
%          See also: BINEWTON, TRIGPOL, CALHPF.

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
%       Author: Nuria Gonzalez Prelcic
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------

while rem(m+n,2)~=0,  
      disp('M+N must be even');
      m=input('M: ');
      n=input('N: ');
end


% Calculate rh coefficients, RH(z)=sqrt(2)*((1+z^-1)/2)^m;

rh=sqrt(2)*(1/2)^m*binewton(m);

% Calculate h coefficients, H(-z)=sqrt(2)*((1+z^-1)/2)^n*P(z)

% First calculate P(z) (pol)

if (rem(n,2)==0)
   N=n/2+m/2;
else
   N=(n+m-2)/2+1;
end

pol=trigpol(N);

% Now calculate ((1+z*-1)/2)^n;

r0=(1/2)^n*binewton(n);


hrev=sqrt(2)*conv(r0,pol);

l=length(hrev);
h=hrev(l:-1:1);


[g,rg]=calhpf(h,rh);


   
