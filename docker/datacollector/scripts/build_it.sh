# build datacollector
export GOPATH=~/go
export DOCKER_DIR=~/torc-scripts/docker
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

go get -u github.com/tools/godep

mkdir -p $GOPATH/src/github.com/att-innovate

cd $GOPATH/src/github.com/att-innovate
rm -rf charmander-datacollector
git clone https://github.com/att-innovate/charmander-datacollector.git
cd charmander-datacollector
git checkout torc

godep restore
go install -a github.com/att-innovate/charmander-datacollector

cp $GOPATH/bin/charmander-datacollector $DOCKER_DIR/datacollector

