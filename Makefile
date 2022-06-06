ess_intro_r_slides: intro_r/slides.tex
	latexmk intro_r/slides.tex -pdf

clean:
	-rm -f *.aux
	-rm -f *.log
	-rm -f *.toc
	-rm -f *.bbl
	-rm -f *.blg
	-rm -f *.out
	-rm -f *.bcf
	-rm -f *.fdb_latexmk
	-rm -f *.fls
	-rm -f *.run.xml
	-rm -f *.nav
	-rm -f *.snm
	-rm -f code/.Rhistory
	-rm -f .Rhistory
	-rm -f Rplots.pdf
