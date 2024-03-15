#! /bin/bash

sudo apt install cmake gcc g++  ffmpeg  libnetcdf-dev   git  python3-distutils gfortran netcdf-bin  libreadline-dev libnuma-dev -y 

cd ~
mkdir openmpi4 lammps
wget 'https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.5.tar.gz'
tar -xvf openmpi-4.1.5.tar.gz
cd openmpi-4.1.5/
./configure --prefix=${HOME}/openmpi4 --enable-orterun-prefix-by-default --enable-mpi-cxx

# please wait
make -j 8
make install

export PATH="${HOME}/openmpi4/bin:$PATH"
export LD_LIBRARY_PATH="${HOME}/openmpi4/lib:$LD_LIBRARY_PATH"

cd ~
wget 'https://download.lammps.org/tars/lammps-stable.tar.gz'
mkdir -p lammps-stable
tar -xvf lammps-stable.tar.gz -C lammps-stable --strip-components=1
cd lammps-stable
mkdir build
cd build
# add more package for your needs
cmake -DCMAKE_PREFIX_PATH=/home/$USER/openmpi4/lib -D BUILD_TOOLS=yes -D BUILD_LAMMPS_SHELL=yes -D PKG_OPENMP=yes -D PKG_OPT=yes  -D LAMMPS_EXCEPTIONS=yes -D BUILD_MPI=yes -D CMAKE_INSTALL_PREFIX=/home/$USER/lammps ../cmake

make -j 8
make install

export PATH="/home/$USER/lammps/bin:$PATH"
export LD_LIBRARY_PATH="/home/$USER/lammps/lib:$LD_LIBRARY_PATH"

cd ~
echo 'export LD_LIBRARY_PATH="/home/$USER/openmpi4/lib:$LD_LIBRARY_PATH"' >> .bashrc
echo 'export PATH="/home/$USER/openmpi4/bin:/home/$USER/lammps/bin:$PATH"' >> .bashrc
