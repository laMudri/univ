include ../prelude.mk ../tex.mk

clean::
	rm *.out

%.out: %.c
	gcc $< -o $@

s1.pdf:: s1.out
