function discplot(x,xstr,lstr,zstr)

% DISCPLOT  Discrete plot.
%
%	    DISCPLOT(X) makes a discrete plot of X
%	    the same way as PLOT(X,'.'), but creating 
%	    the vertical lines for each sample. 
%
%	    DISCPLOT(X,STRN), where STRN is a string, will
%	    susbsitute the '.' string for the given STRN 
%	    when making the plot. So it's possible to change 
%	    the .'s for x's or o's, or change the color
%	    of the symbols, just as with the PLOT command.
%
%	    DISCPLOT(X,STRN,LCOL), where LCOL is also a
%	    string, will change the color of the axis and
%	    sample lines to the given by LCOL.
%
%	    DISCPLOT(X,STRN,LCOL,ZCOL), where ZCOL is a
%	    string, will give the color in ZCOL to the
%	    horizontal axis, while keeping the LCOL on the
%	    sample lines.
%

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

if nargin<2
	xstr='.';
end
cla;
l=length(x);
for i=1:l,
	h=line([i,i],[0,x(i)]);
	if nargin>2 set(h,'Color',lstr); end;
end
h=line([1,l],[0,0]);
if nargin==3 set(h,'Color',lstr); end;
if nargin>3 set(h,'Color',zstr); end;
hold on;
plot(x,xstr);
hold off;
a=axis;
a(1)=1;
a(2)=length(x);
axis(a);
