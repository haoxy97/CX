
```bash
mkdir `seq 0 9`
find */ -maxdepth 0 -exec cp lmp.sh {}/lmp.sh \;
find */ -maxdepth 0 -exec cp pbs.sh {}/pbs.sh \;
find */pbs.sh -exec qsub {} \;
