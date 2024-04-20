#! /bin/bash


# install intel one api
#source ${HOME}/intel/oneapi/setvars.sh
# aocc
# source ${HOME}/software/setenv_AOCC.sh
# cuda
# export PATH="$PATH:/usr/local/cuda-12.4/bin"
# export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda-12.4/lib64"

sudo apt install build-essential cmake ninja-build python3-distutils python3-apt cmake ffmpeg libnetcdf-dev git netcdf-bin gfortran  libreadline-dev libnuma-dev -y 
cd
mkdir $HOME/software
sudo apt install build-essential cmake ninja-build python3-distutils python3-apt
cd llvm-project
mkdir build
cd build
cmake -G Ninja ../llvm \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_ENABLE_PROJECTS="clang;openmp" \
    -DLLVM_ENABLE_RTTI=ON \
    -DLLVM_ENABLE_EH=ON \
    -DCLANG_OPENMP_NVPTX_DEFAULT_ARCH="sm_35" \
    -DOPENMP_ENABLE_LIBOMPTARGET=OFF \
    -DCMAKE_INSTALL_PREFIX=$HOME/software/clang \
    -DCLANG_OPENMP_OMPT_SUPPORT=ON \
    -DCMAKE_C_FLAGS="-march=native -mavx2" \
    -DCMAKE_CXX_FLAGS="-march=native -mavx2"
ninja
ninja install
export PATH=${HOME}/software/clang/bin:$PATH
export LD_LIBRARY_PATH="${HOME}/software/clang/lib:$LD_LIBRARY_PATH"

cd $HOME/software
mkdir openmpi4 lammps

wget 'https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.6.tar.gz'
tar -xvf openmpi-4.1.6.tar.gz
cd openmpi-4.1.6/
./configure CC=clang CCX=clang++ CFLAGS="-mavx2" CXXFLAGS="-mavx2" --prefix=${HOME}/software/openmpi4 --enable-orterun-prefix-by-default --enable-mpi-cxx
make -j
make install
export PATH="${HOME}/software/openmpi4/bin:$PATH"
export LD_LIBRARY_PATH="${HOME}/software/openmpi4/lib:$LD_LIBRARY_PATH"
cd ${HOME}software/clang;ln -s x86_64-unknown-linux-gnu/* .
cd ${HOME}/software
wget 'https://download.lammps.org/tars/lammps-stable.tar.gz'
mkdir -p lammps-stable
tar -xvf lammps-stable.tar.gz -C lammps-stable --strip-components=1
cd lammps-stable
mkdir build
cd build

cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -D BUILD_TOOLS=yes -D BUILD_LAMMPS_SHELL=yes -D PKG_REAXFF=yes -D PKG_EXTRA-FIX=yes -D PKG_EXTRA-COMPUTE=yes -D PKG_H5MD=yes -D PKG_VORONOI=yes -D DOWNLOAD_VORO=yes -D PKG_OPENMP=yes -D BUILD_OMP=yes -D PKG_NETCDF=yes PKG_OPT=yes  -D LAMMPS_EXCEPTIONS=yes -D BUILD_MPI=yes -D CMAKE_INSTALL_PREFIX=${HOME}/software/lammps ../cmake
# cuda version not use icc
# cmake -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -D PKG_GPU=yes -D GPU_API=cuda -D GPU_PREC=single  -D BUILD_TOOLS=yes -D BUILD_LAMMPS_SHELL=yes -D PKG_REAXFF=yes -D PKG_EXTRA-FIX=yes -D PKG_EXTRA-COMPUTE=yes -D PKG_H5MD=yes   -D PKG_OPENMP=yes -D BUILD_OMP=yes -D PKG_NETCDF=yes PKG_OPT=yes  -D LAMMPS_EXCEPTIONS=yes -D BUILD_MPI=yes -D CMAKE_INSTALL_PREFIX=${HOME}/software/lammps ../cmake
make -j
make install

export PATH="${HOME}/software/lammps/bin:$PATH"
# export LD_LIBRARY_PATH="${HOME}/lammps/lib:$LD_LIBRARY_PATH"

cd ~
echo 'export LD_LIBRARY_PATH="${HOME}/software/openmpi4/lib:$LD_LIBRARY_PATH"' >> .bashrc
echo 'export PATH="${HOME}/software/openmpi4/bin:${HOME}/lammps/bin:$PATH"' >> .bashrc
