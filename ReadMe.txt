
(1)	Download TVP project from repository
(2)	Download Xcode9.1 or later version
	https://developer.apple.com/xcode/
(3)	Unzip TVP folder

(4)	Steps for create “TVPFramework.framework”

	-	Open framework project , TVP -> Framework -> TVPFramework -> and double click on “TVPFramework.xcodeproj”
	-	Select “Generic iOS Device”
	-	Run “TVPFramework” project.
	-	When build succeeded, Open TVPFramework project in folder structure and copy “TVPFramework.framework”

(5) 	How to use “TVPFramework.framework” in iOS project

	-	Open framework project , TVP -> Demo Project -> TVPagePhase2 -> and double click on “TVPagePhase2.xcodeproj”
	-	Drag and drop “TVPFramework.framework” in Framework folder
	-	Resources folder path : TVP -> Resources -> TVPResources.bundle
	- 	Drag and drop “TVPResources.bundle” in Framework folder

(6)	Framework add in Embedded Binaries
	-	Select project -> Select targets -> General -> Select Embedded Binaries -> tapped on “+”  button, and select “TVPFramework.framework” and add this framework.

(7)	Use TVPFramework
	- 	import TVPFramework in ViewController

(8)	Use SidebarView
	
	let sidebarView = SidebarView.init(frame: CGRect(x: 0, y: 0, width: 375, height: 500))
	self.view.addSubview(sidebarView)

(9)	Use SoloView
	
	let soloView = SoloView.init(frame: CGRect(x: 0, y: 0, width: 375, height: 500))
	self.view.addSubview(soloView)

(10)	Use CarouselView
	
	let carouselView = CarouselView.init(frame: CGRect(x: 0, y: 0, width: 375, height: 500))
	self.view.addSubview(carouselView)

(11)	Set Properties

	sidebarView.items_per_row = 2
	sidebarView.items_title_padding = 10
	sidebarView.items_title_background = .black
	sidebarView.items_title_font_family = “Arial”