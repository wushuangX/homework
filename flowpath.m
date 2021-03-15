% 读取EEG
cfg = [];
cfg.datafile = '14_clean.set';
data = ft_preprocessing(cfg);
cfg = [];
timelock = ft_timelockanalysis(cfg, data);

cfg = [];
cfg.headmodel = vol;
% cfg.elec = elec;
sourcemodel = ft_prepare_leadfield(cfg, timelock);