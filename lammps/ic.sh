#! /bin/bash

# Install a modified version lammps in CX1
# must compile at the login node. need esential libs.
module purge
module load tools/eb-dev
module load libreadline
module load aocc/2.3.0
des=${HOME}/software

mkdir -p ${des}/openmpi4
mkdir -p ${des}/lammps
mkdir -p ${des}/netcdf

cd ${HOME}
wget 'https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.5.tar.gz'
tar -xvf openmpi-4.1.5.tar.gz
cd openmpi-4.1.5
./configure CC=clang CCX=clang++ FC=flang --prefix=${des}/openmpi4 --enable-orterun-prefix-by-default --enable-mpi-cxx
make -j 8
make install
export PATH="${des}/openmpi4/bin:$PATH"
export LD_LIBRARY_PATH="${des}/openmpi4/lib:$LD_LIBRARY_PATH"

cd ${HOME}
val=sz2
wget 'https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz'
mkdir -p ${val}-stable
tar -xvf szip-2.1.1.tar.gz -C ${val}-stable --strip-components=1
cd ${val}-stable
./configure CC=clang CCX=clang++ FC=flang --prefix=${des}/${val}
make -j 8
make install
cd ${HOME}/${val}/lib
export LD_LIBRARY_PATH="${des}/sz2/lib:$LD_LIBRARY_PATH"

cd ${HOME}
val=hdf5
wget 'https://github.com/HDFGroup/hdf5/releases/download/hdf5-1_14_2/hdf5-1_14_2.tar.gz'
mkdir -p ${val}-stable
tar -xvf hdf5-1_14_2.tar.gz -C ${val}-stable --strip-components=1
cd ${val}-stable/hdfsrc
./configure CC=clang CCX=clang++ FC=flang --prefix=${des}/${val}
make -j 8
make install
cd ${HOME}/${val}/lib
ln -s libhdf5_hl.so libhdf5_hl.so.100
ln -s libhdf5.so libhdf5.so.103
export LD_LIBRARY_PATH="${des}/hdf5/lib:$LD_LIBRARY_PATH"

cd ${HOME}
val=netcdf
wget 'https://downloads.unidata.ucar.edu/netcdf-c/4.9.2/netcdf-c-4.9.2.tar.gz'
mkdir -p netcdf-stable
tar -xvf netcdf-c-4.9.2.tar.gz -C netcdf-stable --strip-components=1
cd netcdf-stable
./configure CC=clang CCX=clang++ FC=flang --prefix=${des}/${val}
make -j 8
make install
cd ${des}/${val}/lib
ln -s libnetcdf.so libnetcdf.so.15
export LD_LIBRARY_PATH="${des}/netcdf/lib:$LD_LIBRARY_PATH"

cd ${HOME}
wget 'https://download.lammps.org/tars/lammps-stable.tar.gz'
mkdir -p lammps-stable
tar -xvf lammps-stable.tar.gz -C lammps-stable --strip-components=1
cd lammps-stable
mkdir build
cd build

cmake -DCMAKE_PREFIX_PATH=${des}/openmpi4/lib   CMAKE_C_COMPILER=clang -D CMAKE_CXX_COMPILER=clang++ -D CMAKE_Fortran_COMPILER=flang\
 -D PKG_OPENMP=yes -D PKG_OPT=yes -D PKG_NETCDF=yes -D PKG_REAXFF=yes -D PKG_EXTRA-FIX=yes\
 -D BUILD_TOOLS=yes -D BUILD_LAMMPS_SHELL=yes  -D LAMMPS_EXCEPTIONS=yes  -D BUILD_MPI=yes\
 -D CMAKE_INSTALL_PREFIX=${des}/lammps ../cmake
make -j 8
make install

export PATH="${HOME}/software/lammps/bin:$PATH"

echo try input lmp to test it.


echo example of your pbs.sh file
echo '''------------------------------------
#!/bin/bash
#PBS -l select=1:ncpus=16:mem=32gb
#PBS -l walltime=71:00:00

cd $PBS_O_WORKDIR

module purge
module load aocc/2.3.0

export OMP_NUM_THREADS=1 MKL_NUM_THREADS=1
export PATH="${HOME}/software/lammps/bin:${HOME}/software/openmpi4/bin:$PATH"
export LD_LIBRARY_PATH="${HOME}/software/openmpi4/lib:${HOME}/software/netcdf/lib:${HOME}/software/hdf5/lib:${HOME}/software/sz2/lib:$LD_LIBRARY_PATH"

mpirun -np 16 lmp -i lmp.sh
------------------------------------'''
