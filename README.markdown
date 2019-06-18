# Learning Kubernetes

> Learning Kubernetes by setting up Helm and Spinnaker on Google Kubernetes Engine.

## Requirements

- [Google Cloud SDK](https://cloud.google.com/appengine/docs/standard/go/download)
- [Google Cloud Registration](https://cloud.google.com/gcp/getting-started/)

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

- [Deploy Spinnaker on Kubernetes Engine](https://medium.com/velotio-perspectives/know-everything-about-spinnaker-how-to-deploy-using-kubernetes-engine-57090881c78f)

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
