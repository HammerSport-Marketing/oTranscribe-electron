build_dev:
	$(MAKE) compile_static

	# empty manifest
	cp src/manifest-dev.appcache electron/manifest.appcache
	echo "# Updated $(shell date +%x_%H:%M:%S:%N)" >> dist/manifest.appcache
	
	# run webpack
	./node_modules/webpack/bin/webpack.js --watch -d

compile_static:
	# clear out existing dist folder
	rm -rf ./electron
	mkdir ./electron

	# compile l10n files
	for f in src/l10n/*.ini; do (cat "$${f}"; echo) >> electron/data.ini; done
	
	# copy over static assets
	cp -r src/img src/opensource.htm src/help.htm electron/
	cp ./node_modules/jakecache/dist/jakecache.js ./node_modules/jakecache/dist/jakecache-sw.js electron/
	mkdir electron/help
	mv electron/help.htm electron/help/index.html	

build_prod:
	$(MAKE) compile_static

	# manifest
	cp -r src/manifest.appcache electron/

	echo "# Updated $(shell date +%x_%H:%M:%S:%N)" >> electron/manifest.appcache
	
	# run webpack
	./node_modules/webpack/bin/webpack.js -p

	# cp -r lib/ electron/
	cp lib/main.js electron/main.js
	cp lib/renderer.js electron/render.js