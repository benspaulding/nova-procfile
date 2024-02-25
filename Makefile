NODE_MODULES := node_modules
VENV_DIR := .venv
VENV_BIN := $(VENV_DIR)/bin
DIST_DIR := dist

PKG_DIR := .
PKG_FILES := LICENSE README.md

SRC_DIR := src
SRC_FILES := $(subst $(SRC_DIR)/,,$(filter-out %.ts,$(wildcard $(addprefix $(SRC_DIR)/,* */* */*/*))))

EXT_DIR := $(DIST_DIR)/Procfile.novaextension
EXT_PKG_FILES := $(addprefix $(EXT_DIR)/,$(PKG_FILES))
EXT_SRC_FILES := $(addprefix $(EXT_DIR)/,$(SRC_FILES))
EXT_FILES := $(EXT_PKG_FILES) $(EXT_SRC_FILES)

.PHONY : all
all : $(EXT_FILES) tsc $(VENV_DIR)/pyvenv.cfg
	$(VENV_BIN)/pre-commit run --all

$(EXT_PKG_FILES) : $(EXT_DIR)/% : $(PKG_DIR)/% | $(EXT_DIR)
	cp -r $< $@

$(EXT_SRC_FILES) : $(EXT_DIR)/% : $(SRC_DIR)/% | $(EXT_DIR)
	cp -r $< $@

$(EXT_DIR): | $(DIST_DIR)
	mkdir $(EXT_DIR)

$(DIST_DIR) :
	mkdir $(DIST_DIR)

.PHONY : tsc
tsc : $(NODE_MODULES) | $(EXT_DIR)
	npm run compile

package-lock.json : package.json

$(NODE_MODULES) : package-lock.json
	npm install

.PHONY : dev
dev : all
	npm run watch
	# TODO: Run npm watch as well as a watch for the files packaged with this Makefile.

$(VENV_DIR)/pyvenv.cfg :
	python -m venv $(VENV_DIR)
	$(VENV_BIN)/python -m pip install -U --upgrade-strategy=eager pip setuptools wheel
	$(VENV_BIN)/python -m pip install pre-commit==3.6.2
	$(VENV_BIN)/pre-commit install --install-hooks

.PHONY : cleanall
cleanall : cleandist cleanmeta

.PHONY : cleandist
cleandist :
	rm -rf $(DIST_DIR)

.PHONY : cleanmeta
cleanmeta :
	rm -rf $(VENV_DIR) $(NODE_MODULES)
