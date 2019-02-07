# UPTEthereumSigner

Ethereum signer framework for iOS.

This framework is part of the [**uPort** SDK](https://github.com/uport-project/uport-ios-sdk).

## Getting Started

Like other parts of the **uPort** iOS SDK, this frameworks uses [Carthage](https://github.com/Carthage/Carthage) as dependency manager. We chose Carthage over [CocoaPods](https://cocoapods.org) because it's simple and nonintrusive.

### Installing Carthage

If you have [Homebrew (also known as Brew)](https://brew.sh) installed on your macOS machine, just run:

```console
brew install carthage
```

Otherwise, you could download and install the latest [`Cathage.pkg`](https://github.com/Carthage/Carthage/releases).

### Get Dependencies and Build

Now that you have Carthage installed, run the following command (from the root directory of this repository):

```console
carthage update --platform iOS --no-use-binaries --cache-builds
```

This command is also available from the included `build` script. So alternatively you can run:

```console
./build
```

This git-clones the repositories this framework depends on, and subsequently builds them as iOS frameworks.

### Using Build Result

The result of the Carthage build is in directory `Carthage/Build/iOS` which contains: `CoreEth.framework`, `openssl.framework`, and `Valet.framework`.

You need to add these frameworks to your app. See the [**uPort demo app README](https://github.com/uport-project/uport-ios-demo/blob/master/README.md) for a detailed description of how to do that.

## Authors

Joshua Bell, joshua.bell@consensys.net
Cornelis van der Bent, cornelis@meaning-matters.com

## License

UPTEthereumSigner is available under the [Apache License](LICENSE.md).
