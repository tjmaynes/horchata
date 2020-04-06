# Kubernetes Sandbox

> Automating the creation of a Kubernetes sandbox on Google Kubernetes Engine.

## Requirements

- [GNU Make](https://www.gnu.org/software/make)
- [Curl](https://curl.haxx.se/)

## Usage

To setup the workstation, run the following command:
```bash
make workstation
```

To setup kubernetes, helm, and istio, run the following command:
```bash
make setup_cluster
```

To teardown the kubernetes, helm, and istio setup, run the following command:
```bash
make teardown_cluster
```

To get to a clean state, run the following command:
```bash
make teardown_cluster && make clean
```

## Setting up a Kubernetes Cluster on GKE

1. **WARNING**: the following will create services for real (as in money/billing). Make sure you run `make teardown_cluster` and check your [billing](https://console.cloud.google.com/billing/) page.
    - Take a look at this [page](https://cloud.google.com/billing/docs/how-to/budgets) for more info regarding Google Billing.
1. To get started, make sure you are able to [sign into](https://console.cloud.google.com/freetrial/signup/tos?pli=1) Google Cloud.
1. Next, run the following command to setup our workstation environment: `make workstation`.
    - This command will install `gcloud` (including `kubectl` and `helm`) if you do not currently these tools installed in the project's `bin` directory.
    - Also, **before moving on to the next step** make sure you create a project (if you have not already).
1. Next, run the following command to create our Kubernetes cluster on GKE: `make setup_cluster`.
    - This command will setup our GKE cluster with [helm charts](https://helm.sh/docs/topics/charts/) including [istio](https://istio.io/), the "service-mesh" tool.

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
