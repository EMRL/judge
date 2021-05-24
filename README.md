﻿[![release](https://img.shields.io/github/v/release/emrl/judge?sort=semver)](https://github.com/EMRL/stir/releases/latest)
[![Github issues](https://img.shields.io/github/issues/emrl/judge)](https://github.com/EMRL/stir/issues)

`judge` is designed to segment data by gender, using data provided by the U.S. Census and first names. 

[Changelog](https://github.com/EMRL/judge/blob/master/CHANGELOG.md) &bull; [Known bugs](https://github.com/EMRL/judge/issues?q=is%3Aopen+is%3Aissue+label%3Abug)

## Startup Options

```
Usage: judge [options] [target] ...
Options:
  -f, --female           Detect names that are best-guess female
  -m, --male             Detect names that are best-guess male
  -o, --other            Detect names that appear to be neither female or male
  -M, --merged           First and last name are in the same field
  -q, --quoted           First name is quoted
  -Q, --quoted-merged    First and last name are quoted in the same field
  -v, --verbose          Display verbose output
  -d. --debug            Display debug output
  -h, --help             Display this help and exit
```

## Install

Clone this repo or download the [`latest release`](https://github.com/emrl/judge/releases/latest) and run `./judge.sh` in the `judge` directory. No installation is needed.

## Notes

Currently, it is assumed the data being processed has both first and last name in a single quoted cell. options for other formatting will be forthcoming.

Developed and tested in WSL 2.0 with Ubuntu 20.0.4

## Contact

* <http://emrl.com/>
* <https://www.facebook.com/advertisingisnotacrime>
