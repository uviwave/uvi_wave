function [y,d]=nss2d(x,h,g,sc,op)

%NSS2D    Analysis stage of a two dimensional nonsubsampled 
%         FIR filter bank. 
%
%         [Y,D] = NSS2D(X,H,G,SC,OP) performs the analysis stage of a 
%         2D nonsubsampled FIR filter bank with SC stages. 
%         The analysis is performed over the data in matrix X. 
%	  H and G represent the prototype lowpass and highpass filters 
%         respectively.
%         Y matrix holds the results of the last stage. D is vector
%	  containing the SC+1 analysis delays of the equivalent filters,
%	  necessary for performing the inverse stage.
%
%         [Y,D] = NSS2D(X,H,SC) performs the analysis over X, holding the 
%         Y matrix the output of the last lowpass branch.
%
%	  If 5 parameters are given, then Y holds the output of the low or 
%         high-pass branch, where OP parameter means the following:
%
%	  	0 : Lowpass analysis (same as 3 parameters)
%		1 : Vert. low  / Horz. high
%		2 : Vert. high / Horz. high
%		3 : Vert. high / Horz. low
%
%         See also: INSS2D, NSSFFB, SHOW


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


	% ARRANGE INPUT ARGUMENTS FOR 3 OR 5 ITEMS
if nargin==3
	sc=g;
	g=h;
	op=0;
end


if sc==0	% TRIVIAL CASE. ZERO SCALE GIVES THE SAME MATRIX
	y=x;
	return
end

	% MAKE ROW FILTERS
h=h(:)';
g=g(:)';

	% SELECT THE FILTERS ACCORDING TO THE OPTIONS
if op==0
	Hf=h;	% BOTH DIRECTIONS ARE LOWPASS 
	Vf=h;
end
if op==1
	Hf=g;	% BANDPASS FOR HORIZONTAL FILTERING
	Vf=h;	% AND LOWPASS FOR VERTICAL
end
if op==2
	Hf=g;	% BOTH DIRECTIONS ARE BANDPASS 
	Vf=g;
end
if op==3
	Hf=h;	% LOWPASS FOR HORIZONTAL FILTERING
	Vf=g;	% AND BANDPASS FOR VERTICAL
end

lH=length(Hf);
lV=length(Vf);
[ly,lx]=size(x);
hh=h;
lh=length(h);

	% GET THE SC-1 ITERATED SCALE FUNCTION
if sc>2
	for i=2:sc-1
		fh=[h;zeros(2^(i-1)-1,lh)];
		fh=fh(1:lh+(2^(i-1)-1)*(lh-1));
		hh=conv(hh,fh);			
	end
end

	% GET THE SC ITERATED WAVELET AND/OR SCALE FUNCTIONS
	% FOR HORIZONTAL AND VERTICAL PROCESSING, STARTING 
	% FROM THE PREVIOUSLY CALCULATED SC-1 ITERATED SCALE
	% FUNCTION
if sc>1	
	filt1=[Hf;zeros(2^(sc-1)-1,lH)];
	filt1=filt1(1:lH+(2^(sc-1)-1)*(lH-1));
	Hf=conv(hh,filt1);
	lH=length(Hf);

	filt2=[Vf;zeros(2^(sc-1)-1,lV)];
	filt2=filt2(1:lV+(2^(sc-1)-1)*(lV-1));
	Vf=conv(hh,filt2);
	lV=length(Vf);
end	

	% FILTER THE MATRIX IN BOTH DIRECTIONS, CUT THE RESULT
	% TO THE ORIGINAL SIZE AND TAKE THE DELAYS TO PERFORM
	% A CORRECT ALIGNMENT.

	% HORIZONTAL...
d(1)=wtcenter(Hf);
L=lH;
for ny=1:ly
	t=x(ny,:);
	lt=lx;
	while (L>lt)		% L CAN BE GREATER THAN THE
		t=[t,x(ny,:)];	% SIGNAL, SO IT COULD BE NECESSARY
		lt=lt+lx;	% TO CYCLE IT
	end
	t=[t(lt-L+1:lt),x(ny,:),t(1:L)];            % ATTACH THE WRAPPAROUND

	t=conv(Hf,t);
	y(ny,:)=t(L+d(1)+1:L+d(1)+lx);	
end

	% ... AND VERTICAL PROCESS.
d(2)=wtcenter(Vf);
L=lV;
for nx=1:lx
	t=y(:,nx);
	lt=ly;
	while (L>lt)			% L CAN BE GREATER THAN THE
		t=[t ; y(:,nx)];	% SIGNAL, SO IT COULD BE NECESSARY
		lt=lt+ly;		% TO CYCLE IT
	end
	t=[t(lt-L+1:lt) ; y(:,nx) ; t(1:L)];		% ATTACH THE WRAPPAROUND

	t=conv(Vf,t);
	y(:,nx)=t(L+d(2)+1:L+d(2)+lx);	
end
