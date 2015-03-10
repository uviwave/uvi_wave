function y=inss2d(x,rh,rg,sc,op,da)

%INSS2D     Synthesis stage of a two dimensional nonsubsampled 
%           FIR filter bank. 
%
%           Y = INSS2D(X,RH,RG,SC,OP,DA) reconstructs from the coefficients
%	    in matrix X, performing the synthesis of a 2D non-subsampled
%           FIR filter bank with SC stages. RH and RG are the prototype
%	    lowpass and highpass filters respectively. DA is a vector with
%           the analysis stage filter delays, as returned by NSS2D.
%
%           Y = INSS2D(X,RH,SC,DA) performs the analysis over X, holding the 
%           Y matrix the output of the last lowpass branch.
%
%	    If 6 parameters are given, then Y holds the output of the low or 
%           highpass branch, where OP parameter means:
%
%		0 : Lowpass analysis (same as 4 parameters)
%		1 : Vert. low  / Horz. high
%		2 : Vert. high / Horz. high
%		3 : Vert. high / Horz. low
%
%           See also: NSS2D, INSSFFB, SHOW


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


	% ARRANGE INPUT ARGUMENTS FOR 3 OR 5 ITEMS
if nargin==3
	da=sc;
	sc=rg;
	rg=rh;
	op=0;
end


if sc==0	% TRIVIAL CASE. ZERO SCALE GIVES THE SAME MATRIX
	y=x;
	return
end

	% MAKE ROW FILTERS
rh=rh(:)';
rg=rg(:)';

	% SELECT THE FILTERS ACCORDING TO THE OPTIONS
if op==0
	Hf=rh;	% BOTH DIRECTIONS ARE LOWPASS 
	Vf=rh;
     end
if op==1
	Hf=rg;	% BANDPASS FOR HORIZONTAL FILTERING
	Vf=rh;	% AND LOWPASS FOR VERTICAL
end
if op==2
	Hf=rg;	% BOTH DIRECTIONS ARE BANDPASS 
	Vf=rg;
end
if op==3
	Hf=rh;	% LOWPASS FOR HORIZONTAL FILTERING
	Vf=rg;	% AND BANDPASS FOR VERTICAL
end

lH=length(Hf);
lV=length(Vf);
[ly,lx]=size(x);
hh=rh;

	% GET THE SC-1 ITERATED SCALE FUNCTION
lh=length(rh);
if sc>2
	for i=2:sc-1
		fh=[rh;zeros(2^(i-1)-1,lh)];
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

dd=floor((lh+length(rg))/2)-1;		% CALCULATION OF THE TOTAL DELAY
dt=dd;   	        		% OF THE ANALYSIS-SYNTHESIS PROCESS
if sc>1				
	for i=2:sc
		dt=dt+dd*2^(i-1);
	end
end
ds=dt-da;			% THE SUM OF ANALYSIS AND SYNTHESIS
			        % DELAYS MUST MATCH THE TOTAL ONE

	% FILTER THE MATRIX IN BOTH DIRECTIONS, CUT THE RESULT
	% TO THE ORIGINAL SIZE AND TAKE THE DELAYS TO PERFORM
	% A CORRECT ALIGNMENT.
		
	% HORIZONTAL... 
L=lH;
for ny=1:ly
	t=x(ny,:);
	lt=lx;
	while (L>lt)		% L CAN BE GREATER THAN THE
		t=[t,x(ny,:)];	% SIGNAL, SO IT COULD BE NECESSARY
		lt=lt+lx;	% TO CYCLE IT
	end
	t=[t(lt-L+1:lt),x(ny,:),t(1:L)];            % ATTACH THE WRAPPAROUND

	t=conv(Hf,t)/(2^sc);
	y(ny,:)=t(L+ds(1)+1:L+ds(1)+lx);	
end

	% ... AND VERTICAL PROCESS.
L=lV;
for nx=1:lx
	t=y(:,nx);
	lt=ly;
	while (L>lt)			% L CAN BE GREATER THAN THE
		t=[t ; y(:,nx)];	% SIGNAL, SO IT COULD BE NECESSARY
		lt=lt+ly;		% TO CYCLE IT
	end
	t=[t(lt-L+1:lt) ; y(:,nx) ; t(1:L)];            % ATTACH THE WRAPPAROUND

	t=conv(Vf,t)/(2^sc);
	y(:,nx)=t(L+ds(2)+1:L+ds(2)+lx);	
end
