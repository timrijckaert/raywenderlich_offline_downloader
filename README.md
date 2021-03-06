# Raywenderlich Downloader
Use this tool to generate a script that you can use to download [Raywenderlich](https://www.raywenderlich.com) videos and materials (zips) for offline use. 

### Usage

You can find a prebuild executable in the `release/` folder.  
No pipeline at the moment.

```
./rwl -u 'firstname.lastname@emailprovider.com' -p 'password' 'https://www.raywenderlich.com/4001741-swiftui'
```

This will generate a `bash` script that makes use of [youtube-dl](https://github.com/ytdl-org/youtube-dl) for downloading the actual streams.  

An output file will look like this:

```
#!/bin/sh
youtube-dl -o 'course/1_introduction.%(ext)s' https://player.vimeo.com/external/357115696.m3u8
youtube-dl -o 'course/2_swiftui_vs._uikit.%(ext)s' https://player.vimeo.com/external/357115704.m3u8
youtube-dl -o 'course/3_challenge:_making_a_programming_to-do_list.%(ext)s' https://player.vimeo.com/external/357115706.m3u8
...
```

You can also export to a `json` file if you want.

Execute this script to actually start the download.  

## Options

```
-u, --username                     Provide your Raywenderlich email address.
-p, --password                     Provide your Raywenderlich password address
-o, --output
          [json]                   Export to JSON
          [youtubedl] (default)    Makes a bash script with the help of Youtubedl and curl

-m, --[no-]materials               Whether you want to fetch the links to the materials.
                                   (defaults to on)
```

## Build it yourself
Make sure you have the Dart tools installed.  

To build a self contained executable, run:

```
pub get
dart2native bin/main.dart -o release/[linux|mac]/rwl
```
