# returns true if it is installed
is_installed_tensorflow () {
    python -m pip show tensorflow &> /dev/null
}

# will exit with error if dependencies are not met 
# (0 means dependencies met, 1 means not met)
dependencies_satisfied_tensorflow () {
    if [ $HOSTNAME = "user001" ]; then
        echo "Cannot install tensorflow while on the user node. try getGPULikeNode first!"
        return 1
    fi
    require_packages gcc bazel python27 numpy scipy pip cudnn
}

uninstall_tensorflow () {
    python -m pip uninstall -y tensorflow
    rm -r $INSTALL_DIR/stow/tensorflow_pkg
}

install_tensorflow () {
    cd $TMPDIR
    module add java/1.8.0

    echo "making a wrapper for gcc and python..."
    mkdir tmpbin
    cat > tmpbin/gcc <<- EOF
#!/bin/bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH
$INSTALL_DIR/stow/gcc/bin/gcc "\$@"
EOF
    chmod +x tmpbin/gcc
    cat > tmpbin/python <<- EOF
#!/bin/bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH
$INSTALL_DIR/bin/python "\$@"
EOF
    chmod +x tmpbin/python
    export PATH=$TMPDIR/tmpbin:$PATH

    echo "Getting tensorflow..."
    git clone https://github.com/tensorflow/tensorflow
    cd tensorflow

    echo "Configuring tensorflow..."
    export PYTHON_BIN_PATH=$TMPDIR/tmpbin/python
    export TF_NEED_GCP=0
    export TF_NEED_CUDA=1
    export GCC_HOST_COMPILER_PATH=$TMPDIR/tmpbin/gcc
    export TF_CUDA_VERSION=7.5.18
    export CUDA_TOOLKIT_PATH=/software/cuda-toolkit/7.5.18
    export TF_CUDNN_VERSION=4.0.7
    export CUDNN_INSTALL_PATH=$INSTALL_DIR
    # k40, k20:
    export TF_CUDA_COMPUTE_CAPABILITIES=3.5
    module add java/1.8.0
    ./configure

    echo "wrapping their gcc wrapper (lol -- so sketchy)"
    mv third_party/gpus/crosstool/clang/bin/crosstool_wrapper_driver_is_not_gcc third_party/gpus/crosstool/clang/bin/crosstool_wrapper_driver_is_not_gcc_fake
    cat > third_party/gpus/crosstool/clang/bin/crosstool_wrapper_driver_is_not_gcc <<- EOF
#!/bin/bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH
export PATH=$PATH
#echo "CWD: \$(pwd)"
#echo "CMD: $TMPDIR/tensorflow/third_party/gpus/crosstool/clang/bin/crosstool_wrapper_driver_is_not_gcc_fake \$@ --cuda_log"
$TMPDIR/tensorflow/third_party/gpus/crosstool/clang/bin/crosstool_wrapper_driver_is_not_gcc_fake "\$@" -D_GLIBCXX_USE_C99
EOF
    chmod +x third_party/gpus/crosstool/clang/bin/crosstool_wrapper_driver_is_not_gcc
    sed -i "s/cmd = 'PATH='/#cmd = 'PATH='/" third_party/gpus/crosstool/clang/bin/crosstool_wrapper_driver_is_not_gcc_fake

    echo "Fixing crosstool..."
    function addToCROSSTOOL () {
        awk -v "toInsert=$1" '/cxx_builtin_include_directory/ && !x {print toInsert; x=1} 1' third_party/gpus/crosstool/CROSSTOOL > tmpCROSSFILE && mv tmpCROSSFILE third_party/gpus/crosstool/CROSSTOOL
    }
    addToCROSSTOOL "  cxx_builtin_include_directory: \"$INSTALL_DIR/stow/gcc/include\""
    addToCROSSTOOL "  cxx_builtin_include_directory: \"$INSTALL_DIR/stow/gcc/lib/gcc\""
    addToCROSSTOOL "  cxx_builtin_include_directory: \"$TMPDIR/tensorflow/third_party/gpus/cuda/include\""
    for path in ${LD_LIBRARY_PATH//:/ }; do
        addToCROSSTOOL "  linker_flag: \"-Wl,-rpath,$path\""
        addToCROSSTOOL "  linker_flag: \"-L$path\""
    done

    echo "building tensorflow..."
    #bazel --output_base=$TMPDIR/tf_cache build -c opt --config=cuda //tensorflow/cc:tutorials_example_trainer --verbose_failures
    bazel --output_base=$TMPDIR/tf_cache build -c opt --config=cuda //tensorflow/tools/pip_package:build_pip_package --verbose_failures
    bazel-bin/tensorflow/tools/pip_package/build_pip_package $INSTALL_DIR/stow/tensorflow_pkg

    echo "installing tensorflow..."
    python -m pip install $INSTALL_DIR/stow/tensorflow_pkg/tensorflow-*.whl


    cd $TMPDIR
    rm -rf tensorflow
    rm -rf tmpbin
}

binary_deploy_tensorflow () {
    cp $INSTALL_DIR/stow/tensorflow_pkg/tensorflow-*.whl $binary_path
}
binary_install_tensorflow () {
    mkdir -p $INSTALL_DIR/stow/tensorflow_pkg
    cp $binary_path/tensorflow-*.whl $INSTALL_DIR/stow/tensorflow_pkg
    python -m pip install $INSTALL_DIR/stow/tensorflow_pkg/tensorflow-*.whl
}
binary_available_tensorflow () {
    test -f $binary_path/tensorflow-*.whl 
}
