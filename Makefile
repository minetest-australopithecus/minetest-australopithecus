deps := deps
mods := mods
release := release

all: release

clean:
	$(RM) -R $(release)

.PHONY: update-deps
update-deps:
	git submodule foreach git pull origin master
	git add deps/
	git commit -m "Updated dependencies."

.PHONY: release
release:
	mkdir -p $(release)/australopithecus/
	
	mkdir -p $(release)/australopithecus/mods/
	
	cp game.conf $(release)/australopithecus/
	cp minetest.conf $(release)/australopithecus/
	
	cp LICENSE $(release)/australopithecus/
	cp LICENSE.textures $(release)/australopithecus/
	cp README $(release)/australopithecus/
	
	cp -R $(deps)/artisanry/mods/artisanry $(release)/australopithecus/mods/
	cp -R $(deps)/spawn-usher/mods/spawn_usher $(release)/australopithecus/mods/
	cp -R $(deps)/utils/utils $(release)/australopithecus/mods/
	cp -R $(deps)/voice/mods/voice $(release)/australopithecus/mods/
	cp -R $(deps)/worldgen/mods/worldgen $(release)/australopithecus/mods/
	cp -R $(deps)/worldgen-utils/mods/worldgen_utils $(release)/australopithecus/mods/
	
	cp -R $(mods)/core $(release)/australopithecus/mods/
	cp -R $(mods)/mapgen $(release)/australopithecus/mods/
	cp -R $(mods)/torch $(release)/australopithecus/mods/
	
	tar -c --xz -C $(release) -f $(release)/australopithecus.tar.xz australopithecus/
	tar -c --gz -C $(release) -f $(release)/australopithecus.tar.gz australopithecus/
	
	cd release; zip -r -9 australopithecus.zip australopithecus; cd -
	
