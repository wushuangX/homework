aal = ft_read_atlas('ROI_MNI_V4.nii');
cfg = [];
cfg.atlas = aal;
cfg.roi = aal.tissuelabel;
% % cfg.maskparameter = 
% mask = ft_volumelookup(cfg, source);
cfg = [];
cfg.parameter = 'pow';
cfg.method = 'analytic';
cfg.design = 0;
% cfg.atlas = aal;
% cfg.roi = aal.tissuelabel;
stat = ft_sourcestatistics(cfg, source);