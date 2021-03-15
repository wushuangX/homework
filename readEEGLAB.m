headmodel = ft_read_headmodel('standard_bem.mat');
elec = ft_read_sens('standard_1020.elc');
mri = ft_read_mri('Subject01.mri');

% create a concentric 3-sphere volume conductor, the radius is the same as for the electrodes
vol = [];
vol.r = [0.88 0.92 1.00]; % radii of spheres
vol.cond = [1 1/80 1];       % conductivity
vol.o = [0 0 0];          % center of sphere

cfg = [];
cfg.datafile = '14_clean.set';
data = ft_preprocessing(cfg);
cfg = [];
cfg.keeptrials = 'yes';
timelock = ft_timelockanalysis(cfg, data);

cfg = [];
cfg.headmodel = vol;
% cfg.elec = elec;
sourcemodel = 
(cfg, timelock);