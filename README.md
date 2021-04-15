# Buck starter example
This project will help you to start a project using [Buck build system](https://buck.build/).

## Mindset
The first think is change your mindset, buck is NOT a Xcode project generator, it IS a **build system**!
Of course, buck generates Xcode project, but, if is only what you want, use other tools.

## Setup
What you’ll install:
- Command line tools;
- Java 8;
- Buck;

I recommend you use [HomeBrew](https://brew.sh/).

To install [The command line tools](https://developer.apple.com/xcode/features/):
`xcode-select —install`

Buck is written in Java, then you will need to install Java in your machine.
Not, let’s install Java using [AdoptOpenJDK](https://github.com/AdoptOpenJDK/homebrew-openjdk):
```
brew tap AdoptOpenJDK/openjdk
brew install --cask adoptopenjdk8
```

Let’s install buck now:
```
brew tap facebook/fb
brew install buck
```

If you receive a error like
 `Error: /usr/local/Cellar/buck/2021.01.12.01 is not a directory`  Run  `brew link buck`

For the last step, run:
`brew install watchman`

You can see the complete guide [here](https://buck.build/setup/getting_started.html).

## Let’s buck!
Before use Buck, I recommend you read [this article](https://medium.com/@lcsmarcal/compilando-um-aplicativo-ios-sem-xcode-e2ea34cfa7f0). Will help you to understand how a .app or .ipa is generated.

### Understanding the structure
The most benefit of Buck is modularization. Then, stop to think in your app as a BIG code, start to think in a LOT of small parts of code.
Each module need to work “alone”, with dependencies of course, but you need to can use the module in other app without bring all other modules.

Each module need a **BUCK** file. It’s a file without extension named **BUCK**.
In this file you will teach buck how build the module.

### Config
To use buck, some default configs are needed. See the file `.buckconfig` . This file contains the default configs and some paths needed.

### App module

To generate a .app, or using the correct term, a Bundle, you need a Binary.
A Binary is an executable file with your code. And pay attention here, a saw your CODE. Assets, xibs and storyboards aren’t code!

Go to **VeryCoolApp/BUCK**. You’ll see a code like this:

```
apple_binary(
    name = “VeryCoolAppBinary”,
    visibility = [“PUBLIC”],
    srcs = glob([‘**/*.swift’]),
    ...
    is_main_run_destination = True,
)
```

The command `apple_binary`  will generate a binary (oh a Sherlock Holmes here…).
This binary by self  don’t do anything, you will need to put it inside a Bundle.

```
apple_bundle(
    name = “VeryCoolApp”,
    visibility = [“PUBLIC”],
    extension = “app”,
    binary = “:VeryCoolAppBinary”,
    product_name = “VeryCoolApp”,
    info_plist = “Info.plist”,
    ... 
)
```

Finally, the Bundle is the app! A Bundle is in resume a folder that contains all compiled sources.

All of parameters you can find at [buck documentation](https://buck.build/rule/apple_bundle.html).

“Ok, but my app have assets and xibs and storyboards, where I put it?”

As I saw before, BUCK file is how we teach buck to build our files.  Let’s see how compile assets:

```
apple_asset_catalog(
    name = “VeryCoolAppAssets”,
    visibility = [“PUBLIC”],
    dirs = [“Media.xcassets”],
)
```

After added the `apple_asset_catalog` to your buck file, you need use it as dependency in your app:

```
apple_binary(
    name = “VeryCoolAppBinary”,
    visibility = [“PUBLIC”],
    srcs = glob([‘**/*.swift’]),
    deps = [“:VeryCoolAppAssets”],
)
```

Ok, next step is compile de xibs and storyboards, the resources:

```
apple_resource(
    name = “VeryCoolAppResources”,
    visibility = [“PUBLIC”],
    files = glob([
        “**/*.xib”
    ]),
)
```

If you need to compile storyboards too, just add to `files` . Now, let’s use it as dependency:

```
apple_binary(
    name = “VeryCoolAppBinary”,
    visibility = [“PUBLIC”],
    srcs = glob([‘**/*.swift’]),
    deps = [“:VeryCoolAppResources”,
            “:VeryCoolAppAssets”],
)
```

**Congratulations!!!** Now, buck can build your app! Try make: `buck build VeryCoolApp`