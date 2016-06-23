# palmetto-scripts

Some scripts and tools to help me manage my programs on the Palmetto Cluster

## Installation:
```bash
bash <(curl -s https://raw.githubusercontent.com/dougnd/palmetto-scripts/v2/bin/basicSetup.sh)
```

## Usage:

```bash
dinstall <command> [arguments]
```
Command can be one of the following:
- `update`  updates dinstall and palmetto-scripts (pulls from github).
- `install` installs packages and their dependencies.  Multiple packages can be supplied.
    e.g.: `dinstall install caffe_cudnn tensorflow  # installs caffe and tensorflow as well as all thier dependencies`
- `uninstall` removes packages.   Multiple packages can be supplied.
- `upgrade` upgrades packages.   Multiple packages can be supplied.


Also available are some commands:
- `getCPUNode` gets a node (6 cores, 10GB, 6 hr)
- `getGPUNode` gets a GPU node with a k40 (6 cores, 10GB, 6 hr)
- `getGPULikeNode` gets a node without a GPU, but the same architecture (6 cores, 10GB, 6 hr)



## OLD STUFF BELOW:

## dinstall

```bash
dinstall <name>
```
Installs `<name>` to `$INSTALL_DIR`.  Default `$INSTALL_DIR` is `$HOME/usr/bin`.  You should also set the enviornment variable `$cores` to specify how many cores to use when building.

## getGPUNode, getCPUNode

Scripts to either get a CPU or GPU node. The CPU node is 6 cores, 8GB, 6hrs. The GPU node is 6 cores, 10GB.
```bash
getGPUNode
```
or
```bash
getCPUNode
```

# Auto fresh install: Version 2
run:
```
bash <(curl -s https://raw.githubusercontent.com/dougnd/palmetto-scripts/v2/bin/basicSetup.sh)
```
Then (after logout/login or `source ~/.bashrc`),
```
getGPULikeNode
dinstall caffe_cudnn  # or whatever, dependencies are automatically resolved.
```

# Auto fresh install: Depreciated
run:
```
bash <(curl -s https://raw.githubusercontent.com/dougnd/palmetto-scripts/master/bin/installCaffe.sh)
```

# Manual fresh install: (not fully tested)

Decide where you want to install things.  I assume `~/usr/local`.
Add info to `.bashrc`:
```bash
module add cuda-toolkit/7.0.28 gcc/4.8.1
export ACLOCAL_PATH="$HOME/usr/local/share/aclocal${ACLOCAL_PATH:+":$ACLOCAL_PATH"}"
export PKG_CONFIG_PATH="$HOME/usr/local/lib/pkgconfig${PKG_CONFIG_PATH:+":$PKG_CONFIG_PATH"}"
export PATH="$HOME/usr/local/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/usr/local/lib${LD_LIBRARY_PATH:+":$LD_LIBRARY_PATH"}"
export LIBRARY_PATH="$HOME/usr/local/lib${LIBRARY_PATH:+":$LIBRARY_PATH"}"
```

Get an interactive job:
```bash
qsub -I
```

We need some perl modules:
```bash
cpan App::cpanminus
source ~/.bashrc # update PATH changes from the previous command 
cpanm Test::Output
```

Get these scripts:
```bash
mkdir -p $HOME/usr/local/stow/; cd $HOME/usr/local/stow/
git clone https://github.com/dougnd/palmetto-scripts.git
```

Install stow, then the palmetto-scripts:
```bash
cd ~/usr/local/stow
palmetto-scripts/bin/dinstall stow
stow palmetto-scripts
```

You are done with that CPU only interactive job:
```bash
exit
```

Get an interactive GPU node and install various libraries using dinstall:
```bash
getGPUNode
dinstall gcc
dinstall cmake
dinstall python27
dinstall pip
dinstall numpy
dinstall ipdb
python -m pip install -U scipy # you may need to do export LDFLAGS="-shared" before. If you do set LDFLAGS, clear it before opencv (and maybe even before the next line) with export LDFLAGS=""
python -m pip install -U scikit-image
dinstall opencv
dinstall leveldb
dinstall gflags
dinstall protobuf
dinstall glog
dinstall lmdb
dinstall snappy
dinstall boost
dinstall caffe
dinstall gdal
dinstall postgresql
dinstall libpqxx
```


