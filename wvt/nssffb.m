function [y,d]=nssffb(x,h,g,sc)

%NSSFFB    Analysis stage of a nonsubsampled FIR filter bank.
%
%          [Y,D] = NSSFFB(X,H,G,SC) performs the analysis stage of a 
%          nonsubsampled FIR filter bank with SC stages. 
%          The analysis is performed over the data in vector X. 
%          Y matrix holds the result vectors as rows.
%          H and G represent the prototype lowpass and highpass filters 
%          respectively. 
%
%          Y(i,:), i=1,...,SC, holds the output of a successive filtering 
%          by H(z), H(z^2), ..., G(z^(2^(i-1))).
%          Y(SC+1,:), holds the output of a successive filtering
%          by H(z), H(z^2), ..., H(z^(2^(SC-1))).
%
%	   D is a vector returning the analysis delays of these equivalent 
%          filters. They are calculated according to the current option
%          of the alignment method.
%
%          See also: INSSFFB, NSS2D, SPLIT

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
%               Santiago Gonzalez Sanchez
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------


if sc==0       % Trivial case
	y=x;
	return;
end

h=h(:)';		% Shape filters and signal as row vectors
g=g(:)';
x=x(:)';
lh=length(h);
lg=length(g);
lx=length(x);

d(1)=wtcenter(g);       % Delay and
L=lg;                   % wrapparound calculation
t=x;
lt=lx;
while (L>lt)		% L can be greater than the
	t=[t,x];	% signal, so it can be necessary
	lt=lt+lx;	% to cycle it
end
t=[t(lt-L+1:lt),x,t(1:L)];            % Attach the wrapparound

t=conv(g,t);                          % First bandpass analysis signal
y(1,:)=t(L+d(1)+1:L+d(1)+lx);         % Cut to lx samples

fh=h;                   % Initialization for
fg=g;			% the equivalent filters

if sc>1
	for i=2:sc
		fg=[fg;zeros(1,lg)];		% Interpolate with one zero the
		fg=fg(1:2*lg-1);		% previous bandpass equivalent filter.
		fg=conv(h,fg);          	% Bandpass equivalent filter
		lg=length(fg);			% at stage i.

		fh=[fh;zeros(1,lh)];		% Interpolate with one zero the
		fh=fh(1:2*lh-1);		% previous lowpass equivalent filter.
		fh=conv(h,fh);          	% Lowpass equivalent filter
		lh=length(fh);			% at stage i.

		d(i)=wtcenter(fg);              % Delay and wrapparound
		L=lg;
		t=x;
		lt=lx;
		while (L>lt)
			t=[t,x];
			lt=lt+lx;
		end
		t=[t(lt-L+1:lt),x,t(1:L)];      % Attach the wrapparound

		t=conv(fg,t);                   % Bandpass analysis, scale 2^i
		y(i,:)=t(L+d(i)+1:L+d(i)+lx);   % Cut to lx samples
	end
end

d(sc+1)=wtcenter(fh);           % Delay and wrapparound
L=lh;
t=x;
lt=lx;
while (L>lt)
	t=[t,x];
	lt=lt+lx;
end
t=[t(lt-L+1:lt),x,t(1:L)];      % Attach the wrapparound

t=conv(fh,t);                                   % Lowpass analysis, scale 2^sc
y(sc+1,:)=t(L+d(sc+1)+1:L+d(sc+1)+lx);          % Cut to lx samples
