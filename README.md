# PoShDualExplorers
Dueling Tabbed Windows File Explorers in PowerShell > Windows Forms

The gist of this approach is an innocent hack where Explorer.exe windows are launched and then User32.dll SetParent() is used to contain those windows inside a dual panel, tabbed UI.

![](https://1.bp.blogspot.com/-6g-Qt9mZPP8/Vx6LzJUMiMI/AAAAAAAAUAU/lrnjzdHq-JQ-LfHTFMUdHK1FlgGk3dD9wCLcB/s1600/Snap7.jpg)

# Features
* multiple File Explorer tabs on each side
* Copy/Move Left to Right command buttons (via [FontAwesome-WindowsForms project also on GitHub](https://github.com/denwilliams/FontAwesome-WindowsForms))
* Flip flop Left <=> Right path with each other
* naturally leverages any Shell extensions already available... e.g. [Link Shell Extension](http://schinagl.priv.at/nt/hardlinkshellext/linkshellextension.html), [FileMenu Tools](http://www.lopesoft.com/en/filemenutools), etc.
	* for example, this tool becomes my *photo filing* workspace when i download from our digicams... see [MOV to MP4 transcode script](http://www.beejblog.com/2015/11/transcode-iphone-mov-to-mp4-handbrake.html) as example "plugin"  
* wide open potential for additional "macro" buttons scripted via PowerShell
