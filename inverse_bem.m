cfg                     = [];
cfg.method              = 'lcmv';                    %specify minimum norm estimate as method
% cfg.keeptrials          = 'yes';
% cfg.rawtrial            = 'yes';
% cfg.latency             = 0.025;                    %latency of interest
cfg.sourcemodel         = leadfield_bem;        %the precomputed leadfield
cfg.headmodel           = headmodel_bem;     %the head model
cfg.mne.prewhiten       = 'yes';                    %prewhiten data
cfg.mne.lambda          = 0.1;                      %regularisation parameter
cfg.mne.scalesourcecov  = 'yes';                    %scaling the source covariance matrix
minimum_norm_eeg        = ft_sourceanalysis(cfg, timelock);

cfg                     = [];
cfg.method              = 'eloreta';                    %specify minimum norm estimate as method
% cfg.latency             = 0.025;                    %latency of interest
cfg.grid                = leadfield_fem_eeg;        %the precomputed leadfield
cfg.headmodel           = headmodel_fem_eeg_tr;     %the head model
% cfg.keeptrials = 'yes';
% cfg.rawtrial = 'yes'
eloreta        = ft_sourceanalysis(cfg, timelock);

cfg                     = [];
cfg.method              = 'sloreta';                    %specify minimum norm estimate as method
% cfg.latency             = 0.025;                    %latency of interest
cfg.grid                = leadfield_fem_eeg;        %the precomputed leadfield
cfg.headmodel           = headmodel_fem_eeg_tr;     %the head model
sloreta        = ft_sourceanalysis(cfg, timelock);


cfg                     = [];
cfg.method              = 'lcmv';                    %specify minimum norm estimate as method
% cfg.latency             = 0.025;                    %latency of interest
cfg.grid                = leadfield_fem_eeg;        %the precomputed leadfield
cfg.headmodel           = headmodel_fem_eeg_tr;     %the head model
% cfg.keeptrials = 'yes';
% cfg.rawtrial = 'yes'
lcmv       = ft_sourceanalysis(cfg, timelock);

cfg            = [];
cfg.parameter  = 'pow';
interpolate    = ft_sourceinterpolate(cfg, sloreta , mri_resliced);

cfg = [];
cfg.method        = 'ortho';
cfg.funparameter  = 'pow';
aal = ft_read_atlas('ROI_MNI_V4.nii');
cfg.atlas = ft_read_atlas('ROI_MNI_V4.nii');
% cfg.roi = aal.tissuelabel{1};
ft_sourceplot(cfg,interpolate);