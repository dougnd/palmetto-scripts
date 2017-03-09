# palmetto-scripts

Some scripts and tools to help me manage my programs on the Palmetto Cluster

## UPDATE:

The palmetto team is now providing a tool called Singularity 
(http://singularity.lbl.gov/) to support programs that
require higher glibc versions than provided by palmetto (Tensorflow,Caffe, MXNET, etc). 
To use singularity, you
need to be part of the special Unix group "singularity". You will have to email
the palmetto staff to be part of this unix group.

Once you have become part of that group, you can try out the experimental tensorflow installation:

```
export MODULEPATH=/software/experimental:$MODULEPATH
module add tensorflow/1.0
```

Then, just fire up Python and "import tensorflow".

With singularity, there should be very little need for palmetto-scripts and you should probably disable/uninstall it (see below for instructions) as it may conflict.

(Thanks to Ashwin Srinath for the information on this and the
tensorflow module on palmetto)


## Installation:

### Initialization:
do this first to install the palmetto-scripts (takes ~5 minutes to run). You only have to do this once.
```bash
bash <(curl -s https://raw.githubusercontent.com/dougnd/palmetto-scripts/master/bin/basicSetup.sh)
```

### Install tensorflow:
```bash
getGPULikeNode  # get a node for installation purposes
dinstall tensorflow
exit # leave the node
```

### Test tensorflow:
```bash
qsub -I -l select=1:ncpus=1:mem=10gb:ngpus=2:gpu_model=k40,walltime=0:30:00

cd $TMPDIR
wget https://github.com/tensorflow/tensorflow/tarball/master # may have to try this more than once
tar xf master
cd tensorflow-tensorflow-*/tensorflow/models/image/mnist
python convolutional.py

exit # leave the node
```

### Install caffe:
```bash
getGPULikeNode  # get a node for installation purposes
dinstall caffe_cudnn
exit # leave the node
```

### ***** Notes on GPUs on palmetto:  ******

Note: the following was added to the palmetto MOTD: "Jobs that request gpus but don't use them may be terminated without notice."  Make sure if you are request a gpu, you actually are using it.  You may want to develop on a local machine and deploy to palmetto once you know it works.

Futhermore, every GPU on a node is accessible to your job regardless of whether you request any. Thus, something like tensorflow will detect 2 GPU's and make use of them both even if you only request one.  This is clearly not good since you may interfere with another job.  Make sure you are only using GPU's assigned to you.  If you are requesting a single GPU and want to know what device you were assigned, you can used the following (provided by the palmetto support team):

```bash
export gpuDev=$(qstat -f $PBS_JOBID | awk '/exec_vnode/ {
    match($0, /'`hostname`'\[([0-9]+)\]/, grp);
    print grp[1]
}')
```

You can then use the gpuDev enviornment variable in your scripts.  e.g. :
```bash
echo "Using GPU: $gpuDev"
caffe device_query -gpu $gpuDev
caffe train -solver vehicleDetectorSolver.prototxt -gpu $gpuDev
```


## Usage:

### dinstall
```bash
dinstall [<options>...] <command> [<packages>...]
```
Command can be one of the following:
- `update` - updates dinstall and palmetto-scripts (pulls from github).
- `install` - installs packages and their dependencies.  Multiple packages can be supplied.  
    e.g.: `dinstall install caffe_cudnn tensorflow`  (installs caffe and tensorflow as well as all thier dependencies)
- `uninstall` - removes packages.   Multiple packages can be supplied.
- `upgrade` - upgrades packages.   Multiple packages can be supplied.
- `list` - lists available packages.
- `list installed` - lists installed packages.

Options
- `--help` prints basic usage information.
- `--version` prints version information.
- `--ignore-binaries` installs from source, ignoring available binaries.



### Other commands
- `getCPUNode` gets a node (6 cores, 10GB, 6 hr)
- `getGPUNode` gets a GPU node with a k40 (6 cores, 10GB, 6 hr)
- `getGPULikeNode` gets a node without a GPU, but the same architecture (6 cores, 10GB, 6 hr)


## Uninstall/Disable

To disable palmetto scripts, comment out/remove the following lines from your ~/.bashrc file:
```
export INSTALL_DIR=/home/dndawso/usr/local
source /home/dndawso/usr/local/stow/palmetto-scripts/env_vars.sh
```

To permently delete palmetto-scripts and everything it installed, remove the usr/local folder.

