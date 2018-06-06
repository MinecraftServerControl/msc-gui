MSC_USER := minecraft
MSC_GROUP := minecraft
MSC_GUI_HOME := /opt/mscs/gui
MSC_GUI_SERVICE := /etc/systemd/system/msc-gui.service

.PHONY: install update clean

install: $(MSC_GUI_HOME) update
	chown -R $(MSC_USER):$(MSC_GROUP) $(MSC_GUI_HOME)
	systemctl -f enable msc-gui.service;

update:
	install -m 0755 msc-gui $(MSC_GUI_HOME)
	install -m 0644 msc-gui.service $(MSC_GUI_SERVICE);
	cp -R public $(MSC_GUI_HOME)
	cp -R templates $(MSC_GUI_HOME)

clean:
	systemctl -f disable msc-gui.service;
	rm -R $(MSC_GUI_HOME)

$(MSC_GUI_HOME):
	mkdir -p -m 755 $(MSC_GUI_HOME)
