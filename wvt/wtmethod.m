function [wmt]=wtmethod(m)

%  WTMETHOD  Change the alignment method for wavelet transform.
%
%            WTMETHOD(M) sets to M the method used for Wavelet 
%            transform output subband alignment.
%
%	     The allowed values for M are:
%               0 - Based on the absolute maxima location 
%                   of the filter coeficients.
%		1 - No alignment is performed.
%		2 - Based on the mass center of the filters.
%		3 - Based on the energy center of the filters.
%
%	     WTMETHOD with no input or output arguments displays 
%	     a string about the actually performed method.
%
%	     M=WTMETHOD returns in M the number of the 
%	     actually performed method (see above).
%
%            See also: WTCENTER, CENTER, WT

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
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------

global WTCENTERMETHOD

if size(WTCENTERMETHOD)==[0,0],
	WTCENTERMETHOD=0;
end

if nargin<1,
	if nargout<1,
		if WTCENTERMETHOD==0,
			disp('Subband alignment based on Absolute Maxima Location');
		end
		if WTCENTERMETHOD==1,
			disp('No subband alignment is performed (zero delay for analysis filters)');
		end
		if WTCENTERMETHOD==2,
			disp('Subband alignment based on the mass center of filterss');
		end
		if WTCENTERMETHOD==3,
			disp('Subband alignment based on the energy center of filters');
		end
	end
	if nargout>0,
		wmt=WTCENTERMETHOD;
	end;
	return;
end


if (m<=3 & m>=0),
	WTCENTERMETHOD=m;
else
	disp('Valid values are from 0 to 3');
	return;
end

if nargout>0,
	wmt=WTCENTERMETHOD;
end;
