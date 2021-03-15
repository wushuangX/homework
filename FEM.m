%%
mri = ft_read_mri('yzwT1.nii');
mri = ft_read_mri('Subject01.mri');
mri = ft_determine_coordsys(mri);
%%
cfg     = [];
cfg.dim = mri.dim;
mri     = ft_volumereslice(cfg,mri);
cfg=[];
ft_sourceplot(cfg,mri);
%%
cfg           = [];
cfg.output    = {'gray','white','csf','skull','scalp'};
segmentedmri  = ft_volumesegment(cfg, mri);

save segmentedmri segmentedmri
%%
seg_i = ft_datatype_segmentation(segmentedmri,'segmentationstyle','indexed');

cfg              = [];
cfg.funparameter = 'seg';
cfg.funcolormap  = lines(6); % distinct color per tissue
cfg.location     = 'center';
cfg.atlas        = seg_i;    % the segmentation can also be used as atlas
ft_sourceplot(cfg, seg_i);
%%
cfg        = [];
cfg.shift  = 0.3;
cfg.method = 'hexahedral';
mesh = ft_prepare_mesh(cfg,segmentedmri);
%%
cfg        = [];
cfg.method ='simbio';
cfg.conductivity = [0.33 0.14 1.79 0.01 0.43];   % order follows mesh.tissyelabel
vol        = ft_prepare_headmodel(cfg, mesh);

save vol vol
%%
ft_plot_mesh(mesh, 'surfaceonly', 'yes');
%%
elec = ft_read_sens('standard_1020.elc');
figure
hold on
ft_plot_mesh(mesh,'surfaceonly','yes','vertexcolor','none','edgecolor','none','facecolor',[0.5 0.5 0.5],'face alpha',0.7)
camlight

% ft_plot_sens(elec,'style', 'sr');