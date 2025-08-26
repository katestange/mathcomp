PY?=
PELICAN?=pelican
PELICANOPTS=

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py


# Tailwind v4
CSS_IN    := assets/tw.css
CSS_OUT   := content/static/css/mathhub.css
TAILWIND  := ./tailwindcss-linux-x64
TW_URL    := https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64

DEBUG ?= 0
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
endif

RELATIVE ?= 0
ifeq ($(RELATIVE), 1)
	PELICANOPTS += --relative-urls
endif

SERVER ?= "0.0.0.0"

PORT ?= 0
ifneq ($(PORT), 0)
	PELICANOPTS += -p $(PORT)
endif


help:
	@echo 'Makefile for a pelican Web site                                           '
	@echo '                                                                          '
	@echo 'Usage:                                                                    '
	@echo '   make html                           (re)generate the web site          '
	@echo '   make clean                          remove the generated files         '
	@echo '   make regenerate                     regenerate files upon modification '
	@echo '   make publish                        generate using production settings '
	@echo '   make serve [PORT=8000]              serve site at http://localhost:8000'
	@echo '   make serve-global [SERVER=0.0.0.0]  serve (as root) to $(SERVER):80    '
	@echo '   make devserver [PORT=8000]          serve and regenerate together      '
	@echo '   make devserver-global               regenerate and serve on 0.0.0.0    '
	@echo '                                                                          '
	@echo 'Set the DEBUG variable to 1 to enable debugging, e.g. make DEBUG=1 html   '
	@echo 'Set the RELATIVE variable to 1 to enable relative urls                    '
	@echo '                                                                          '

html: css
	"$(PELICAN)" "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(CONFFILE)" $(PELICANOPTS)

clean:
	[ ! -d "$(OUTPUTDIR)" ] || rm -rf "$(OUTPUTDIR)"

regenerate:
	"$(PELICAN)" -r "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(CONFFILE)" $(PELICANOPTS)

serve:
	"$(PELICAN)" -l "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(CONFFILE)" $(PELICANOPTS)

serve-global:
	"$(PELICAN)" -l "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(CONFFILE)" $(PELICANOPTS) -b $(SERVER)

devserver:
	"$(PELICAN)" -lr "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(CONFFILE)" $(PELICANOPTS)

devserver-global:
	"$(PELICAN)" -lr "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(CONFFILE)" $(PELICANOPTS) -b 0.0.0.0

publish: css
	"$(PELICAN)" "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(PUBLISHCONF)" $(PELICANOPTS)


.PHONY: html help clean regenerate serve serve-global devserver devserver-global publish 


.PHONY: tailwind css watch-css

tailwind:
	@[ -x "$(TAILWIND)" ] || (echo "Downloading Tailwind CLI..." && curl -sL "$(TW_URL)" -o "$(TAILWIND)" && chmod +x "$(TAILWIND)")

css: tailwind
	@mkdir -p $(dir $(CSS_OUT))
	$(TAILWIND) -i $(CSS_IN) -o $(CSS_OUT) -m

watch-css: tailwind
	@mkdir -p $(dir $(CSS_OUT))
	$(TAILWIND) -i $(CSS_IN) -o $(CSS_OUT) --watch


# Deploy output/ to GitHub Pages (gh-pages branch) via ghp-import
.PHONY: _check-ghp github

_check-ghp:
	@command -v ghp-import >/dev/null 2>&1 || { \
		echo "ERROR: ghp-import not found. Install it in your venv:" >&2; \
		echo "  pip install ghp-import" >&2; \
		exit 1; \
	}

# Clean -> publish (prod build) -> push output/ to gh-pages and set it as Pages source
github: _check-ghp clean publish
	ghp-import -n -p "$(OUTPUTDIR)"
	@echo "Deployed to gh-pages. If first time, set Pages source to 'gh-pages / root' in GitHub → Settings → Pages."
