#! /bin/bash

function usage() {
    cat <<USAGE

    Usage: [--upload]

    Options:
        --upload:  ignore/don't use, this is for uploading to DockerHub
USAGE
    exit 1
}


SKIP_VERIFICATION=false
while [ "$1" != "" ]; do
    case $1 in
    --upload)
        UPLOAD=true
        ;;
    -h | --help)
        usage
        ;;
    *)
        usage
        exit 1
        ;;
    esac
    shift
done

pushd site_utils
docker build -f base_dockerfile . -t chasemc2/npbnb:0.0.1
popd 

if [[ $UPLOAD == true ]]; then
    docker push chasemc2/npbnb:0.0.1
fi