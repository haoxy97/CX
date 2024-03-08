## file discription
lmp.in: lammps input file
pbs.sh: PBS  setting file, start like "#PBS -l walltime..."


```bash
mkdir `seq 0 9` # cteate 10 folder
find */ -maxdepth 0 -exec cp lmp.in {}/lmp.in \;
find */ -maxdepth 0 -exec cp pbs.sh {}/pbs.sh \;
find */pbs.sh -exec qsub {} \;
