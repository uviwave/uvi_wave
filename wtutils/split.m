function split(x1,opt);

%   SPLIT   Display the rows of a matrix in different plots.
%
%           SPLIT(X) displays the N rows of the matrix in X1
%           in N plots (N must not be greater than 10).
%
%	    SPLIT(X,OPT) selects a time domain plot (0) or
%           a frequency domain one (not 0).
%
%           It can be used to display the output of NSSFFB 
%           and MULTIRES.
%
%           See also: NSSFFB, MULTIRES, ISPLIT, DISCPLOT


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

[ly1,lx1]=size(x1);

if nargin==1
	opt=0;
end

if ly1<10
	for i=1:ly1,
		subplot(ly1,1,i);
		if opt==0,
			plot(x1(i,:));
		else
			t=abs(fft(x1(i,:)));
			plot(t(1:length(t)/2));
		end
	end
else
	subplot
	plot(1:length(x1),x1)
end        

	
