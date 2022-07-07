git clone --depth 1 https://github.com/minetest/minetest_game.git games/minetest_game

bash mods_download.sh

git clone --depth 1 https://github.com/minetest/irrlicht.git lib/irrlichtmt

cmake . -DRUN_IN_PLACE=TRUE
make -j$(nproc)

./bin/minetest
