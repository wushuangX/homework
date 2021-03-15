% https://github.com/fieldtrip/fieldtrip/blob/release/ft_sourceparcellate.m
cfg            = [];
cfg.parameter  = 'pow';
interpolate    = ft_sourceinterpolate(cfg, source, mri_orig);

cfg = [];
parcellation = ft_read_atlas('ROI_MNI_V4.nii');
parcel = ft_sourceparcellate(cfg, interpolate, parcellation);

cfg = [];
cfg.method = 'amplcorr';
stat = ft_connectivithelyanalysis(cfg, parcel);

cfg = [];
cfg.method = 'ortho';
cfg.funparameter = 'pow';
% cfg.atlas = parcellation;
ft_sourceplot(cfg, source);