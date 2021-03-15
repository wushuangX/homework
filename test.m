sloreta = loreta2fieldtrip('D:\vscode\MATLAB\EEG2-slor.txt');

% Read in the MNI template from SP
% template = ft_read_mri([cur_path_FT, '\external\spm8\templates\T1.nii']);
mri = ft_read_mri('Subject01.mri');
% Interpolate your LORETA volume on the MNI template:
cfg = [];
cfg.parameter = 'inside';
[interp_mean] = ft_sourceinterpolate(cfg, sloreta, mri);

cfg = [];
cfg.method = 'ortho';
% cfg.parameter = {'inside', 'mom'};
cfg.funparameter  = 'pow';
cfg.maskparameter = cfg.funparameter;
cfg.funcolorlim   = [0.0 1.2];
cfg.opacitylim    = [0.0 1.2];
cfg.opacitymap    = 'rampup';
ft_sourceplot(cfg, interp_mean);