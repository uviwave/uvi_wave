function [sc,t,s]=scalog(x,fs,smin,smax,sstep,timeunits,tim)

%SCALOG  Scalogram of a vector.
%
%        SC = SCALOG(X,FS,SMIN,SMAX,SSTEP) returns the scalogram of 
%        vector sampled at rate FS. It is computed for the equally spaced
%        scales generated between SMIN and SMAX with step SSTEP.
%
%        SC = SCALOG(X,FS,SMIN,SMAX,SSTEP,TIMEUNITS) returns the
%        scalogram of X, but changing the wavelet basis time units to
%        TIMEUNITS. The default value for TIMEUNITS will be set 
%        according to the input sampling rate.
%
%        SC = SCALOG(X,FS,SMIN,SMAX,SSTEP,TIMEUNITS,TIM) returns the
%        scalogram of X setting the wavelet basis interval time to
%        (-TIM to TIM) TIMEUNITS. The default interval is [-6,6]
%        TIMEUNITS. 
%
%        [SC,T,S] = SCALOG( ... ) also returns the time (T) and
%        scale (S) axis. The scale axis is given in the form
%        SMIN:SSTEP:SMAX, while the time axis is from 0 to 
%        the duration of X in TIMEUNITS.
%
%        The ABS value of the scalogram can be displayed into
%        a shaded 2D or 3D surface view.
%
%        See also: MORLETW, SHOW, SRF, SURFL, SURF.
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
%       Author: Nuria Gonzalez Prelcic
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------


% Some initializations...

x=x(:)';
lx=length(x);
sc=[];

% --------------------------------------------------------------------
% SET THE DEFAULT WAVELET TIME UNITS.
% The time units will be selected (if not given) according to the
% magnitude of the sampling rate. This is, for kHz ranges a time
% unit of milliseconds will be used, for Hz ranges, seconds, and so on. 


timetable=[2592000,86400,3600,60, 1, 1e-3, 1e-6, 1e-9 ];
timename=['months      ';'days        ';'hours       ';'minutes     ';'seconds     ';'milliseconds';'microseconds';'nanoseconds '];

timestr=[];
if nargin < 6
	timeunits=0;
end
if timeunits ==0
	lf=log10(fs);
	ndx=floor((lf+16)/3);
	if ndx<1
		ndx=1;
	end
	if ndx>8
		ndx=8;
	end
	timeunits=timetable(ndx);
	timestr=timename(ndx,:);
end


if length(timestr)<1
	timestr='t.u.';
end

% --------------------------------------------------------------------
% PARAMETERS FOR THE MORLET WAVELET CALCULATION.
% Default wavelet timing is from -6 to 6 time units :

if nargin<7
	tim=6;
end

if tim<=0
	fprintf('ERROR: Time interval cannot be zero or negative.\n');
	return
end

% --------------------------------------------------------------------
% SET OUTPUT VECTORS

s=smin:sstep:smax;
f=s*fs/2;
t=(1:length(x))/(fs*timeunits);

% --------------------------------------------------------------------
% VERBOSE OUTPUTS
fprintf('\nTime units for Morlet wavelet: %f seconds (%s)\n',timeunits,timestr);
fprintf('Time interval for Morlet prototype wavelet: (-%f,%f) %s.\n',tim,tim,timestr);
fprintf('Signal duration: %f %s\n',t(length(x)),timestr);

% --------------------------------------------------------------------
% DO MAKE SCALOGRAM!
for scp=smin:sstep:smax
	[w,tw]=morletw(fs,scp,0,tim,timeunits); 
	lw=length(w);

	 % The Morlet wavelet should be sampled at least at a 2 Hz rate with
	 % seconds as time unit, or 2 kHz rate while using milliseconds... If
	 % the scale is too low, the wavelet may result too much compressed
	 % and wavelet properties are lost due to undersampling.
	 % If this happens, the user should increase the lowest scale or 
	 % change the time units to a greater value.

	if lw<4*tim+1  % slowest allowed sampling rate
		fprintf('\nWARNING: Scale (%f) may be too low. Increase smin or time units.\n',scp);
	end

	 % If the scale is too high, the wavelet may result excesively dilated,
	 % and filtering operations may be too slow. This does not affect to
	 % the wavelet properties, but to the users patience...
	 % If this happens, decrease the highest scale or choose smaller 
	 % time units.
	 % Note that the higher is the scale, the larger is the wavelet.

	if lw>25000
		fprintf('\nWARNING: Scale (%f) may be too high. May take a long time ...\n',scp);
	end

	del=floor((lw-1)/2);
	w1=conv(w,x);
	y1=w1(del+1:del+lx);
	sc=[sc;y1];
end
