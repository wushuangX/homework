% https://www.fieldtriptoolbox.org/workshop/ohbm2018/forward/
mri_orig = ft_read_mri('T1_normalize.nii'); % T1_normalize.nii是健康人配准到mni空间的数据
mri_orig = ft_determine_coordsys(mri_orig);
% cfg          = [];
% ft_sourceplot(cfg, mri_orig);
cfg          = [];
mri_resliced = ft_volumereslice(cfg, mri_orig);
% cfg          = [];
% ft_sourceplot(cfg, mri_resliced);

cfg = [];
cfg.output = {'brain','skull', 'scalp'};
mri_segmented_3_compartment = ft_volumesegment(cfg, mri_resliced);

cfg = [];
cfg.tissue = {'brain','skull','scalp'};
cfg.numvertices = [3000 2000 1000];
mesh_bem=ft_prepare_mesh(cfg,mri_segmented_3_compartment);

cfg = [];
cfg.method ='bemcp'; % You can also specify 'bemcp', or another method.
headmodel_bem       = ft_prepare_headmodel(cfg, mesh_bem);

cfg = [];
cfg.method    = 'interactive';
cfg.elec      = data.elec;
cfg.headshape = headmodel_bem.bnd(1);
elec = ft_electroderealign(cfg);

% create source-model
cfg = [];
cfg.resolution = 2;
cfg.threshold = 0.1;
cfg.smooth = 5;
cfg.headmodel = headmodel_bem;
cfg.inwardshift = 1; %shifts dipoles away from surfaces
sourcemodel = ft_prepare_sourcemodel(cfg);

cfg = [];
cfg.grid = sourcemodel;
cfg.headmodel= headmodel_bem;
cfg.elec = data.elec;
cfg.reducerank = 3;
leadfield_bem = ft_prepare_leadfield(cfg);
save leadfield_bem_jiankangren leadfield_bem