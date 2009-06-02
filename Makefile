# Copyright (c) 2009  Thomas L Kjeldsen
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.


RELEASE=0.3


default: clean FjernsynForDig.dmg

make-build-dirs:
	mkdir -p build

build/DR1.app: make-build-dirs
	mkdir -p build/DR1.app/Contents/MacOS
	mkdir -p build/DR1.app/Contents/Resources/
	cp source/DR1.icns build/DR1.app/Contents/Resources
	sed s/#MONOTONICALLY_INCREASED#/${RELEASE}-`date +%s`/ < source/DR1.plist > build/DR1.app/Contents/Info.plist
	cp source/DR1.sh build/DR1.app/Contents/MacOS
	chmod +x build/DR1.app/Contents/MacOS/*.sh
	echo "APPLFjFD" > build/DR1.app/Contents/PkgInfo

build/DR2.app: make-build-dirs
	mkdir -p build/DR2.app/Contents/MacOS
	mkdir -p build/DR2.app/Contents/Resources/
	cp source/DR2.icns build/DR2.app/Contents/Resources
	sed s/#MONOTONICALLY_INCREASED#/${RELEASE}-`date +%s`/ < source/DR2.plist > build/DR2.app/Contents/Info.plist
	cp source/DR2.sh build/DR2.app/Contents/MacOS
	chmod +x build/DR2.app/Contents/MacOS/*.sh
	echo "APPLFjFD" > build/DR2.app/Contents/PkgInfo

FjernsynForDig.dmg: build/DR1.app build/DR2.app
	ln -s /Applications build/Programmer
	cp source/Noter.rtf build/
	cp source/ROOT_DS_STORE build/.DS_Store
	hdiutil create -srcfolder build -volname FjernsynForDig FjernsynForDig-${RELEASE}.dmg

FjernsynForDig-rw.dmg: FjernsynForDig.dmg
	hdiutil convert -format UDRW -o FjernsynForDig-rw.dmg FjernsynForDig-${RELEASE}.dmg

clean:
	rm -rf build
	rm -rf FjernsynForDig-${RELEASE}.dmg
	rm -rf FjernsynForDig-rw.dmg

deploy:
	scp FjernsynForDig-${RELEASE}.dmg a:thomaslkjeldsen.dk/fjernsyn/
	ssh a 'sed -e s/#DMG#/FjernsynForDig-${RELEASE}.dmg/g -e s/#DATE#/`LC_ALL=da_DK.ISO8859-1 date +%v`/ < ./thomaslkjeldsen.dk/fjernsyn/index.tpl > ./thomaslkjeldsen.dk/fjernsyn/index.html'

