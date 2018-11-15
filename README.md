## Docker Image: wangkexiong/kindle

Combine with [KindleUnpack][kindleunpack], [kindlegen][kindlegen] and [kindlestrip][kindlestrip], we provide the solution for ebooks format convertion.

### Example:

* Convert all azw3 files under current directory to epub files:

```bash
$ docker run --rm -v $PWD:/working wangkexiong/kindle
```

* Under current directory, convert all azw3 files to epub files and convert all epub files to mobi(k8) files:

```bash
$ docker run --rm -v $PWD:/working wangkexiong/kindle -m
```

  [kindleunpack]: https://github.com/kevinhendricks/KindleUnpack
  [kindlegen]:    https://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000765211
  [kindlestrip]:  https://github.com/jefftriplett/kindlestrip

