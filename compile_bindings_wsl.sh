#!/bin/bash
set -e

path2source="$(pwd)/cleo_1dkid/cleo_deps"
path2build="$(pwd)/cleo_1dkid/build"
python="$(which python)"

cxx_compiler="$(which mpic++)"
c_compiler="$(which mpicc)"
cxx_flags="-Wall -Wextra -O3"

CLEO_BUILD_FLAGS="-DCLEO_COUPLED_DYNAMICS=numpy \
  -DCLEO_DOMAIN=cartesian \
  -DCLEO_NO_ROUGHPAPER=true \
  -DCLEO_PYTHON=${python}\
  -DCLEO_YAC_ROOT=/home/klimaszewska/yacyaxt/gcc/yac \
  -DCLEO_YAXT_ROOT=/home/klimaszewska/yacyaxt/gcc/yaxt\
  -DCLEO_YAC_MODULE_PATH=/home/klimaszewska/earth_env/superdrops-in-action/cleo_1dkid/build/_deps/cleo-src/libs/coupldyn_yac/cmake"

CLEO_KOKKOS_FLAGS="-DKokkos_ARCH_NATIVE=ON \
  -DKokkos_ENABLE_SERIAL=ON \
  -DKokkos_ENABLE_OPENMP=ON"

mkdir -p ${path2build}

cmake -DCMAKE_CXX_COMPILER=${cxx_compiler} \
    -DCMAKE_C_COMPILER=${c_compiler} \
    -DCMAKE_CXX_FLAGS="${cxx_flags}" \
    -S ${path2source} -B ${path2build} \
    ${CLEO_KOKKOS_FLAGS} \
    ${CLEO_BUILD_FLAGS}

cd ${path2build}
make -j 4 cleo_python_bindings
