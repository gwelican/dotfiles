asdf current golang >/dev/null 2>&1

ret=$?
if [ $ret -eq 0 ]; then
    GOV=$(asdf current golang | awk '{print $2}')
    export GOROOT=$ASDFINSTALLS/golang/$GOV/go/
    export GOPATH=$HOME/go-workspace # don't forget to change your path correctly!
    export PATH=$PATH:$GOPATH/bin
    export PATH=$PATH:$GOROOT/bin
fi