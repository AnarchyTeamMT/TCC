git clone --depth 1 https://github.com/minetest/minetest_game.git games/minetest_game

bash mods_download.sh

git clone --depth 1 https://github.com/minetest/irrlicht.git lib/irrlichtmt

cmake . -DRUN_IN_PLACE=TRUE
make -j$(nproc)

echo "TCC был скачан. Запустите его командой ./bin/minetest, или, непосредственно, перейдя в эту папку и запустив файл minetest. Удачного использования!"
