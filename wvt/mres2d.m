function y=mres2d(x,h,rh,g,rg,sc,specif);

%  MRES2D    Performs two dimensional multiresolution analysis.
% 
%     	     Y = MRES2D (X,H,RH,G,RG,SC,SPECIF) obtains the detail
%	     or the low frequency approximation at scale SC of matrix 
%            X from a 2D multiresolution scheme. The analysis lowpass 
%            filter H, synthesis lowpass filter RH, analysis highpass 
%            filter G and synthesis highpass filter RG are used to
%            implement the scheme.
%
%            The SPECIF parameter selects one of the following outputs: 
%
%		0: Lowpass vertical and horizontal filtering. (APPROXIMATION)
%		1: Lowpass vertical and highpass horizontal filtering.
%		2: Highpass vertical and horizontal filtering. 
%		3: Highpass vertical and lowpass horizontal filtering. 
%		4: Sum of 1,2 and 3 outputs (COMPLETE DETAIL).
%
%
%	     See also: APROX, DETAIL, MULTIRES, WT, SHOW


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

t=x;
h=h(:)';
rh=rh(:)';
g=g(:)';
rg=rg(:)';


[loy,lox]=size(t);

lf=length(h)+length(rh);
dd=floor((lf)/2)-1;
d=dd;
if sc>1
	for i=2:sc
		d=d+dd*2^(i-1);
	end
end

y=zeros(loy,lox);;

init=specif;
if specif==4
	specif=3;
	init=1;
end;

for spec=init:specif
	tt=t;
	if spec==0,
		fh=h;
		fv=h;
		rfh=rh;
		rfv=rh;
	end
	if spec==1,
		fh=g;
		fv=h;
		rfh=rg;
		rfv=rh;
	end
	if spec==2,
		fh=g;
		fv=g;
		rfh=rg;
		rfv=rg;
	end
	if spec==3,
		fh=h;
		fv=g;
		rfh=rh;
		rfv=rg;
	end

	for i=1:sc,
		if i==sc
			f1=fh;
			f2=fv;
		else
			f1=h;
			f2=h;
		end
		tr=[];
		[ly,lx]=size(tt);
		for (j=1:ly)
			tm=conv(f1,tt(j,:));
			tr(j,:)=tm(1:2:length(tm));
		end
		tt=[];
		[ly,lx]=size(tr);
		for (j=1:lx)
			tm=conv(f2',tr(:,j));
			tt(:,j)=tm(1:2:length(tm));
		end
	end
	
	for i=1:sc,
		if i==1
			f1=rfh;
			f2=rfv;
		else
			f1=rh;
			f2=rh;
		end
		tr=[];
		[ly,lx]=size(tt);
		for (j=1:lx)
			tm=[tt(:,j),zeros(ly,1)]';
			tr(:,j)=conv(f2,tm(:));
		end
		tt=[];
		[ly,lx]=size(tr);
		for (j=1:ly)
			tm=[tr(j,:);zeros(1,lx)];
			tt(j,:)=conv(f1',tm(:)');
		end
	end
	
	
	y=y+tt(1+d:loy+d,1+d:lox+d);
end;
