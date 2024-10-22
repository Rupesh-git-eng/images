### Build image
#### oc new-build --binary --strategy=docker --name nginx-header
#### oc start-build nginx-header --from-dir . -F
  
