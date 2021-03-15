% %%
% % mri = ft_read_mri('yzwT1.nii');
% mri = ft_read_mri('yzwT1.nii');
% mri = ft_determine_coordsys(mri);
% 
% cfg     = [];
% cfg.dim = mri.dim;
% mri     = ft_volumereslice(cfg,mri);
% cfg=[];
% ft_sourceplot(cfg,mri);
% 
% cfg           = [];
% cfg.output    = {'gray','white','csf','skull','scalp'};
% segmentedmri  = ft_volumesegment(cfg, mri);
% 
% save segmentedmri segmentedmri
% 
% seg_i = ft_datatype_segmentation(segmentedmri,'segmentationstyle','indexed');
% 
% cfg              = [];
% cfg.funparameter = 'seg';
% cfg.funcolormap  = lines(6); % distinct color per tissue
% cfg.location     = 'center';
% cfg.atlas        = seg_i;    % the segmentation can also be used as atlas
% ft_sourceplot(cfg, seg_i);
% 
% cfg        = [];
% cfg.shift  = 0.3;
% cfg.method = 'hexahedral';
% mesh = ft_prepare_mesh(cfg, segmentedmri);
% 
% cfg        = [];
% cfg.method ='simbio';
% cfg.conductivity = [0.33 0.14 1.79 0.01 0.43];   % order follows mesh.tissyelabel
% headmodel        = ft_prepare_headmodel(cfg, mesh);
%%
% load the template MNI headmodel, electrodes and MRI

headmodel = ft_read_headmodel('standard_bem.mat');
elec = ft_read_sens('standard_1020.elc');
mri = ft_read_mri('Subject01.mri');

%%
% explore the location to place the dipole

cfg = [];
ft_sourceplot(cfg, mri);


%%
% compute a forward model for a single dipole, 10 trials of 1 second each, with a 2Hz signal

cfg = [];
cfg.dip.unit = 'mm';
cfg.dip.pos = [-40 -20 50]; % left motor cortex
% cfg.dip.pos = [-50 30 -10]; % orbitofrontaal
cfg.dip.mom = cfg.dip.pos/norm(cfg.dip.pos); % radial
cfg.dip.mom = [0 1 0]; % tangential
cfg.dip.frequency = 2;
cfg.elec = elec;
cfg.headmodel = headmodel;
data = ft_dipolesimulation(cfg);

%%
% use low-level functions to make a detailled figure

figure
% ft_plot_headmodel(headmodel);
% ft_plot_ortho(mri.anatomy, 'location', [0 0 0], 'transform', mri.tra);
ft_plot_sens(elec, 'label', 'label');
ft_plot_dipole(data.cfg.dip.pos, data.cfg.dip.mom, 'unit', 'mm')

%%
% again look at ft_sourceplot, make a cross-section at the dipole position

cfg = [];
cfg.location = data.cfg.dip.pos;
ft_sourceplot(cfg, mri)

%%
% compute an averaged ERP over trials

cfg = [];
timelock = ft_timelockanalysis(cfg, data);

%%
% plot the averaged ERP

cfg = [];
cfg.layout = 'elec1010.lay';
ft_multiplotER(cfg, timelock);