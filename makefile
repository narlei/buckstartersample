cleanup:
	@-rm -rf ~/Library/Developer/Xcode/DerivedData
	@-rm -rf **/*.xcworkspace
	@-rm -rf **/*.xcodeproj
	@-rm -rf buck-out
	@-rm -rf .buckd
	@-BUCK clean
	@echo "Cleanup complete!"

xcode:
	@-BUCK project VeryCoolApp && open VeryCoolApp/VeryCoolApp.xcworkspace
	@echo "Project created!"

install:
	@-BUCK install  VeryCoolApp -n "iPhone 12" -r
	@echo "Installed, see your Simulator!"

test:
	@-BUCK test //VeryCoolLibrary -n "iPhone 12"

build:
	@-BUCK build //VeryCoolApp