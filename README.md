# Modernization Script for the Raritan Multi-Platform Client on Mac

The Raritan MPC for the older Dominion products (KX II/etc) uses an outdated version of Java that is
incompatible with modern macs. This makes use of a brew-installed Java 11 to run properly on these computers.

## Building

Download the latest MPC for the KX II (mpc-installer.MPC_7.0.3.5.62.jar.zip, md5 = `82e169d048149182fbfc6a569fe147e1`) and place in the `inputs/orig/` folder.

Run `rewrite.sh`

## Downloading Binary Releases

The release for this project is not a full Mac binary, but rather a `bspatch` from the original `mpc-installer.MPC_7.0.3.5.62.jar.zip` to
a zip of a Mac Application.

Follow the guide in the release section to patch the original MPC release.
