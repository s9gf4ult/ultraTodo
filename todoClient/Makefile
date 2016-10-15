INSTALL_ROOT:=$(shell stack path --local-install-root)


js-build/todo.js: $(INSTALL_ROOT)/bin/todoClient.jsexe/all.js
	mkdir -p js-build
	echo "(function(global,React,ReactDOM) {" > js-build/todoClient.js
	cat $(INSTALL_ROOT)/bin/todoClient.jsexe/all.js >> js-build/todoClient.js
	echo "})(window, window['React'], window['ReactDOM']);" >> js-build/todoClient.js
	# sed -i 's/goog.provide.*//' js-build/todoClient.js
	# sed -i 's/goog.require.*//' js-build/todoClient.js
