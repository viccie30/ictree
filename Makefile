#
# Copyright 2022 Nikita Ivanov
#
# This file is part of ictree
#
# ictree is free software: you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# ictree is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# ictree. If not, see <https://www.gnu.org/licenses/>.
#

include config.mk

SRC    := $(wildcard ${SRCDIR}/*.c)
OBJ    := ${SRC:${SRCDIR}/%.c=${BUILDDIR}/%.o}
DEP    := ${OBJ:.o=.d}
MAN    := ${DOCDIR}/ictree.1
GEN    := ${GENDIR}/options-msg.h
LOBJ   := ${TBOBJ}
BINTAR := ${BIN}.tar.gz

vpath %.c ${SRCDIR}

all: ${BIN}

options:
	@echo "CC      = $(CC)"
	@echo "CFLAGS  = $(CFLAGS)"
	@echo "LDFLAGS = $(LDFLAGS)"

generate:
	$(MAKE) --always-make ${GEN}

install: install.bin install.man

install.bin: ${BIN}
	install -d $(BINPREFIX)
	install $< $(BINPREFIX)

install.man: ${MAN}
	install -d $(MANPREFIX)/man1
	install -m 644 $< $(MANPREFIX)/man1

uninstall:
	$(RM) $(BINPREFIX)/${BIN}
	$(RM) $(MANPREFIX)/man1/$(notdir ${MAN})

clean:
	$(RM) ${BIN} ${OBJ} ${DEP} *.tar.gz *.zip
	$(MAKE) -C ${TBDIR} clean

dist: generate ${BINTAR}
	./archive.sh tar.gz
	./archive.sh zip

.PHONY: all options generate install install.bin install.man uninstall clean dist

${BIN}: ${OBJ} ${LOBJ}
	$(CC) -o $@ $(LDFLAGS) $+

${BUILDDIR}/%.o: %.c
	@mkdir -p ${@D}
	$(CC) -c -o $@ $(CFLAGS) -MD $<

${GENDIR}/options-msg.h:
	@mkdir -p ${@D}
	./gen-help.sh ${MAN} > $@

${TBOBJ}:
	$(MAKE) -C ${TBDIR} termbox.o

${BINTAR}: clean
	$(MAKE) CC=musl-gcc LDFLAGS=-static ${BIN}
	tar -czf $@ ${BIN}

-include ${DEP}

.DELETE_ON_ERROR:
