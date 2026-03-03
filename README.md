<div align="center">

Discovery project
==

__The macOS fan app__

[![Actions Status](https://github.com/perseusrealdeal/arkenstone/actions/workflows/main.yml/badge.svg)](https://github.com/perseusrealdeal/arkenstone/actions/workflows/main.yml)
[![Style](https://github.com/perseusrealdeal/arkenstone/actions/workflows/swiftlint.yml/badge.svg)](https://github.com/perseusrealdeal/arkenstone/actions/workflows/swiftlint.yml)
[![Version](https://img.shields.io/badge/Version-2.4-green.svg)](/CHANGELOG.md)

[![Platforms](https://img.shields.io/badge/Platform-macOS%2010.13+-orange.svg)](https://en.wikipedia.org/wiki/MacOS_version_history)
[![Xcode](https://img.shields.io/badge/Xcode-14.2+-red.svg)](https://en.wikipedia.org/wiki/Xcode)
[![Swift](https://img.shields.io/badge/Swift-5-orange.svg)](https://docs.swift.org/swift-book/RevisionHistory/RevisionHistory.html)
[![SDK](https://img.shields.io/badge/SDK-UIKit%20-blueviolet.svg)](https://developer.apple.com/documentation/uikit)

[![ConsolePerseusLogger](http://img.shields.io/:ConsolePerseusLogger-1.7.1-green.svg)](https://github.com/perseusrealdeal/ConsolePerseusLogger.git)
[![PerseusDarkMode](http://img.shields.io/:PerseusDarkMode-2.2.0-green.svg)](https://github.com/perseusrealdeal/PerseusDarkMode.git)
[![PerseusGeoKit](http://img.shields.io/:PerseusGeoKit-1.2.1-green.svg)](https://github.com/perseusrealdeal/PerseusGeoKit.git)

[`A3 Environment`](/APPROBATION.md) • [`CHANGELOG`](/CHANGELOG.md) • [`Unlicense`](/LICENSE)

</div>

---

Contents
==

* [Announcement](#Announcement)
    * [Our terms](#Our-terms)
    * [The why](#The-why)
    * [Preview material](#Preview-material)
    * [Top features](#Top-features)
* [Requirements](#Requirements)
* [First-party software](#First-party-software)
* [Third-party software](#Third-party-software)
* [Account points](#Account-points)
* [License](#License)
    * [Other required licenses details](#Other-required-licenses-details)
* [Credits](#Credits)
* [Contributing](#Contributing)
* [Prepared by](#Prepared-by)
    * [Contact](#Contact)

---

Announcement
==

The fan macOS app in the Middle-earth theme with screens from the motion picture `The Hobbit` based on the novel by `J.R.R. Tolkien`.

Our Terms
--

| Acronym | Stands for                                                                                                |
| :-----: | --------------------------------------------------------------------------------------------------------- |
| CPL     | [Console_Perseus_Logger](https://github.com/perseusrealdeal/ConsolePerseusLogger.git)                     |
| PDM     | [Perseus_Dark_Mode](https://github.com/perseusrealdeal/PerseusDarkMode.git)                               |
| PGK     | [Perseus_Geo_Kit](https://github.com/perseusrealdeal/PerseusGeoKit.git)                                   |
| A3      | [Apple_Apps_Approbation](https://docs.google.com/document/d/1K2jOeIknKRRpTEEIPKhxO2H_1eBTof5uTXxyOm5g6nQ) |
| T3      | [The_Technological_Tree](https://github.com/perseusrealdeal/TheTechnologicalTree)                         |
| P2P     | Person_to_Person                                                                                          |

The why
--

> This app serves the only one purpose —— the first-party software approbation, but also and the third.

Preview material
--

<!--
> [!IMPORTANT]
> The next video recordered with `QuickTime Player` and than converted with ``. 

TODO: paste file convertor name and link
-->

![Hobbit](https://user-images.githubusercontent.com/50202963/214910458-781beb39-c6fe-4b73-b7df-eec9f1bfc708.gif)

> [!IMPORTANT]
> The screenshot scenes taken from the motion picture `The Hobbit` based on the novel by `J.R.R. Tolkien`.

<!--
> [!NOTE]
> If the app from an unidentified developer:

TODO: link to video
-->

Top features
--

- `Geo option:` Light, Dark, Auto
- `Dark Mode option:` Light, Dark, Auto

Requirements
==

`To build:`

- [macOS Monterey 12.7.6+](https://apps.apple.com/by/app/macos-monterey/id1576738294)
- [Xcode 14.2+](https://developer.apple.com/services-account/download?path=/Developer_Tools/Xcode_14.2/Xcode_14.2.xip)

First-party software
==

| Type     | Name                                                                                                      | License |
| -------- | --------------------------------------------------------------------------------------------------------- | :-----: |
| Package  | [ConsolePerseusLogger v1.7.1](https://github.com/perseusrealdeal/ConsolePerseusLogger/releases/tag/1.7.1) | MIT     |
| Package  | [PerseusDarkMode v2.2.0](https://github.com/perseusrealdeal/PerseusDarkMode/releases/tag/2.2.0)           | MIT     |
| Package  | [PerseusGeoKit v1.2.1](https://github.com/perseusrealdeal/PerseusGeoKit/releases/tag/1.2.1)               | MIT     |
| Class    | [MessageLabel](https://gist.github.com/PerseusRealDeal/dbfed6e01ed80be084983738ba713654)                  | MIT     |

Third-party software
==

| Type   | Name                                                                                  | License                            |
| ------ | ------------------------------------------------------------------------------------- | ---------------------------------- |
| Style  | [SwiftLint v0.57.0 Monterey+](https://github.com/realm/SwiftLint/releases/tag/0.57.0) | MIT                                |
| Action | [mxcl/xcodebuild@v3](https://github.com/mxcl/xcodebuild)                              | [Unlicense](https://unlicense.org) |
| Action | [cirruslabs/swiftlint-action@v1](https://github.com/cirruslabs/swiftlint-action/)     | MIT                                |

Account points 
==

- Explicit start point [main.swift](/Convertor/main.swift)
- Explicit app delegate [TestingAppDelegate.swift](/PerseusTests/TestingAppDelegate.swift)
- Explicit app globals [AppGlobals.swift](/Convertor/AppGlobals.swift)
- Architectural points: 
    - MVP applied. Based on [Gist](https://gist.github.com/PerseusRealDeal/5301e90881732f0cd0040e2083a78a3d)
- [Changelog](/CHANGELOG.md)
- [A3 environment specification](/APPROBATION.md)
- [GitHub CI build & test](/.github/workflows/main.yml)
- [GitHub CI SwiftLint](/.github/workflows/swiftlint.yml)
- [SwiftLint Rules](/.swiftlint.yml)
- [Git Config](/.gitignore)
- SwiftLint shell script as a build phase, SwiftLint preinstallation required

License
==

__Unlicensed Free Software__, see [LICENSE](/LICENSE) for details.

The project has been started in 7530 by `Mikhail A. Zhigulin of Novosibirsk`.<br/>

- The year starts from the creation of the world according to a Slavic calendar.
- September, the 1st of Slavic year. For instance, "Sep 01, 2025" is the beginning of 7534.

Other required licenses details
--

© Mikhail A. Zhigulin of Novosibirsk **for** ConsolePerseusLogger, PerseusDarkMode, PerseusGeoKit</br>
© PerseusRealDeal **for** ConsolePerseusLogger, PerseusDarkMode, PerseusGeoKit</br>
© 2025 The SwiftLint Contributors **for** SwiftLint</br>
© GitHub **for** GitHub Action cirruslabs/swiftlint-action@v1</br>

Credits
==

<table>
  <tr>
      <td>Balance and Control</td>
      <td>Mikhail Zhigulin</td>
  </tr>
  <tr>
      <td>Source Code</td>
      <td>Mikhail Zhigulin</td>
  </tr>
  <tr>
      <td>Documentation</td>
      <td>Mikhail Zhigulin</td>
  </tr>
  <tr>
      <td>Approbation</td>
      <td>Mikhail Zhigulin</td>
  </tr>
  <tr>
      <td>English</td>
      <td>Mikhail Zhigulin</td>
  </tr>
</table>

- Language support: [Reverso](https://www.reverso.net/) 
- Git clients: [SmartGit](https://syntevo.com/) and [GitHub Desktop](https://github.com/apps/desktop)

Contributing
==

> [!NOTE]
> The product is constructed in `P2P` relationship paradigm that means the only one single and the same face in the product team during all development process.

`Bug reports are welcome`, create an issue and give details.

Prepared by
==

> © Mikhail A. Zhigulin of Novosibirsk

Contact
--

<div align="center">

[E-mail](mailto:mzhigulin@gmail.com) • [Telegram](https://t.me/velociraptor1985) • [GitHub](https://github.com/perseusrealdeal)

</div>
