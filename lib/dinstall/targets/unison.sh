
is_installed_unison () {
    is_stowed unison
}

dependencies_satisfied_unison () {
    return 0
}

uninstall_unison () {
    unstow unison
}

install_unison () {
    cd $TMPDIR
    wget http://unison-binaries.inria.fr/files/2011.01.28-Esup-unison-2.40.61-linux-x86_64-text-static.tar.gz
    tar -xf 2011.01.28-Esup-unison-2.40.61-linux-x86_64-text-static.tar.gz

    mkdir -p $INSTALL_DIR/stow/unison/bin
    cp unison-2.40.61-linux-x86_64-text-static $INSTALL_DIR/stow/unison/bin/unison
    
    dostow unison
}
