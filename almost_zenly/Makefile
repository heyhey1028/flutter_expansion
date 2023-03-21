clean_sample:
	flutter pub get
	cd ios && rm -rf Pods
	cd ios && rm -rf Podfile.lock
	cd ios && arch -x86_64 pod install
	flutter clean
	flutter pub get