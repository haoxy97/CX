#! /bin/bash

mkdir openmpi4 lammps
sudo apt install cmake gcc g++  ffmpeg  libnetcdf-dev   git  python3-distutils gfortran netcdf-bin  libreadline-dev libnuma-dev -y 

# install intel one api
source ${HOME}/intel/oneapi/setvars.sh

# aocc
source ${HOME}/software/setenv_AOCC.sh

wget 'https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.5.tar.gz'
tar -xvf openmpi-4.1.5.tar.gz
cd openmpi-4.1.5/
./configure CC=clang CCX=clang++ FC=flang --prefix=${HOME}/openmpi4 --enable-orterun-prefix-by-default --enable-mpi-cxx
make -j 8
make install
export PATH="${HOME}/openmpi4/bin:$PATH"
export LD_LIBRARY_PATH="${HOME}/openmpi4/lib:$LD_LIBRARY_PATH"
# cuda
export PATH="$PATH:/usr/local/cuda-12.4/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda-12.4/lib64"

cd ~
wget 'https://download.lammps.org/tars/lammps-stable.tar.gz'
mkdir -p lammps-stable
tar -xvf lammps-stable.tar.gz -C lammps-stable --strip-components=1
cd lammps-stable
mkdir build
cd build
cmake -D CMAKE_CXX_COMPILER=icx -D BUILD_TOOLS=yes -D BUILD_LAMMPS_SHELL=yes -D PKG_REAXFF=yes -D PKG_EXTRA-FIX=yes -D PKG_EXTRA-COMPUTE=yes -D PKG_H5MD=yes -D PKG_VORONOI=yes -D DOWNLOAD_VORO=yes -D PKG_OPENMP=yes -D BUILD_OMP=yes -D PKG_NETCDF=yes PKG_OPT=yes  -D LAMMPS_EXCEPTIONS=yes -D BUILD_MPI=yes -D CMAKE_INSTALL_PREFIX=${HOME}/lammps ../cmake
# cuda version not use icc
# cmake -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -D PKG_GPU=yes -D GPU_API=cuda -D GPU_PREC=single  -D BUILD_TOOLS=yes -D BUILD_LAMMPS_SHELL=yes -D PKG_REAXFF=yes -D PKG_EXTRA-FIX=yes -D PKG_EXTRA-COMPUTE=yes -D PKG_H5MD=yes   -D PKG_OPENMP=yes -D BUILD_OMP=yes -D PKG_NETCDF=yes PKG_OPT=yes  -D LAMMPS_EXCEPTIONS=yes -D BUILD_MPI=yes -D CMAKE_INSTALL_PREFIX=${HOME}/lammps ../cmake

make -j 8
make install

export PATH="${HOME}/lammps/bin:$PATH"
# export LD_LIBRARY_PATH="${HOME}/lammps/lib:$LD_LIBRARY_PATH"

cd ~
echo 'export LD_LIBRARY_PATH="${HOME}/openmpi4/lib:$LD_LIBRARY_PATH"' >> .bashrc
echo 'export PATH="${HOME}/openmpi4/bin:${HOME}/lammps/bin:$PATH"' >> .bashrc
