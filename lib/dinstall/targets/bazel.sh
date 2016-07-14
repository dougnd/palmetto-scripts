
# returns true if bazel is installed
is_installed_bazel () {
    is_stowed bazel
}

# will exit with error if dependencies are not met 
# (0 means dependencies met, 1 means not met)
dependencies_satisfied_bazel () {
    if [ $HOSTNAME = "user001" ]; then
        echo "Cannot install bazel while on the user node. try getGPULikeNode first!"
        return 1
    fi
    require_packages gcc
}

uninstall_bazel () {
    unstow bazel
}

install_bazel () {
    cd $TMPDIR
    module add java/1.8.0

    mkdir tmpbin
    cat > tmpbin/gcc <<- EOF
#!/bin/bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH
$INSTALL_DIR/stow/gcc/bin/gcc "\$@"
EOF
    chmod +x tmpbin/gcc

    git clone https://github.com/bazelbuild/bazel.git
    cd bazel
    PATH=$TMPDIR/tmpbin:$PATH ./compile.sh

    mkdir -p $INSTALL_DIR/stow/bazel/bin
    cp output/bazel $INSTALL_DIR/stow/bazel/bin/

    dostow bazel

    cd $TMPDIR
    rm -rf bazel
    rm -rf tmpbin
}

binary_deploy_bazel () {
    binary_deploy_stow bazel
}
binary_install_bazel () {
    binary_install_stow bazel
}
binary_available_bazel () {
    binary_available_stow bazel
}
