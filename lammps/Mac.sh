/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install wget cmake netcdf-cxx fftw pkg-config readline open-mpi llvm # libomp

cd /opt
mkdir lammps
wget 'https://download.lammps.org/tars/lammps-stable.tar.gz'
mkdir -p lammps-stable
tar -xvf lammps-stable.tar.gz -C lammps-stable --strip-components=1
cd lammps-stable
mkdir build; cd build

export OMP_PREFIX=/opt/homebrew/opt/libomp
export LDFLAGS="-L/opt/homebrew/opt/libomp/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libomp/include"
echo "need change the right version of libomp lib like "18.1.7""
export PKG_CONFIG_PATH="/opt/homebrew/opt/readline/lib/pkgconfig"
cmake -D BUILD_TOOLS=yes -D BUILD_LAMMPS_SHELL=yes -D CMAKE_C_COMPILER=clang -D CMAKE_CXX_COMPILER=clang++  -D BUILD_OMP=yes  -D PKG_OPENMP=yes -D PKG_OPT=yes -D LAMMPS_EXCEPTIONS=yes -D BUILD_MPI=yes -D PKG_NETCDF=yes -D PKG_REAXFF=yes -D PKG_OPT=yes -D PKG_EXTRA-FIX=yes -D PKG_EXTRA-COMPUTE=yes -D PKG_H5MD=yes -D PKG_VORONOI=yes -D DOWNLOAD_VORO=yes -DOpenMP_CXX_FLAGS="-Xpreprocessor -fopenmp /opt/homebrew/opt/libomp/lib/libomp.dylib -I/opt/homebrew/opt/libomp/include" -DOpenMP_CXX_LIB_NAMES="libomp" -DOpenMP_libomp_LIBRARY="/opt/homebrew/Cellar/libomp/18.1.7/lib/libomp.dylib"  -DCMAKE_INSTALL_PREFIX=/opt/lammps ../cmake

make -j 4
make install

cd ~
echo 'export PATH="/opt/lammps/bin:$PATH"' >> .zshrc
