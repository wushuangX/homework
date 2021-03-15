%%
cfg.method = 'mne';
% cfg.method = 'music';
% cfg.method = 'sloreta';
% cfg.method = 'eloreta';
% cfg.frequency = 256;
cfg.mne.lambda = 0.05;
cfg.headmodel = vol;
% cfg.sourcemodel = sourcemodel;
source = ft_sourceanalysis(cfg, data);


cfg = [];
cfg.parameter = 'inside';
interp_mean = ft_sourceinterpolate(cfg, source, mri);

cfg = [];
cfg.method = 'ortho';
% cfg.parameter = {'inside', 'mom'};
cfg.funparameter  = 'pow';
cfg.maskparameter = cfg.funparameter;
cfg.funcolorlim   = [0.0 1.2];
cfg.opacitylim    = [0.0 1.2];
cfg.opacitymap    = 'rampup';
ft_sourceplot(cfg, interp_mean);