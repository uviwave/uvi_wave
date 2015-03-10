function f=iwpk2d(w,lp,hp,basis,sizx,sizy)

%IWPK2D    2-D Discrete Inverse Wavelet Packet Transform
%
%          IWPK2D(W,RH,RG,BASIS,SIZX,SIZY) calculates the Inverse Wavelet Packet
%  	   Transform of coefficients W, that should be obtained using BASIS.
%
%          The second argument RH is the synthesis lowpass filter and the third
%          argument RG, the synthesis highpass filter. SIZX and SIZY is the number
%	   of columns and rows, respectively, of the signal to rebuild.
%	   By default, they are set to the size of W.
%
%          Run the script 'BASIS' for help on the basis format.
%          See also: WPK2D, IWPK, PRUNE2D.

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

if nargin==4
	sizx=size(w,2);
	sizy=size(w,1);
end

if all(basis==0)                        % the coefficients belong to an ending node
	f=w;
	return
elseif all(basis==1)                    % coefficients of four nodes
	f=iwt2d(w,lp,hp,1,sizx,sizy);	% performs a synthesis stage
	return
else                                    % if coefficients do not belong to an ending node

	flag=rem(log2(sizx),1)|rem(log2(sizy),1);	% if it is 1, some size is not a power of 2
			% in order to obtain the band size, we need to go
	if flag		% through the subtree starting from the present node  
		[x1,y1,x2,y2,lox,loy,b]=siteaux(sizx,sizy,'a',basis);
		wa=iwpk2d(w(y1:y2,x1:x2),lp,hp,b-1,lox,loy);

		[x1,y1,x2,y2,lox,loy,b]=siteaux(sizx,sizy,'v',basis);
		wv=iwpk2d(w(y1:y2,x1:x2),lp,hp,b-1,lox,loy);		

		[x1,y1,x2,y2,lox,loy,b]=siteaux(sizx,sizy,'h',basis);
		wh=iwpk2d(w(y1:y2,x1:x2),lp,hp,b-1,lox,loy);

		[x1,y1,x2,y2,lox,loy,b]=siteaux(sizx,sizy,'d',basis);
		wd=iwpk2d(w(y1:y2,x1:x2),lp,hp,b-1,lox,loy);

	else			% powers of 2 case 
		lox=sizx/2;
		loy=sizy/2;
	
		tope=0.25;                              % finds the point where the
		suma=2^(-2*basis(1));                   % basis vector must be divided
		i=1;                                    % in order to call the recursion
		while (suma<tope)
			i=i+1;
			suma=suma+2^(-2*basis(i));
		end
		
		wa=iwpk2d(w(1:loy,1:lox),lp,hp,basis(1:i)-1,lox,loy);	% recursive call

		basis=basis(i+1:length(basis));
		suma=2^(-2*basis(1));
		i=1;
		while (suma<tope)
			i=i+1;
			suma=suma+2^(-2*basis(i));
		end
		wv=iwpk2d(w(loy+1:sizy,1:lox),lp,hp,basis(1:i)-1,lox,loy);

		basis=basis(i+1:length(basis));
		suma=2^(-2*basis(1));
		i=1;
		while (suma<tope)
			i=i+1;
			suma=suma+2^(-2*basis(i));
		end
		wh=iwpk2d(w(1:loy,lox+1:sizx),lp,hp,basis(1:i)-1,lox,loy);

		basis=basis(i+1:length(basis));
		wd=iwpk2d(w(loy+1:sizy,lox+1:sizx),lp,hp,basis-1,lox,loy);
	end

	f=iwt2d([[wa,wh];[wv,wd]],lp,hp,1,sizx,sizy);	% perform one synthesis stage
end
