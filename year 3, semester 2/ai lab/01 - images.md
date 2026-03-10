---
related to:
created: 2026-03-06, 16:15
updated: 2026-03-06T16:52
completed: false
---
## generating colours
generally speaking there are two ways of mixing colors:
- *additive method*: starting from black, adding red, green and blue to get the desired colour
	- used for digital images ! (screen is black, using this method we “save energy)
- *subtractive method*: starting from white, subtracting cyan, magenta and yellow to get the desired colour
	- used for painting or printing (paper and canvases are white)

images can be see as functions

there are several ways to represent the intensity of a pixel:
- binary
	- used to get specific information about the image (filtering, masking)
- greyscale
	- each pixel is a value of grey (luminance !)
- indexed
	- only used for GIFs basically. there is a fixed list of available colors, the *palette* (e.g. 256 colors are available in a GIF file)
- color
	- 3 values 4 each pixel !
	- $256^3$ colours available !
	- depth of the pixel is the number of channels !
		- for example, PNG images allow a transparent background, that is handled through the *alpha channel*, in the range `[0,1]`