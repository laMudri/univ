include ../prelude.mk ../tex.mk

clean::
	rm *.png

%.png: %.hs
	ghc -O2 $<
	./$(basename $<)

s2.pdf:: S2.png
s4.pdf:: S4.png S4a.png S4b.png S4c.png
