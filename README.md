<a name="readme-top"></a>

English | [简体中文](./README-zh_CN.md)

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![Apache License][license-shield]][license-url]


<br />
<div align="center">
  <a href="https://github.com/maiqingqiang/ChatMLX">
    <img src="ChatMLX/Assets.xcassets/AppIcon.appiconset/1024.png" alt="Logo" width="80" height="80">
  </a>

<h3 align="center">ChatMLX</h3>

  <p align="center">
    ChatMLX is a modern, open-source, high-performance chat application for MacOS based on large language models, based on the powerful performance of <a href="https://github.com/ml-explore/mlx-swift">MLX</a> and Apple silicon. It supports multiple models, providing users with a rich variety of conversation options. It runs LLM locally to ensure user privacy and security.
    <br />
    <br />
    <a href="https://github.com/maiqingqiang/ChatMLX/issues">Report Bug</a>
    ·
    <a href="https://github.com/maiqingqiang/ChatMLX/issues">Request Feature</a>
    ·
    <a href="https://github.com/maiqingqiang/ChatMLX/releases">Download</a>
  </p>
</div>

## Features 🚀

- **Multilingual:** Supports all 39 major App Store languages, including English, Simplified Chinese, Traditional Chinese, Japanese, and Korean.
- **Multiple Models**: Provides multiple models, including Llama, OpenELM, Phi, Qwen, Starcoder, Cohere, Gemma.
- **High Performance**: Based on the powerful performance of MLX and Apple silicon.
- **Privacy and Security**: Run LLM locally to ensure user privacy and security.
- **Open Source**: Open source, welcome to contribute.

> [!NOTE]
>
> Compatible with macOS 14.0 and later.

https://github.com/user-attachments/assets/75984252-058f-4782-ad5d-33b3ce772639

![iShot_2024-08-31_23.55.39.png](images/iShot_2024-08-31_23.55.39.png)

## FAQ

### 1. After installing on macOS, it shows "The file is damaged" or there’s no response when opening it.

ChatMLX is not signed, which causes macOS security checks to block it.

If you encounter the "The file is damaged" error after installation, follow these steps:

```bash
xattr -cr /Applications/ChatMLX.app
```

You should then be able to open it normally.

If you see this message:

```sh
option -r not recognized

usage: xattr [-slz] file [file ...]
       xattr -p [-slz] attr_name file [file ...]
       xattr -w [-sz] attr_name attr_value file [file ...]
       xattr -d [-s] attr_name file [file ...]
       xattr -c [-s] file [file ...]

The first form lists the names of all xattrs on the given file(s).
The second form (-p) prints the value of the xattr attr_name.
The third form (-w) sets the value of the xattr attr_name to attr_value.
The fourth form (-d) deletes the xattr attr_name.
The fifth form (-c) deletes (clears) all xattrs.

options:
  -h: print this help
  -s: act on symbolic links themselves rather than their targets
  -l: print long format (attr_name: attr_value)
  -z: compress or decompress (if compressed) attribute value in zip format
```

Execute this command instead:

```bash
xattr -c /Applications/ChatMLX.app/*
```

If that doesn’t work, try running this command:

```bash
sudo xattr -d com.apple.quarantine /Applications/ChatMLX.app/
```

## Star History 🌟

[![Star History Chart](https://api.star-history.com/svg?repos=maiqingqiang/ChatMLX&type=Date)](https://star-history.com/#maiqingqiang/ChatMLX&Date)

[contributors-shield]: https://img.shields.io/github/contributors/maiqingqiang/ChatMLX.svg?style=for-the-badge

[contributors-url]: https://github.com/maiqingqiang/ChatMLX/graphs/contributors

[forks-shield]: https://img.shields.io/github/forks/maiqingqiang/ChatMLX.svg?style=for-the-badge

[forks-url]: https://github.com/maiqingqiang/ChatMLX/network/members

[stars-shield]: https://img.shields.io/github/stars/maiqingqiang/ChatMLX.svg?style=for-the-badge

[stars-url]: https://github.com/maiqingqiang/ChatMLX/stargazers

[issues-shield]: https://img.shields.io/github/issues/maiqingqiang/ChatMLX.svg?style=for-the-badge

[issues-url]: https://github.com/maiqingqiang/ChatMLX/issues

[license-shield]: https://img.shields.io/github/license/maiqingqiang/ChatMLX.svg?style=for-the-badge

[license-url]: https://github.com/maiqingqiang/ChatMLX/blob/main/LICENSE

<p align="right">(<a href="#readme-top">back to top</a>)</p>
