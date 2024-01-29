all: subdirs

# Subdirectories for building versions
SUBDIRS_M = Amiga Mac68k Plus4 modern_terminal MSDOS C128 CPM C64 VIC20 PET RC2014 CPC MSX Spectrum M20 CX16 SpectrumNext

.PHONY: subdirs $(SUBDIRS_M)

subdirs: $(SUBDIRS_M)

$(SUBDIRS_M):
	$(MAKE) -C $@
