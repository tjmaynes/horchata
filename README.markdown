# Learning Kubernetes

> Learning Kubernetes by setting up Helm and Spinnaker on Google Kubernetes Engine.

## Requirements

- [Google Cloud SDK](https://cloud.google.com/sdk/docs/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/s)

## Usage

To install dependencies, run the following command:
```bash
make install_dependencies
```

To delete the entire K8s cluster on gCloud setup, including service accounts and storage utils created for this project, run the following command:
```bash
make clean
```

Optional: Setup port forwarding to localhost, run the following command:
```bash
make setup_port_forwarding PORT=3000
```

## Notes

- [GCP Bug](https://github.com/spinnaker/spinnaker.github.io/issues/443#issuecomment-408913130): When you run `make clean` it will delete the service-account created, once you delete your service-account you *will* have to create a new service-account name that is unique (you haven't used yet).

## Links

- [Deploy Spinnaker on Kubernetes Engine](https://medium.com/velotio-perspectives/know-everything-about-spinnaker-how-to-deploy-using-kubernetes-engine-57090881c78f)
- [Spinnaker Helm Chart](https://github.com/helm/charts/blob/master/stable/spinnaker/values.yaml)
- [Spinnaker Docker Registry setup](https://www.spinnaker.io/setup/install/providers/docker-registry/)
- [Continuous Delivery on GKE and Spinnaker tutorial](https://cloud.google.com/solutions/continuous-delivery-spinnaker-kubernetes-engine)

## LICENSE
```
The MIT License (MIT)

Copyright (c) 2019 TJ Maynes

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
