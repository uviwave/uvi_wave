function  [h,g,rh,rg]=remezflt(L,K,B)

%REMEZFLT     Generates orthonormal wavelet filters based on the Remez
%	      exchange algorithm.
%
%	      [H,G,RH,RG] = REMEZFLT(L,K,B) returns a set of wavelet
%	      filters. You can control regularity, frequency selectivity,
%	      and length of the filters. It works performing a factorization
%	      based on the complex cepstrum of the polynomial returned by
%	      REMEZWAV.
%
%	      L is the length of the filters. K is degree of flatness at
%	      z=-1. B is the normalized transition bandwidth.
%
%	      See also: REMEZWAV, FC_CCEPS.
%
%	      References: O. Rioul and P. Duhamel, "A Remez Exchange Algorithm
%			  for Orthonormal Wavelets", IEEE Trans. Circuits and
%			  Systems - II: Analog and Digital Signal Processing,
%			  41(8), August 1994	

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
%       Author: Santiago Gonzalez Sanchez
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------


poly=remezwav(L,K,B);
rh=fc_cceps(poly);
[h,g,rh,rg]=rh2rg(rh); 
