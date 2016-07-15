#/bin/bash
export GOPATH=~/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

CONTAINER_AND_BINARY_NAME=normalload
CONTAINER_PATH=~/torc-scripts/docker/example-dns/normalload

mkdir -p $GOPATH/src/github.com/att-innovate

cd $GOPATH/src/github.com/att-innovate
rm -rf $CONTAINER_AND_BINARY_NAME
cp -r $CONTAINER_PATH .

cd $CONTAINER_AND_BINARY_NAME
go get
go install github.com/att-innovate/$CONTAINER_AND_BINARY_NAME

cp $GOPATH/bin/$CONTAINER_AND_BINARY_NAME $CONTAINER_PATH/

