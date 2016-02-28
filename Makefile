MSC_USER := minecraft
MSC_GROUP := minecraft
MSC_GUI_HOME := /opt/mscs/gui

.PHONY: install update clean

install: $(MSC_GUI_HOME) update
	chown -R $(MSC_USER):$(MSC_GROUP) $(MSC_GUI_HOME)

update:
	cp index.pl $(MSC_GUI_HOME)
	cp -R themes $(MSC_GUI_HOME)

clean:
	rm -R $(MSC_GUI_HOME)

$(MSC_GUI_HOME):
	mkdir -p -m 755 $(MSC_GUI_HOME)
