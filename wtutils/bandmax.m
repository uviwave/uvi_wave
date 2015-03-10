function ou=bandmax(sg,sc,nmax,len)

%BANDMAX   gets the most significant values of a wavelet transform.
% 
%          BANDMAX (WX, SC, NMAX) gets a copy of the SC-scales 
%          wavelet transform vector WX but sets to 0 all the
%          coefficients except the NMAX maximum absolute values 
%          from each wavelet subband. The result is a vector 
%          with NMAX*(SC+1) non-zero values, matching the NMAX
%          maximum values of the WX's subbands.
%
%	   BANDMAX(WX,SC,NMAX,L) can be also used, providing
%	   the length L of the original signal. This must be used
%	   if it is not a power of two. By default, it is set the
%          largest as possible.
%
%          See also: ELMIN, LOCALMAX, BANDSITE, BANDEXT

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
%  Modified by: Santiago Gonzalez Sanchez
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------

[ly,lx]=size(sg);
sizx=maxrsize(size(sg,2),sc);
sizy=maxrsize(size(sg,1),sc);

if nargin==4
	sizx=min([len sizx]);
	sizy=min([len sizy]);
end

if (ly==1 | lx==1)		% ONE DIMENSION
	l=length(sg);
	sg=sg(:)';
	ou=zeros(1,l);
	ax=abs(sg);
	for s=1:sc
		for i=1:nmax
			[x,y,xx,yy]=bandsite(sizx,sizy,sc,s,1);
			[m,d]=max(ax(x:xx));
			ou(d+x-1)=sg(d+x-1);	
			ax(d+x-1)=0;
		end
	end
	for i=1:nmax
		[x,y,xx,yy]=bandsite(sizx,sizy,sc,sc,0);
		[m,d]=max(ax(x:xx));
		ou(d+x-1)=sg(d+x-1);	
		ax(d+x-1)=0;
	end
else				% TWO DIMENSIONS
	ou=zeros(ly,lx);
	ax=abs(sg);
	for s=1:sc
		[x,y,xx,yy]=bandsite(sizx,sizy,sc,s,1);
		for i=1:nmax
			[m,py]=max(ax(y:yy,x:xx));
			[m,px]=max(m);
			py=py(px);
			ou(py+y-1,px+x-1)=sg(py+y-1,px+x-1);	
			ax(py+y-1,px+x-1)=0;
		end
		[x,y,xx,yy]=bandsite(sizx,sizy,sc,s,2);
		for i=1:nmax
			[m,py]=max(ax(y:yy,x:xx));
			[m,px]=max(m);
			py=py(px);
			ou(py+y-1,px+x-1)=sg(py+y-1,px+x-1);	
			ax(py+y-1,px+x-1)=0;
		end			
		[x,y,xx,yy]=bandsite(sizx,sizy,sc,s,3);
		for i=1:nmax
			[m,py]=max(ax(y:yy,x:xx));
			[m,px]=max(m);
			py=py(px);
			ou(py+y-1,px+x-1)=sg(py+y-1,px+x-1);	
			ax(py+y-1,px+x-1)=0;
		end
	end
	[x,y,xx,yy]=bandsite(sizx,sizy,sc,sc,0);
	for i=1:nmax
		[m,py]=max(ax(y:yy,x:xx));
		[m,px]=max(m);
		py=py(px);
		ou(py+y-1,px+x-1)=sg(py+y-1,px+x-1);	
		ax(py+y-1,px+x-1)=0;
	end
end
