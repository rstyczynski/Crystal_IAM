
cd /Users/rstyczynski/oci/scheme/test1_comments
newdir=/Users/rstyczynski/oci/scheme/test1_no_comments
mkdir $newdir
for dir in $(ls); do
    cd $dir
    mkdir $newdir/$dir
    cp .* $newdir/$dir
    if [ -f .template ]; then
        echo "### .template exists"
        if [ $(cat .template) = ".template-family" ]; then
            echo "### .template exists and is .template-family"
            for file in $(ls); do
                cat $file | 
                sed '/request.ad/d' |
                tr '\n' '%' |
                sed 's/where all {%}//' |
                tr '%' '\n' > $newdir/$dir/$file
            done     
        else
            for file in $(ls); do
                cat $file | 
                sed '/request.ad/d' | 
                tr '\n' '%' |
                sed 's/where all {%}//' |
                tr '%' '\n' > $newdir/$dir/$file
            done
        fi 
    else
        for file in $(ls); do
            cat $file | 
            sed '/request.ad/d' | 
            tr '\n' '%' |
            sed 's/where all {%}//' |
            tr '%' '\n' > $newdir/$dir/$file
        done
    fi
    cd ..
done

