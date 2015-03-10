function y=inssffb(x,rh,rg,da)

%INSSFFB    Synthesis stage of a nonsubsampled FIR filter bank.
%    
%	    Y=INSSFFB(X,RH,RG,DA) completes the process begun with NSSFFB,
%           by reconstructing from the coefficients in matrix X.
%           It is supposed to be a SC+1 rows matrix, with the bandpass
%           analysis signals from the first to the SC row, and the lowpass
%           analysis signal at the last row.
%           RH and RG are the prototype lowpass and highpass synthesis 
%           filters respectively. DA is a vector containing the filter
%	    delays for the analysis stage.
%
%           Y matrix holds the first SC detail signals and the 2^SC scale
%           approximation signal as rows. The original signal may be rebuild
%           by making sum(Y).
%
%           See also: NSSFFB, NSS2D, SPLIT

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


rh=rh(:)';		% Shape the filters as row vectors
rg=rg(:)';
lh=length(rh);
lg=length(rg);

[sc,lx]=size(x);	% Get the size of the original signal
sc=sc-1;		% and the number of scales

dd=floor((lh+lg)/2)-1;	% Calculation of the total delay
dt(1)=dd;		% of the analysis-synthesis process
if sc>1				
	for i=2:sc
		dt(i)=dt(i-1)+dd*2^(i-1);
	end
end
dt(sc+1)=dt(sc);
ds=dt-da;		   	   % The sum of analysis and synthesis
				   % delays must match the total one.

L=max([lg,ds(1)]);		   % Wrapparound calculation
t=x(1,:);
lt=lx;
while (L>lt)			   % L can be greater than the
	t=[t,x(1,:)];		   % signal, so it can be necessary
	lt=lt+lx;	  	   % to cycle it
end
t=[t(lt-L+1:lt),x(1,:),t(1:L)];    % Attach the wrapparound

t=conv(rg,t)/2;			   % Detail signal for 2^1 scale
y(1,:)=t(L+ds(1)+1:L+ds(1)+lx);    % Cut the signal to its final length

fh=rh;				   % Initialization for
fg=rg;				   % the equivalent filters

% Loop for more than one scale

if sc>1
	for i=2:sc
		fg=[fg;zeros(1,lg)];		% Interpolate with one zero the
		fg=fg(1:2*lg-1);		% previous bandpass equivalent filter.
		fg=conv(rh,fg);			% Bandpass equivalent filter
		lg=length(fg);			% at stage i.

		fh=[fh;zeros(1,lh)];		% Interpolate with one zero the
		fh=fh(1:2*lh-1);		% previous lowpass equivalent filter.
		fh=conv(rh,fh);			% Lowpass equivalent filter	
		lh=length(fh);			% at stage i.

		L=max([fg,ds(i)]);		% Wrapparound
		t=x(i,:);
		lt=lx;
		while (L>lt)
			t=[t,x(i,:)];
			lt=lt+lx;
		end
		t=[t(lt-L+1:lt),x(i,:),t(1:L)]; % Attach the wrapparound

		t=conv(fg,t)/(2^i);		% Detail signal, scale 2^i
		y(i,:)=t(L+ds(i)+1:L+ds(i)+lx); % Cut to lx samples
	end
end

L=max([lh,ds(sc+1)]);     		  % Wrapparound
t=x(sc+1,:);
lt=lx;
while (L>lt)
	t=[t,x(sc+1,:)];
	lt=lt+lx;
end
t=[t(lt-L+1:lt),x(sc+1,:),t(1:L)];   	  % Attach the wrapparound 

t=conv(fh,t)/(2^sc);			  % Approximation signal, scale 2^sc
y(sc+1,:)=t(L+ds(sc+1)+1:L+ds(sc+1)+lx);  % Cut it to its final length
