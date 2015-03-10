function startup()

% STARTUP.M  -  Startup file for Wavelet Toolbox.
%
%       Please, update the directories if necessary.
% 
%       Edit this file for more help.
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
%     Authors: Sergio J. Garcia Galan 
%              Nuria Gonzalez Prelcic
% Modified by: Santiago Gonzalez Sanchez
%      e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------



% --------------------------------------------------------
%
% <<<<<< ABOUT THE WAVELET TOOLBOX'S DIRECTORIES >>>>>>
%
% The main Wavelet Toolbox path is set to '.'  so if you 
% start matlab whithin this directory and the toolbox
% structure is not changed, everything should run fine.
%
% If you're running matlab from any other directory, you
% should have a copy of this 'startup.m' file into your
% starting directory, edit it and change the WAVELET_PATH
% variable to the Wavelet Toolbox's home directory.
%
% The supplied Wavelet Toolbox's directory structure is:
%
%	WAVELET_HOME_PATH           ->	(root directory) 
%                  |____ WVT	    ->	(wavelet transform)
%                  |____ WPACKETS   ->  (wavelet packets)
%		   |____ WFILTER    ->	(filter generation)
%                  |____ SCAL       ->  (scalogram)
%		   |____ WTUTILS    ->	(wavelet utilities)
%		   |____ WPUTILS    ->	(wavelet packet utilities)
%		   |____ WDEMO	    ->	(demo files)
%
% NOTE: If you already have your own startup.m file, you 
% may append it to this one, or simply rename this, for 
% example to WAVSTART.M and execute it when you want the 
% toolbox to become accessable.
%


% --------------------------------------------------------
% Check if toolbox is already installed so as to avoid 
% repeated paths.
% function startup() is declared at the top of the file
% in order to hide WAVELET_HOME_PATH as a global variable
% only. So WAVELET_HOME_PATH is clearable only with 
% CLEAR GLOBAL command.

global WAVELET_HOME_PATH

if size(WAVELET_HOME_PATH)~=[0,0]
	disp(' ')
	disp('The Wavelet toolbox paths are already installed.')
	answr=input('Do you want to add the new ones? (y/n) :','s');
	% Any string starting with a 'y' is considered to be 'YES'
	if (answr(1)~='y')
		disp('Leaving MATLABPATH unchanged')
		return
	end
end


% --------------------------------------------------------
% Copyright message ...
disp ('WAVELET TOOLBOX: (c) Copyright 1996, Universidad de Vigo (under GNU conditions)')



% --------------------------------------------------------
% Home directory for the Wavelet Toolbox.
% Change it if necessary, according to the location of
% the toolbox.
%
% For example, using Typical Matlab toolboxes' directories:
%  Unix:    WAVELET_HOME_PATH = '/usr/local/matlab/toolbox/Uvi_Wave-3.0';   
%  DOS :    WAVELET_HOME_PATH = 'C:\MATLAB\TOOLBOX\WAVELET';
%  VMS :    WAVELET_HOME_PATH = 'DISKS1:[MATLAB.WAVELET]';
%  Mac :    WAVELET_HOME_PATH = 'Matlab:Toolbox:Uvi_Wave-3.0';

% By default, it is the directory where 'startup.m' is located.

p=pwd;
WAVELET_HOME_PATH =p;


% --------------------------------------------------------
% Other directories. If the Toolbox's structure is hold
% as it's served, they shouldn't be changed.
%
% But remember to change the syntax according to the machine. 
% (Default settings are for Unix)

WVT_PATH       = [WAVELET_HOME_PATH,'/wvt'];      % Wavelet Transform
WPACKETS_PATH  = [WAVELET_HOME_PATH,'/wpackets']; % Wavelet Packets 
SCAL_PATH      = [WAVELET_HOME_PATH,'/scal'];     % Scalogram
WTUTILS_PATH   = [WAVELET_HOME_PATH,'/wtutils'];  % Wavelet Utilities
WPUTILS_PATH   = [WAVELET_HOME_PATH,'/wputils'];  % Wavelet Packet Utilities
WFILTER_PATH   = [WAVELET_HOME_PATH,'/wfilter'];  % Filter Generation
WDEMO_PATH     = [WAVELET_HOME_PATH,'/wdemo'];	  % Demo section



% --------------------------------------------------------
% Append new paths:


   path (path,WAVELET_HOME_PATH)
   path (path,WVT_PATH)
   path (path,WPACKETS_PATH)
   path (path,SCAL_PATH)
   path (path,WTUTILS_PATH)
   path (path,WPUTILS_PATH)
   path (path,WFILTER_PATH)
   path (path,WDEMO_PATH)

% --------------------------------------------------------
% Now set the default alignment method for transforms.
% See help on WTMETHOD for allowed values on WTCENTERMETHOD.
% This value can be changed within any matlab session.
% Set here the one you want by default.

global WTCENTERMETHOD
if size(WTCENTERMETHOD)==[0,0]

        WTCENTERMETHOD=0;	% Change here if needed.

end

% --------------------------------------------------------
% Finally we clear all the unuseful startup variables
% WAVELET_HOME_PATH and WTCENTERMETHOD are saved as global
% for later use.

clear WVT_PATH WPACKETS_PATH SCAL_PATH WTUTILS_PATH WPUTILS_PATH WFILTER_PATH WDEMO_PATH 
