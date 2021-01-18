# Horchata

> A (Kubernetes + Istio)-powered PaaS running on GKE bootstrapping tool.

## Requirements

- [GNU Make](https://www.gnu.org/software/make)
- [cURL](https://curl.haxx.se/)
- [Docker](https://docs.docker.com/get-docker/)

## Usage

To install project dependencies, run the following command:
```bash
make install_dependencies
```

To install K8s on GKE and setup Helm and Istio, run the following command:
```bash
make setup
```

## Links

- [Istio: An Introduction](https://github.com/istio/istio#introduction)
- [Creating a VPC-native Cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/alias-ips)

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
