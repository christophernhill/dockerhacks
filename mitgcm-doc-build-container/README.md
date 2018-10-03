Dockerfile and "provisioning" scripts for creating Ubuntu image for
building MITgcm Spihinx documentation

- example usage
Build an image (if needed)
```
docker build -t mitgcm/doc-build:ubuntu1804 .
```
Start a container (if needed)
```
docker run --name build_doc -v /Users/chrishill/projects/mitgcm/mitgcm-testing:/MITgcm -t -d mitgcm/doc-build:ubuntu1804
```
Connect to container
```
docker exec -i -t build_doc /bin/bash
```
Build docs example (in container)
```
# cd /MITgcm/gits
# cd jrscott/doc
# git checkout doc_edits_ch5
# make html
# make latexpdf
```
