function y=multires(x,h,rh,g,rg,sc);

%  MULTIRES  Performs multiresolution analysis.
% 
%     	     Y = MULTIRES (X,H,RH,G,RG,SC) obtains the SC successive details
%	     and the low frequency approximation of signal in X from a 
%            multiresolution scheme. The analysis lowpass filter H, synthesis
%            lowpass filter RH, analysis highpass filter G and synthesis
%            highpass filter RG are used to implement the scheme.
%
%            Results are given in a SC+1 rows matrix. 
%	     The first SC rows are the details corresponding to the scales 
%	     2^1 to 2^SC; the last row contains the approximation at scale 2^SC.
%
% 	     The original signal can be restored by summing all the rows
%	     of the resulting matrix ( X=sum(Y) ).
%
%	     See also: APROX, DETAIL, MRES2D, WT, SPLIT.


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


t=x(:)';
h=h(:)';
rh=rh(:)';
g=g(:)';
rg=rg(:)';

lx=length(t);
lf=length(h)+length(rh);
d(1)=floor((lf)/2)-1;

if sc>1
	for i=2:sc
		d(i)=d(i-1)+d(1)*2^(i-1);
	end
end

lt=lx;

y=zeros(sc+1,lx);

tt=t;

for i=1:sc,
        tg=conv(g,tt);
        tg=tg(1:2:length(tg));
        tt=conv(h,tt);
        tt=tt(1:2:length(tt));
        for j=i:-1:1
                if j==i
                        tm=[tg;zeros(1,length(tg))];
                        tm=tm(:)';
                        tm=conv(rg,tm);
                else
                        tm=[tm;zeros(1,length(tm))];
                        tm=tm(:)';
                        tm=conv(rh,tm);
                end
        end
        y(i,:)=tm(1+d(i):lx+d(i));              
end

for j=1:sc
        tt=[tt;zeros(1,length(tt))];
        tt=tt(:)';
        tt=conv(rh,tt);
end

y(sc+1,:)=tt(1+d(sc):lx+d(sc));

