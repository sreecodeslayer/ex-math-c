CFLAGS= -g

HEADER_FILES = c_src
SOURCE_FILES = c_src/math.c

OBJECT_FILES = $(SOURCE_FILES:.c=.o)

priv_dir/math: clean priv_dir $(OBJECT_FILES)
	mkdir -p priv_dir
	$(CC) -I $(HEADER_FILES) -o $@ $(LDFLAGS) $(OBJECT_FILES) $(LDLIBS)

priv_dir:
	mkdir -p priv_dir

clean:
	rm -f priv_dir/math $(OBJECT_FILES) $(BEAM_FILES)
