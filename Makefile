compile:
	rake clean
	rake compile
test:
	rake preview > ~/Desktop/racaptcha-test.gif && open ~/Desktop/racaptcha-test.gif
