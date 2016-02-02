/*
 * ROI Overlap 
 * 
 * Count the number of ROI in one Channel located in the other Channel.
 * 
 * The input is an 2D hyper-stack with ROIs already defined 
 * in the ROI Manager. The ROI have the 0000-0000-0000 name pattern.
 * 
 */


macro "ROI Overlap" {
	
	if (nImages == 0) {
		createTest();
	}
	
	// Get user input
	Dialog.create("Deblur");
	Dialog.addNumber("Reference channel", 1);
	Dialog.addNumber("Object channel", 2);
	Dialog.show();
	b = Dialog.getNumber();
	a = Dialog.getNumber();
	
	setBatchMode(true);	
	ra = getRoiInChannel(a);
	rb = getRoiInChannel(b);	
	counts = countRoiOverlap(b, a);
	setBatchMode(false);
	
	// save the distance in the results table	
	for (i = 0; i  < rb.length; i++) {
		roiManager("select", rb[i]);
		setResult("ROI Index", i, rb[i]);
		setResult("ROI Name", i, Roi.getName);
		setResult("Number", i, counts[i]);
	}
	updateResults();
}


function createTest() {
	newImage("HyperStack", "8-bit color-mode", 400, 300, 2, 1, 1);
	makeOval(44, 38, 133, 143);
	roiManager("Add");
	makeOval(215, 139, 157, 153);
	roiManager("Add");
	Stack.setChannel(2);
	makeOval(95, 56, 10, 12);
	roiManager("Add");
	makeOval(118, 77, 14, 13);
	roiManager("Add");
	makeOval(67, 112, 13, 8);
	roiManager("Add");
	makeOval(95, 127, 12, 14);
	roiManager("Add");
	makeOval(126, 119, 21, 18);
	roiManager("Add");
	makeOval(288, 161, 17, 18);
	roiManager("Add");
	makeOval(317, 197, 13, 14);
	roiManager("Add");
	makeOval(257, 203, 10, 11);
	roiManager("Add");
	makeOval(271, 240, 16, 14);
	roiManager("Add");
	roiManager("Show All");
}

// counts the number of region "b" in each region "a"
function countRoiOverlap(a, b) {	
	ra = getRoiInChannel(a);
	rb = getRoiInChannel(b);	
	counts = newArray(ra.length);
	for (i = 0; i < ra.length; i++) {
		for (j = 0; j < rb.length; j++) {
			if (hasRoi(ra[i], rb[j]) == true) {				
				counts[i] = counts[i] + 1;
			}
		}
	}
	return counts;
}

// return true if the R1 contrains R2
function hasRoi(r1, r2) {
	ret = false;
	roiManager("select", r2);
	Roi.getCoordinates(x, y);
	roiManager("select", r1);	
	for (i = 0; i < x.length; i++) {
		if (Roi.contains(x[i], y[i])) {
			ret = true;
		}
	}
	return ret;
}

// Counts the number of region in a Channel c
// Assumes that the name of the ROI starts with 000c
// This is the case when using an hyper stack
function getRoiInChannel(c){
	index = newArray(0);
	for (n = 0; n < roiManager("count"); n++) {
		roiManager("select", n);	
		if (matches(Roi.getName, "000" + c + "-.*")) {
			index = arrayPushBack(index, n);
		}
	}
	return index;
}

// Push back  a value in the array "a"
function arrayPushBack(a, value) {
	if (a.length == 0) {
		a = newArray(1);
		a[0] = value;
	} else {
		b = newArray(1);
		b[0] = value;
		a = Array.concat(a, b);			
	}
	return a;
}
