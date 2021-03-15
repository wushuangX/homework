% load MRI, reslice it and interpolate the low-res functional data onto the high-res anatomy
mri = ft_read_mri('Subject01.mri');


cfg = [];
mri = ft_volumereslice(cfg, mri);

cfg            = [];
cfg.downsample = 2;
cfg.parameter  = 'pow';
sourceDiffInt  = ft_sourceinterpolate(cfg, source , mri);

% spatially normalize the anatomy and functional data to MNI coordinates
cfg = [];
cfg.nonlinear = 'no';
sourceDiffIntNorm = ft_volumenormalise(cfg, sourceDiffInt);


cfg = [];
cfg.method        = 'ortho';
cfg.funparameter  = 'pow';
cfg.maskparameter = cfg.funparameter;
cfg.atlas = aal;
cfg.roi = aal.tissuelabel;
% cfg.funcolorlim   = [0.0 1.2];
% cfg.opacitylim    = [0.0 1.2];
% cfg.opacitymap    = 'rampup';
ft_sourceplot(cfg, sourceDiffInt);