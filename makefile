cleanup:
	@-rm -rf ~/Library/Developer/Xcode/DerivedData
	@-rm -rf **/*.xcworkspace
	@-rm -rf **/*.xcodeproj
	@-rm -rf buck-out
	@-rm -rf .buckd
	@-buck clean
	@echo "Cleanup complete!"

xcode:
	@-buck project VeryCoolApp && open VeryCoolApp/VeryCoolApp.xcworkspace
	@echo "Project created!"

install:
	@-buck install VeryCoolApp -n "iPhone 12" -r
	@echo "Installed, see your Simulator!"

test:
	@-buck test //VeryCoolLibrary -n "iPhone 12"

build:
	@-buck build //VeryCoolApp
