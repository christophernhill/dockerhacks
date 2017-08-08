# Make sure system drive has some free space


# Setup docker
curl -fsSL https://get.docker.com/ | sh
systemctl enable docker
systemctl start docker

# Fetch an image from Docker hub
docker pull centos:7.3.1611

# Start a container based on an image
docker run --name centos_base -d -t centos:7.3.1611 /bin/bash


# Shell into the container
docker exec -t -i centos_base /bin/bash
    mkdir /home/software
    cd  /home/software
    yum -y install epel-release
    yum list all > yall.txt
    yum -y install environment-modules
    yum -y install which make m4 bc
    yum -y install gcc gcc-gfortran
    yum -y install mvapich2-2.2 mvapich2-2.2-devel
    yum -y install mpich-3.2 mpich-3.2-devel
    yum -y install mpich     mpich-devel
    yum -y install openmpi openmpi-devel
    yum -y install netcdf-*
    yum -y install git
    yum -y install mlocate

git config --global user.email "cnh@mit.edu"
git config --global user.name "Chris Hill"
git clone git@github.com:altMITgcm/MITgcm66h.git
cd MITgcm66h/
git checkout -b pr-testing/jklymak/addNF90IO
git pull https://github.com/jklymak/MITgcm66h.git addNF90IO

cd verification/testNF90io
mkdir run build
cd build
source ~/.bashrc
module purge all
module load  mpi/mpich-x86_64
export MPI_INC_DIR=${MPI_INCLUDE}
export NETCDF_ROOT=`nc-config --prefix`
cat > mypatch.patch <<'EOFA'
diff --git a/tools/genmake2 b/tools/genmake2
index 005c19f..9b026b8 100755
--- a/tools/genmake2
+++ b/tools/genmake2
@@ -1097,5 +1097,5 @@ check_nf90io_libs()  {
     echo "<<<  f90tst_parallel.f90 ===" >> f90tst_parallel.log
-    echo "$FC $FFLAGS $FOPTIM -c f90tst_parallel.f90 \ " >> f90tst_parallel.log
+    echo "$F90C $FFLAGS $FOPTIM -c f90tst_parallel.f90 \ " >> f90tst_parallel.log
     echo "  &&  $LINK $FFLAGS $FOPTIM -o f90tst_parallel.o $LIBS" >> f90tst_parallel.log
-    $FC $FFLAGS $FOPTIM  $INCLUDES -c ${TOOLSDIR}/maketests/f90tst_parallel.f90 >> f90tst_parallel.log 2>&1  \
+    $F90C $FFLAGS $FOPTIM  $INCLUDES -c ${TOOLSDIR}/maketests/f90tst_parallel.f90 >> f90tst_parallel.log 2>&1  \
        &&  $LINK $FFLAGS $FOPTIM -o  f90tst_parallel f90tst_parallel.o $LIBS >> f90tst_parallel.log 2>&1
@@ -1110,5 +1110,5 @@ check_nf90io_libs()  {
        echo "==> try again with added '-lnetcdf'" > f90tst_parallel.log
-       echo "$FC $FFLAGS $FOPTIM -c f90tst_parallel.f90 \ " >> f90tst_parallel.log
+       echo "$F90C $FFLAGS $FOPTIM -c f90tst_parallel.f90 \ " >> f90tst_parallel.log
        echo "  &&  $LINK $FFLAGS $FOPTIM -o f90tst_parallel.o $LIBS -lnetcdf" >> f90tst_parallel.log
-       $FC $FFLAGS $FOPTIM  $INCLUDES -c  ${TOOLSDIR}/maketests/f90tst_parallel.f90 >> f90tst_parallel.log 2>&1  \
+       $F90C $FFLAGS $FOPTIM  $INCLUDES -c  ${TOOLSDIR}/maketests/f90tst_parallel.f90 >> f90tst_parallel.log 2>&1  \
            &&  $LINK $FFLAGS $FOPTIM -o  f90tst_parallel f90tst_parallel.o $LIBS -lnetcdf >> f90tst_parallel.log 2>&1
@@ -1125,5 +1125,5 @@ check_nf90io_libs()  {
            
-           echo "$FC $FFLAGS $FOPTIM -c f90tst_parallel.f90 \ " >> f90tst_parallel.log
+           echo "$F90C $FFLAGS $FOPTIM -c f90tst_parallel.f90 \ " >> f90tst_parallel.log
            echo "  &&  $LINK $FFLAGS $FOPTIM -o f90tst_parallel.o $LIBS -lnetcdf" >> f90tst_parallel.log
-           $FC $FFLAGS $FOPTIM  $INCLUDES -c  ${TOOLSDIR}/maketests/f90tst_parallel.f90 >> f90tst_parallel.log 2>&1  \
+           $F90C $FFLAGS $FOPTIM  $INCLUDES -c  ${TOOLSDIR}/maketests/f90tst_parallel.f90 >> f90tst_parallel.log 2>&1  \
                &&  $LINK $FFLAGS $FOPTIM -o f90tst_parallel f90tst_parallel.o $LIBS -lnetcdf -lnetcdff >> f90tst_parallel.log 2>&1
EOFA
git apply mypatch.patch 
../../../tools/genmake2 -mods=../code -optfile=../../../tools/build_options/linux_amd64_gfortran -mpi
