
cd /Users/rstyczynski/oci/scheme/test1_no_comments
newdir=/Users/rstyczynski/oci/scheme/v0.1
mkdir $newdir
for dir in $(ls); do
    cd $dir
    mkdir $newdir/$dir
    cp .* $newdir/$dir
    cp create $newdir/$dir/create
    cp read $newdir/$dir/read
    cp use $newdir/$dir/use
    cp tune $newdir/$dir/optimise
    cp manage $newdir/$dir/retire
    echo " where all {
    request.permission=/*_MOVE/
}" >> $newdir/$dir/retire

    cp decommission $newdir/$dir/decommission
    cp inspect $newdir/$dir/inspect
    cp manage $newdir/$dir/manage
    cd ..
done

