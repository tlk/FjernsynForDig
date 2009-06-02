# Copyright (c) 2009  Thomas L. Kjeldsen
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


RELEASE=0.4


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

build/Noter.html:
	mkdir -p build/.hidden
	cp gfx/FjernsynForDig_dmg.png build/.hidden/
	cp source/style.css build/.hidden/
	sed -e s/#DMG#/FjernsynForDig-${RELEASE}.dmg/g -e s,#UPDATED#,`date +%D`, < source/index.tpl > build/Noter.html

FjernsynForDig.dmg: build/DR1.app build/DR2.app build/Noter.html
	ln -s /Applications build/Programmer
	cp source/ROOT_DS_STORE build/.DS_Store
	hdiutil create -srcfolder build -volname FjernsynForDig FjernsynForDig-${RELEASE}.dmg

FjernsynForDig-rw.dmg: FjernsynForDig.dmg
	hdiutil convert -format UDRW -o FjernsynForDig-rw.dmg FjernsynForDig-${RELEASE}.dmg

# Procedure to re-arrange icons:
# 1. build and mount FjernsynForDig-rw.dmg
# 2. re-arrange icons and folder settings with Finder
# 3. unmount and re-mount FjernsynForDig-rw.dmg
# 4. copy /Volumes/XYZ/.DS_Store to source/ROOT_DS_STORE

deploy:
	mkdir -p deploy
	cp -r build/.hidden deploy
	cp build/Noter.html deploy/index.html
	cp FjernsynForDig-${RELEASE}.dmg deploy
	scp deploy/* a:thomaslkjeldsen.dk/fjernsynfordig/
	scp -r deploy/.hidden a:thomaslkjeldsen.dk/fjernsynfordig/

clean:
	rm -rf build
	rm -f index.html
	rm -f FjernsynForDig-${RELEASE}.dmg
	rm -f FjernsynForDig-rw.dmg

