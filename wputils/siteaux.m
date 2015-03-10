function [x1,y1,x2,y2,lox,loy,bas_out]=siteaux(sizx,sizy,q,basis)

%SITEAUX    Auxiliary function for IWPK2D
%
%	    [X1,Y1,X2,Y2,LOX,LOY,BAS_OUT] = SITEAUX(SIZX,SIZY,IDX,BASIS)
%	    It is called when some of the signal dimensions SIZX, SIZY is
%	    not a power of 2, but also works if so.
%
%	    SIZX,SIZY give the columns and rows of the band we are starting
%	    from, including blank lines. IDX is a string:
%		'a':	lowpass,
%		'v':	vertical high frequency,
%		'h':	horizontal high frequency,
%		'd':	diagonal high frequency,
%	    which choses one of the 'descendent' subbands. BASIS indicates
%	    the tree descending from the present band.
%    
%	    X1,Y1,X2,Y2 are the coordinates of the chosen band, without
%	    blank lines. LOX,LOY is the size of the next bands descending
%	    from the present one, including blank lines. BAS_OUT is the part
%	    of BASIS vector corresponding to the chosen band.
%
%	    See also: SITEBAND, IWPK2D.

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


lox=floor((sizx+1)/2);
loy=floor((sizy+1)/2);

if isstr(q)		% initial recursive level 
	nivel=0;
	basis=2*basis;
else
	nivel=q;	% there was a recursive call
end

basis=basis-2;

if basis==0				% equivalent to all(basis==0)
	if ~nivel
		x2=lox+lox*((q=='h')|(q=='d'));
		y2=loy+loy*((q=='v')|(q=='d'));
		x1=x2-lox+1;
		y1=y2-loy+1;
	else
		x1=2*lox;
		y1=2*loy;
	end
	return
end

% Approximation

tope=1;
suma=2^(-basis(1));
i=1;
while (suma<tope)
	i=i+1;
	suma=suma+2^(-basis(i));
end
if (~nivel)&(q=='a')
	bas_out=basis(1:i);
end

if all(basis(1:i)~=0)
	[x1a,y1a]=siteaux(lox,loy,nivel+1,basis(1:i));
else
	x1a=lox;
	y1a=loy;
end
		
% Vertical

basis=basis(i+1:length(basis));
suma=2^(-basis(1));
i=1;
while (suma<tope)
	i=i+1;
	suma=suma+2^(-basis(i));
end
if (~nivel)&(q=='v')
	bas_out=basis(1:i);
end

if all(basis(1:i)~=0)
	[x1v,y1v]=siteaux(lox,loy,nivel+1,basis(1:i));
else
	x1v=lox;
	y1v=loy;
end
	
% Horizontal

basis=basis(i+1:length(basis));
suma=2^(-basis(1));
i=1;
while (suma<tope)
	i=i+1;
	suma=suma+2^(-basis(i));
end
if (~nivel)&(q=='h')
	bas_out=basis(1:i);
end
	
if all(basis(1:i)~=0)
	[x1h,y1h]=siteaux(lox,loy,nivel+1,basis(1:i));
else
	x1h=lox;
	y1h=loy;
end

% Diagonal

basis=basis(i+1:length(basis));
if (~nivel)&(q=='d')
	bas_out=basis;
end

if all(basis~=0)
	[x1d,y1d]=siteaux(lox,loy,nivel+1,basis);
else
	x1d=lox;
	y1d=loy;
end
	
% Size arrangements

if nivel
	x1=max([x1a x1v])+max([x1h x1d]);
	y1=max([y1a y1h])+max([y1v y1d]);
else
	c1=x1a-x1v;
	c2=x1h-x1d;
	f1=y1a-y1h;
	f2=y1v-y1d;

	if q=='a'
		x2=x1a-c1*(c1<0);
		y2=y1a-f1*(f1<0);
	else				% if the lowpass subband "gets fat", it has an effect on the other
		x1a=x1a-c1*(c1<0); 
		y1a=y1a-f1*(f1<0);
		if q=='v'
			x2=x1v+c1*(c1>0);
			y2=y1v-f2*(f2<0)+y1a;
		elseif q=='h'
			x2=x1h-c2*(c2<0)+x1a;
			y2=y1h+f1*(f1>0);
		else
			x2=x1d+c2*(c2>0)+x1a;
			y2=y1d+f2*(f2>0)+y1a;
		end
	end

	eval(['x1=x2-x1' q '+1;'])		% fix the top-left extreme
	eval(['y1=y2-y1' q '+1;'])
	bas_out=(bas_out+2)/2;			% adjust bas_out to the normal format 
end
