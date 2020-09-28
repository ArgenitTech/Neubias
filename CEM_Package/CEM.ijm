// This Computer-assisted Evaluation of Myelination (CEM; pronunciation /jem/) is developed by Bilal E. Kerman 
// and Krishnan Padmanabhan under Fred H. Gage's guidance at the Salk Institute in La Jolla, CA, USA
// The ImageJ code is written by B.E.K. and MATLAB code is written by K.P.
// All functions are detailed in the Users' Guide - and any questions can be sent to bkerman@gmail.com
// CEM is provided as part of the fair use license.  Any use of it for scientific publication should include
// the reference 
// 
// Kerman, BE., Kim HJ., Padmanabhan, K., Mei, A., Georges, S., Joens, MS., Fitzpatrick, JAJ., Japelli, R., Chandross, K.,
// August, P., and Gage, FH. In vitro myelination using embryonic stem cells. Submitted.


requires("1.47i");

setBackgroundColor(0, 0, 0);
setForegroundColor(255, 255, 255);

MBP=0;
Axon=0;
OverlapT=0;
OverlapP=0;
OverlapN=0;
SubsetPAxons=0;
SubsetNAxons=0;

continueG = true;
continueF = true;

MarkerD=false;
OverlapD=false;

function SplitChn() {
	continueF = true;

	//Explain the tool
	t1 = "This tool is designed for splitting multi-channel images such as lsm files, composite Tiffs or jpeg\n";
	t2 = "files into single channel images. It accepts any RGB or composite file that ImageJ can open. It\n";
	t3 = "saves each channel as a new Tiff image. \n";
	t4 = "Press OK when you are ready to start.";

	waitForUser("CEM v1.0 - Split Channels", t1+t2+t3+t4);

	while (continueF==true) {
		//Close all open images
		while (nImages>0) { 
		          selectImage(nImages); 
		          close(); 
		} 
		SplitIMG = File.openDialog("Open image to split channels");
		open (SplitIMG);

		if (is("composite")==true) {
			run("Split Channels");
			while (nImages>0) { 
				saveAs("Tiff");
				close();
			}
		}
		else {
			if (bitDepth()==24) {
				run("Split Channels");
				while (nImages>0) { 
					saveAs("Tiff");
					close();
				}
			}
			else {
				AnotherIMG = getBoolean("The image is already a single channel image.\nDo you want to convert another image?");
				if (AnotherIMG==false)
					MainMenu();
				else
				SplitChn();
			}
     		}

		continueF = getBoolean("Do you want to split more images?");
		if (continueF==false)
			MainMenu();
		
	} //while continue

} //SplitChn

function ConvertToBinary() {
	continueF = true;

	//Explain the tool
	t1 = "This tool converts single channel images into binary for myelin quantification.\n";
	t2 = "It is crucial that you follow the steps explained in the next window.\n";
	t3 = "Press OK when you are ready to start.";

	waitForUser("CEM v1.0 - Generate Binary Images", t1+t2+t3);

	run("Color Balance...");
	
	while (continueF==true) {
		//Close all open images
		while (nImages>0) { 
		          selectImage(nImages); 
		          close();
		}

		BinaryPath = File.openDialog("Open image to convert to binary");
		open (BinaryPath);
		getDimensions(width, height, channels, slices, frames);

		if (channels>1) {
			continueF = getBoolean("The image has more than one channel.\nPlease first split the channels first.\nDo you want to convert another image?");
			close(); 
     		}
		else {
			if (is("binary")) {
				continueF = getBoolean("The image is already a binary image.\nDo you want to convert another image?");
				close(); 
	     		}
			
				else {
					t1 = "Adjust the minimum and maximum values, select the reference slice.\n";
					t2 = "First press 'Apply'. Then press 'OK'.\n";
					t3 = "You can move this window but do not press 'OK' until you applied minimum\n";
					t4 = "and maximum values and selected the reference slice.\n";
					t5 = "The minimum and maximum values as well as the reference slice you select\n";
					t6 = "makes a difference in the final results. The rest of the stack is converted by\n";
					t7 = "referencing this slice. Select a slice that has a large amount of signal to noise\n";
					t8 = "ratio. You may try a few different settings and choose the one that gives you\n"; 
					t9 = "the best results. We recommend that you record the slice you selected and the\n";
					t10 = "minimum and maximum values you set for consistency and future repeatability.\n";
					t11 = "Press OK when the image is at the appropriate slice and the minimum and\n";
					t12 = "maximum values are set.\n";
	
		 			waitForUser("CEM v1.0 - Instructions to Generate Binary Images", t1+t2+t3+t4+t5+t6+t7+t8+t9+t10+t11+t12);
					
					run("Make Binary", "method=IsoData background=Dark thresholded remaining");
					run("Grays");
					
					//Save as TIFF with binary added to the title or choose a different name and/or location
					rename ("CEM_Binary-"+getTitle());
					saveAs("Tiff");

					continueF = getBoolean("Do you want to convert more images?");
				}
		} //channel split	
			if (continueF==false)
				MainMenu();

		
	}

} //ConvertToBinary

function CBR() {
	continueF = true;

	while (continueF==true) {
		ID="Untitled";

		//Close all open images
		while (nImages>0) { 
		          selectImage(nImages); 
		          close(); 
		} 

		//Dialog box
		d1 = "This tool is the first step to remove overlap signal associated with the\n";
		d2 = "cell bodies. By identifying nuclei of oligodendrocytes and/or neuons. It\n";
		d3 = "prepares your files for the MATLAB Toolbox.\n";
		d4 = "The 'Identifier' is used to name your files while saving.\n";
		d5 = " \n"+"Follow the window titles to open the correct image.\n";
		d6 = " \n"+"Select whose nuclei you would like to identify.\n";

		Dialog.create("CEM v1.0 - Identify nuclei for cell body removal");
		Dialog.addMessage(d1+d2+d3+d4+d5+d6);
		Dialog.addString("Identifier:", ID);
		Dialog.addCheckbox("Oligodendrocytes", true);
		Dialog.addCheckbox("Neurons", false);
		Dialog.addCheckbox("Exit to main menu", false);

		Dialog.show();
		ID = Dialog.getString();
		OligosD = Dialog.getCheckbox();
		AxonsD = Dialog.getCheckbox();
		ExitD  = Dialog.getCheckbox();

		if (ExitD==true)
			MainMenu();

		//Get path myelin binary image
		if (OligosD==true) {
			OligosPath = File.openDialog("Open Binary Oligodendrocytes image");
		}

		//Get path axons binary image
		if (AxonsD==true) {
			AxonsPath = File.openDialog("Open Binary Axons image");
		}

		//Open nuclear marker binary image
			NucleusPath = File.openDialog("Open Binary Nuclei image");
			do {
				IFbinary=false;
				open (NucleusPath);
				getDimensions(width, height, channels, slices, frames);

				if (channels>1) {
					AnotherIMG = getBoolean("The Nuclei image has more than one channel.\nDo you want to open another image?");
					if (AnotherIMG==false)
						MainMenu();
					close;
					NucleusPath = File.openDialog("Open Binary Nuclei image");				
     				}
				else {

					if (is("binary")) {
						IFbinary=true;
					}
					else {
						AnotherIMG = getBoolean("The Nuclei image is not a binary image.\nDo you want to open another image?");
						if (AnotherIMG==false)
							MainMenu();
						close();
						NucleusPath = File.openDialog("Open Binary Nuclei image");	
		     			 } 
				} // else channels
			} while (IFbinary==false);	
			NucleusB = getTitle();

		//Open oligodendrocyte binary images and identify nuclei
		if (OligosD==true) {
			do {
				IFbinary=false;
				open (OligosPath);
				getDimensions(width, height, channels, slices, frames);

				if (channels>1) {
					AnotherIMG = getBoolean("The Oligodendrocytes image has more than one channel.\nDo you want to open another image?");
					if (AnotherIMG==false)
						MainMenu();
					close;
					OligosPath = File.openDialog("Open Binary Oligodendrocytes image");
					open (OligosPath);
	     			}
				else {
					if (is("binary")) {
						IFbinary=true;
					}
					else {
						AnotherIMG = getBoolean("The Oligodendrocytes image is not a binary image.\nDo you want to open another image?");
						if (AnotherIMG==false)
							MainMenu();
						close();
						OligosPath = File.openDialog("Open Binary Oligodendrocytes image");	
			     		 } 
				} //channels
			} while (IFbinary==false);
			OligosB = getTitle();
			
			imageCalculator('and stack create', OligosB, NucleusB);
			run("Despeckle", "stack");
			run("Invert", "stack");
			run("Watershed", "stack");
			run("Invert", "stack");
			rename ("CEM_OligoNuclei-"+ID);
			saveAs("Tiff");

		}//oligos

		//Open axon binary images and identify nuclei
		if (AxonsD==true) {
			do {
				IFbinary=false;
				open (AxonsPath);
				getDimensions(width, height, channels, slices, frames);

				if (channels>1) {
					AnotherIMG = getBoolean("The Axons image has more than one channel.\nDo you want to open another image?");
					if (AnotherIMG==false)
						MainMenu();
					close;
					AxonsPath = File.openDialog("Open Binary Axons image");	
					open (AxonsPath);
	     			}
				else {
					if (is("binary")) {
						IFbinary=true;
					}
					else {
						AnotherIMG = getBoolean("The Axons image is not a binary image.\nDo you want to open another image?");
						if (AnotherIMG==false)
							MainMenu();
						close();
						AxonsPath = File.openDialog("Open Binary Axons image");	
			     		 } 
				} // channels
			} while (IFbinary==false);
			AxonsB = getTitle();
			
			imageCalculator('and stack create', AxonsB, NucleusB);
			run("Despeckle", "stack");
			run("Invert", "stack");
			run("Watershed", "stack");
			run("Invert", "stack");
			rename ("CEM_NeuronsNuclei-"+ID);
			saveAs("Tiff");

		}//axons

		continueF = getBoolean("Do you want to identify nuclei of another image?");
	}
	waitForUser("Reminder", "Don't forget to run the accompanying MATLAB routine to convert nuclei to cell bodies."); 
	MainMenu();
} //CBR

function Myelin() {
	continueF = true;

	while (continueF==true) {
		ID="Untitled";

		//Close all open images
		while (nImages>0) { 
		          selectImage(nImages); 
		          close(); 
		} 

		//Dialog box
		d1 = "This tool identifies myelin and calculates results without removing\n";
		d2 = "cell bodies. The 'Identifier' is used to name your files while saving.\n";
		d3 = " \n"+"Follow the window titles to open the correct image.\n";
		d4 = " \n";
		d5 = "Check the box if you would like to include a subset of axons.\n";

		Dialog.create("CEM v1.0 - Calculate myelin without removing cell bodies");
		Dialog.addMessage(d1+d2+d3+d4+d5);
		Dialog.addString("Identifier:", ID);
		Dialog.addCheckbox("Axon subset", false);
		Dialog.addCheckbox("Exit to main menu", false);

		Dialog.show();
		ID = Dialog.getString();
		SubsetD = Dialog.getCheckbox();
		ExitD  = Dialog.getCheckbox();
		OligosD = true;
		AxonsD = true;

		if (ExitD==true)
			MainMenu();
		
		//Get path myelin binary image
		if (OligosD==true) {
			OligosPath = File.openDialog("Open Binary Oligodendrocytes image");
		}
	
		//Get path axons binary image
		if (AxonsD==true) {
			AxonsPath = File.openDialog("Open Binary Axons image");
		}

		//Get path axons subset binary image
		if (SubsetD==true) {
			if (AxonsD==false) {
				waitForUser("Error", "You have to load Axons images.");
				Myelin ();
			 } // if axons
			SubsetPath = File.openDialog("Open Binary Axon subsets image");
		}

		//Open oligodendrocyte binary images
		if (OligosD==true) {
			do {
				IFbinary=false;
				open (OligosPath);
				getDimensions(width, height, channels, slices, frames);

				if (channels>1) {
					AnotherIMG = getBoolean("The Oligodendrocytes image has more than one channel.\nDo you want to open another image?");
					if (AnotherIMG==false)
						MainMenu();
					close;
					OligosPath = File.openDialog("Open Binary Oligodendrocytes image");
					open (OligosPath);
	     			}
				else {
					if (is("binary")) {
						IFbinary=true;
					}
					else {
						AnotherIMG = getBoolean("The Oligodendrocytes image is not a binary image.\nDo you want to open another image?");
						if (AnotherIMG==false)
							MainMenu();
						close();
						OligosPath = File.openDialog("Open Binary Oligodendrocytes image");	
			     		 } 
				} //channels
			} while (IFbinary==false);

			rename ("CEM_OLs-"+ID);
			OligosB = getTitle();

			SliceNumber=nSlices;
			if (SliceNumber > 1)
				run("Z Project...", "start=1 stop=SliceNumber projection=[Max Intensity]");
			getHistogram(values, counts, 256);
			MBP=counts[255];
			MAXOligosB = getTitle();
		} //open oligos

		//Open axon binary image
		if (AxonsD==true) {
			do {
				IFbinary=false;
				open (AxonsPath);
				getDimensions(width, height, channels, slices, frames);

				if (channels>1) {
					AnotherIMG = getBoolean("The Axons image has more than one channel.\nDo you want to open another image?");
					if (AnotherIMG==false)
						MainMenu();
					close;
					AxonsPath = File.openDialog("Open Binary Axons image");	
					open (AxonsPath);
	     			}
				else {
					if (is("binary")) {
					IFbinary=true;
					}
					else {
						AnotherIMG = getBoolean("The Axons image is not a binary image.\nDo you want to open another image?");
						if (AnotherIMG==false)
							MainMenu();
						close();
						AxonsPath = File.openDialog("Open Binary Axons image");	
     					 } 
				} //channels
			} while (IFbinary==false);	

			rename ("CEM_Axons-"+ID);
			AxonsB = getTitle();

			SliceNumber=nSlices;
			if (SliceNumber > 1)
				run("Z Project...", "start=1 stop=SliceNumber projection=[Max Intensity]");
			getHistogram(values, counts, 256);
			Axon=counts[255];
			MAXAxonsB = getTitle();
		} //open axons

		//Open subset of axons positive for a marker (i.e GFP) binary image
		if (SubsetD==true) {
			do {
				IFbinary=false;
				open (SubsetPath);
				getDimensions(width, height, channels, slices, frames);

				if (channels>1) {
					AnotherIMG = getBoolean("The Axon subsets image has more than one channel.\nDo you want to open another image?");
					if (AnotherIMG==false)
						MainMenu();
					close;
					SubsetPath = File.openDialog("Open Binary Axon subsets image");
					open (SubsetPath);
	     			}
				else {
					if (is("binary")) {
					IFbinary=true;
					}
					else {
						AnotherIMG = getBoolean("The Axon subsets image is not a binary image.\nDo you want to open another image?");
						if (AnotherIMG==false)
							MainMenu();
						close();
						SubsetPath = File.openDialog("Open Binary Axon subsets image");	
     					 } 
				} // channels
			} while (IFbinary==false);
			SubsetB = getTitle();
		} //open subset

		path = File.directory;

		//Calculate all axons overlap
		if (OligosD==true) {
			if (AxonsD==true) {

				OverlapD=true;

				imageCalculator('and stack create', OligosB, AxonsB);
				rename ("CEM_Overlap_All-"+ID);
				OverlapTB = getTitle();
		
				SliceNumber=nSlices;
				if (SliceNumber > 1)
					run("Z Project...", "start=1 stop=SliceNumber projection=[Max Intensity]");
				getHistogram(values, counts, 256);
				OverlapT=counts[255];
				MAXOverlapTB = getTitle();

			}
		}

		//Calculate marker positive and negative axons
		if (SubsetD==true) {
			if (AxonsD==true) {

				MarkerD=true;

				//Marker + axons
				imageCalculator('and stack create', SubsetB, AxonsB);
				rename ("CEM_Marker_Pos_Axons-"+ID);
				SubsetPAxonsB=getTitle();
		
				SliceNumber=nSlices;
				if (SliceNumber > 1)
					run("Z Project...", "start=1 stop=SliceNumber projection=[Max Intensity]");
				getHistogram(values, counts, 256);
				SubsetPAxons=counts[255];
				MAXSubsetPAxonsB=getTitle();

				//Marker - axons
				selectImage(SubsetPAxonsB); 
				run("Invert", "stack");

				imageCalculator('multiply stack create', SubsetPAxonsB, AxonsB);
				rename ("CEM_Marker_Neg_Axons-"+ID);
				SubsetNAxonsB=getTitle();

				SliceNumber=nSlices;
				if (SliceNumber > 1)
					run("Z Project...", "start=1 stop=SliceNumber projection=[Max Intensity]");
				getHistogram(values, counts, 256);
				SubsetNAxons=counts[255];
				MAXSubsetNAxonsB=getTitle();
			} //if axons

			//Calculate overlap
			if (OligosD==true) {
				//Calculate Marker + axons overlap
				selectImage(SubsetPAxonsB); 
		
				run("Invert", "stack");

				imageCalculator('and stack create', SubsetPAxonsB, OligosB);
				rename ("CEM_Overlap-Marker_Pos_Axons-"+ID);
				OverlapPB=getTitle();
		
				SliceNumber=nSlices;
				if (SliceNumber > 1)
					run("Z Project...", "start=1 stop=SliceNumber projection=[Max Intensity]");
				getHistogram(values, counts, 256);
				OverlapP=counts[255];
				MAXOverlapPB=getTitle();

				//Calculate Marker - axons overlap
				imageCalculator('and stack create', SubsetNAxonsB,OligosB);
				rename ("CEM_Overlap-Marker_Neg_Axons-"+ID);
				OverlapNB=getTitle();
		
				SliceNumber=nSlices;
				if (SliceNumber > 1)
					run("Z Project...", "start=1 stop=SliceNumber projection=[Max Intensity]");
				getHistogram(values, counts, 256);
				OverlapN=counts[255];
				MAXOverlapNB=getTitle();
			} //if oligos
		} //if subset

	//Print results

	title1 = "CEM_Results-"+ID+".txt";
	title2 = "["+title1+"]";
	f = title2;

	if (isOpen(title1))
		print(f, "\\Update:"); // clears the window
	else {
		run("Text Window...", "name="+title2+" width=150 height=30");
	}

	print(f, "Pixel counts without removal of cell bodies:\n");
	print(f, "Total Oligodendrocytes: "+MBP+" pixels\n");
	print(f, "Total Axons: "+Axon+" pixels\n\n");

	print(f, "Myelin of all axons: "+OverlapT+" pixels\n");
	print(f, "Ratio of all axons that is myelinated: "+(OverlapT/Axon*100)+"%\n");
	print(f, "(Myelin is defined as overlap between axons and oligodendrocyte.)\n\n");


	if (MarkerD==true) {

	print(f, "Marker positive Axons: "+SubsetPAxons+" pixels\n");
	print(f, "Marker negative Axons: "+SubsetNAxons+" pixels\n\n");

	print(f, "Myelin of Marker positive axons: "+OverlapP+" pixels\n");
	print(f, "Ratio of Marker positive axons that is myelinated: "+(OverlapP/SubsetPAxons*100)+"%\n\n");

	print(f, "Myelin of Marker negative  axons: "+OverlapN+" pixels\n");
	print(f, "Ratio of Marker positive axons that is myelinated: "+(OverlapN/SubsetNAxons*100)+"%\n");
	print(f, "(Myelin is defined as overlap between calculated marker positive or negative axons and oligodendrocyte.)");
	}

	selectWindow(title1); 
	saveAs("Text");
	path = File.directory;

	//Save results
	saveR = getBoolean("Do you want to save created images?");

	if (saveR==true) {
		if (OligosD==true) {
			selectImage(OligosB); 
			SliceNumber=nSlices;
			close();
			if (SliceNumber > 1) {
				selectImage(MAXOligosB);
				save(path+"MAX-"+OligosB+".tiff");
				close();
			}
		}

		if (AxonsD==true) {
			selectImage(AxonsB); 
			SliceNumber=nSlices;
			close();
			if (SliceNumber > 1) {
				selectImage(MAXAxonsB);
				save(path+"MAX-"+AxonsB+".tiff");
				close();
			}
		}

		if (OverlapD==true) {
			selectImage(OverlapTB); 
			save(path+OverlapTB+".tiff");
			SliceNumber=nSlices;
			close();
			if (SliceNumber > 1) {	
				selectImage(MAXOverlapTB);
				save(path+"MAX-"+OverlapTB+".tiff");
				close();		
			}
		}
	
		if (MarkerD==true) {
			selectImage(SubsetPAxonsB); 
			save(path+SubsetPAxonsB+".tiff");
			SliceNumber=nSlices;
			close();
			if (SliceNumber > 1) {
				selectImage(MAXSubsetPAxonsB);
				save(path+"MAX-"+SubsetPAxonsB+".tiff");
				close();
			}

			selectImage(SubsetNAxonsB); 
			save(path+SubsetNAxonsB+".tiff");
			SliceNumber=nSlices;
			close();
			if (SliceNumber > 1) {
				selectImage(MAXSubsetNAxonsB);
				save(path+"MAX-"+SubsetNAxonsB+".tiff");
				close();
			}

			selectImage(OverlapPB); 
			save(path+OverlapPB+".tiff");
			SliceNumber=nSlices;
			close();
			if (SliceNumber > 1) {
				selectImage(MAXOverlapPB);
				save(path+"MAX-"+OverlapTB+".tiff");
				close();
			}

			selectImage(OverlapNB); 
			save(path+OverlapNB+".tiff");;
			SliceNumber=nSlices;
			close();
			if (SliceNumber > 1) {
				selectImage(MAXOverlapNB);
				save(path+"MAX-"+OverlapNB+".tiff");
				close();
			}
		} //marker
	} //saveR

	//Close all open images
	while (nImages>0) { 
	          selectImage(nImages); 
		close(); 
      	} 

	continueF = getBoolean("Do you want to calculate myelin on another image set");
		
	}
	MainMenu();

}//Myelin

function CBRMyelin() {
	continueF = true;

	while (continueF==true) {
		ID="Untitled";

		//Close all open images
		while (nImages>0) { 
		          selectImage(nImages); 
		          close(); 
		} 

		//Dialog box
		d1 = "This tool identifies myelin and calculates results after removing\n";
		d2 = "cell bodies. The 'Identifier' is used to name your files while saving.\n";
		d3 = "Note that you need cell body images of oligodendrocytes and/or\n";
		d4 = "axons as outputs from the MATLAB but not of axon subsets.";
		d5 = " \n"+"Follow the window titles to open the correct image.\n";
		d6 = " \n"+"Check the box if you would like to include a subset of axons.\n";


		Dialog.create("CEM v1.0 - Calculate myelin after removing cell bodies");
		Dialog.addMessage(d1+d2+d3+d4+d5+d6);
		Dialog.addString("Identifier:", ID);
		Dialog.addCheckbox("Axon subset", false);
		Dialog.addMessage("Select from which you want to remove cell bodies");
		Dialog.addCheckbox("Oligodendrocytes", true);
		Dialog.addCheckbox("Axons", false);
		Dialog.addCheckbox("Exit to main menu", false);

		Dialog.show();
		ID = Dialog.getString();
		SubsetD = Dialog.getCheckbox();
		OligosD = Dialog.getCheckbox();
		AxonsD = Dialog.getCheckbox();
		ExitD  = Dialog.getCheckbox();

		if (ExitD==true)
			MainMenu();
		
		//Get path myelin binary image
		OligosPath = File.openDialog("Open Binary Oligodendrocytes image");

		if (OligosD==true)
			NucleiOPath = File.openDialog("Open Cell Bodies of Oligodendrocytes image");
			
		//Get path axons binary image
		AxonsPath = File.openDialog("Open Binary Axons image");

		if (AxonsD==true)
			NucleiAPath = File.openDialog("Open Cell Bodies of Axons image");

		//Get path subset axons binary image
		if (SubsetD==true)
			SubsetPath = File.openDialog("Open Binary Axon subsets image");

		//Open oligodendrocyte binary images and remove cell bodies
			do {
				IFbinary=false;
				open (OligosPath);
				getDimensions(width, height, channels, slices, frames);

				if (channels>1) {
					AnotherIMG = getBoolean("The Oligodendrocytes image has more than one channel.\nDo you want to open another image?");
					if (AnotherIMG==false)
						MainMenu();
					close;
					OligosPath = File.openDialog("Open Binary Oligodendrocytes image");
					open (OligosPath);
	     			}
				else {
					if (is("binary")) {
						IFbinary=true;
					}
					else {
						AnotherIMG = getBoolean("The Oligodendrocytes image is not a binary image.\nDo you want to open another image?");
						if (AnotherIMG==false)
							MainMenu();
						close();
						OligosPath = File.openDialog("OPen Binary Oligodendrocytes image");	
			     		 } 
				} //channels
			} while (IFbinary==false);
			OligosB = getTitle();

		if (OligosD==true) {
			do {
				IFbinary=false;
				open (NucleiOPath);
				getDimensions(width, height, channels, slices, frames);

				if (channels>1) {
					AnotherIMG = getBoolean("The Cell Bodies of Oligodendrocytes image has more than one channel.\nDo you want to open another image?");
					if (AnotherIMG==false)
						MainMenu();
					close;
					NucleiOPath = File.openDialog("Open Cell Bodies of Oligodendrocytes image");	
					open (NucleiOPath);
	     			}
				else {
					if (is("binary")) {
						IFbinary=true;
					}
					else {
						AnotherIMG = getBoolean("The Cell Bodies of Oligodendrocyte image is not a binary image.\nDo you want to open another image?");
						if (AnotherIMG==false)
							MainMenu();
						close();
						NucleiOPath = File.openDialog("Open Cell Bodies of Oligodendrocytes image");	
			     		 } 
				} // channels
			} while (IFbinary==false);
			NucleiOB = getTitle();

			run("Invert", "stack");

			imageCalculator('multiply stack create', OligosB, NucleiOB);
			rename ("CEM_CBR_OLs-"+ID);

			CBR_OligosB = getTitle();

			SliceNumber=nSlices;
			if (SliceNumber > 1)
				run("Z Project...", "start=1 stop=SliceNumber projection=[Max Intensity]");
			getHistogram(values, counts, 256);
			MBP=counts[255];
			MAXCBR_OligosB = getTitle();
		} // oligos
		else {
			selectImage(OligosB);
			rename ("CEM_OLs-"+ID);
			CBR_OligosB = getTitle();

			SliceNumber=nSlices;
			if (SliceNumber > 1)
				run("Z Project...", "start=1 stop=SliceNumber projection=[Max Intensity]");
			getHistogram(values, counts, 256);
			MBP=counts[255];
			MAXCBR_OligosB = getTitle();
			OligosD=true;	
		}// oligos else

		//Open axon binary image and remove nuclei
			do {
				IFbinary=false;
				open (AxonsPath);
				getDimensions(width, height, channels, slices, frames);

				if (channels>1) {
					AnotherIMG = getBoolean("The Axons image has more than one channel.\nDo you want to open another image?");
					if (AnotherIMG==false)
						MainMenu();
					close;
					AxonsPath = File.openDialog("Open Binary Axons image");	
					open (AxonsPath);
	     			}
				else {
					if (is("binary")) {
						IFbinary=true;
					}
					else {
						AnotherIMG = getBoolean("The Axons image is not a binary image.\nDo you want to open another image?");
						if (AnotherIMG==false)
							MainMenu();
						close();
						AxonsPath = File.openDialog("Open Binary Axons image");	
			     		 } 
				} // channels
			} while (IFbinary==false);	
			AxonsB = getTitle();

		if (AxonsD==true) {
			do {
				IFbinary=false;
				open (NucleiAPath);
				getDimensions(width, height, channels, slices, frames);

				if (channels>1) {
					AnotherIMG = getBoolean("The Cell Bodies of Axons image has more than one channel.\nDo you want to open another image?");
					if (AnotherIMG==false)
						MainMenu();
					close;
					NucleiAPath = File.openDialog("Open Cell Bodies of Axons image");	
					open (NucleiOPath);
	     			}
				else {
					if (is("binary")) {
						IFbinary=true;
					}
					else {
						AnotherIMG = getBoolean("The Cell Bodies of Axons image is not a binary image.\nDo you want to open another image?");
						if (AnotherIMG==false)
							MainMenu();
						close();
						NucleiAPath = File.openDialog("Open Cell Bodies of Axons image");	
			     		 } 
				} // channels
			} while (IFbinary==false);
			NucleiAB = getTitle();

			run("Invert", "stack");

			imageCalculator('multiply stack create', AxonsB, NucleiAB);
			rename ("CEM_CBR_Axons-"+ID);
			CBR_AxonsB = getTitle();

			SliceNumber=nSlices;
			if (SliceNumber > 1)
				run("Z Project...", "start=1 stop=SliceNumber projection=[Max Intensity]");
			getHistogram(values, counts, 256);
			Axon=counts[255];
			MAXCBR_AxonsB = getTitle();		
		} // axons
		else {
			selectImage(AxonsB);
			rename ("CEM_Axons-"+ID);
			CBR_AxonsB = getTitle();

			SliceNumber=nSlices;
			if (SliceNumber > 1)
				run("Z Project...", "start=1 stop=SliceNumber projection=[Max Intensity]");
			getHistogram(values, counts, 256);
			Axon=counts[255];
			MAXCBR_AxonsB = getTitle();
			AxonsD=true;
		} //axons else

		//Open subset of axons positive for a marker (i.e GFP) binary image
		if (SubsetD==true) {
			do {
				IFbinary=false;
				open (SubsetPath);
				if (is("binary")) {
				IFbinary=true;
				}
				else {
					AnotherIMG = getBoolean("The Axon subsets image is not a binary image.\nDo you want to open another image?");
					if (AnotherIMG==false)
						MainMenu();
					close();
					SubsetPath = File.openDialog("Open Binary Axon subsets image");	
     				 } 
			} while (IFbinary==false);
			SubsetB = getTitle();
		} //open subset

		path = File.directory;

		//Calculate all axons overlap
		if (OligosD==true) {
			if (AxonsD==true) {

				OverlapD=true;

				imageCalculator('and stack create', CBR_OligosB, CBR_AxonsB);
				rename ("CEM_CBR-Overlap_All-"+ID);
				CBR_OverlapTB = getTitle();
		
				SliceNumber=nSlices;
				if (SliceNumber > 1)
					run("Z Project...", "start=1 stop=SliceNumber projection=[Max Intensity]");
				getHistogram(values, counts, 256);
				OverlapT=counts[255];
				MAXCBR_OverlapTB = getTitle();

			}
		}

		//Calculate marker positive and negative axons
		if (SubsetD==true) {
			if (AxonsD==true) {

				MarkerD=true;

				//Marker + axons
				imageCalculator('and stack create', SubsetB, CBR_AxonsB);
				rename ("CEM_CBR_Marker_Pos_Axons-"+ID);
				SubsetPAxonsB=getTitle();
		
				SliceNumber=nSlices;
				if (SliceNumber > 1)
					run("Z Project...", "start=1 stop=SliceNumber projection=[Max Intensity]");
				getHistogram(values, counts, 256);
				SubsetPAxons=counts[255];
				MAXSubsetPAxonsB=getTitle();

				//Marker - axons
				selectImage(SubsetPAxonsB); 
				run("Invert", "stack");

				imageCalculator('multiply stack create', SubsetPAxonsB, CBR_AxonsB);
				rename ("CEM_CBR_Marker_Neg_Axons-"+ID);
				SubsetNAxonsB=getTitle();

				SliceNumber=nSlices;
				if (SliceNumber > 1)
					run("Z Project...", "start=1 stop=SliceNumber projection=[Max Intensity]");
				getHistogram(values, counts, 256);
				SubsetNAxons=counts[255];
				MAXSubsetNAxonsB=getTitle();
			} //if axons

			//Calculate overlap
			if (OligosD==true) {
				//Calculate Marker + axons overlap
				selectImage(SubsetPAxonsB); 
		
				run("Invert", "stack");

				imageCalculator('and stack create', SubsetPAxonsB, CBR_OligosB);
				rename ("CEM_CBR_Overlap-Marker_Pos_Axons-"+ID);
				CBR_OverlapPB=getTitle();
		
				SliceNumber=nSlices;
				if (SliceNumber > 1)
					run("Z Project...", "start=1 stop=SliceNumber projection=[Max Intensity]");
				getHistogram(values, counts, 256);
				OverlapP=counts[255];
				MAXCBR_OverlapPB=getTitle();

				//Calculate Marker - axons overlap
				imageCalculator('and stack create', SubsetNAxonsB,CBR_OligosB);
				rename ("CEM_CBR_Overlap-Marker_Neg_Axons-"+ID);
				CBR_OverlapNB=getTitle();
		
				SliceNumber=nSlices;
				if (SliceNumber > 1)
					run("Z Project...", "start=1 stop=SliceNumber projection=[Max Intensity]");
				getHistogram(values, counts, 256);
				OverlapN=counts[255];
				MAXCBR_OverlapNB=getTitle();
			} //if oligos
		} //if subset


	//Print results

	title1 = "CEM_CBR_Results-"+ID+".txt";
	title2 = "["+title1+"]";
	f = title2;

	if (isOpen(title1))
		print(f, "\\Update:"); // clears the window
	else {
		run("Text Window...", "name="+title2+" width=150 height=30");
	}

	print(f, "Pixel counts after removal of cell bodies:\n");
	print(f, "Total Oligodendrocytes: "+MBP+" pixels\n");
	print(f, "Total Axons: "+Axon+"pixels\n\n");

	print(f, "Myelin of all axons: "+OverlapT+" pixels\n");
	print(f, "Ratio of all axons that is myelinated: "+(OverlapT/Axon*100)+"%\n");
	print(f, "(Myelin is defined as overlap between axons and oligodendrocyte.)\n\n");


	if (MarkerD==true) {

	print(f, "Marker positive Axons: "+SubsetPAxons+" pixels\n");
	print(f, "Marker negative Axons: "+SubsetNAxons+" pixels\n\n");

	print(f, "Myelin of Marker positive axons: "+OverlapP+" pixels\n");
	print(f, "Ratio of Marker positive axons that is myelinated: "+(OverlapP/SubsetPAxons*100)+"%\n\n");

	print(f, "Myelin of Marker negative  axons: "+OverlapN+" pixels\n");
	print(f, "Ratio of Marker positive axons that is myelinated: "+(OverlapN/SubsetNAxons*100)+"%\n");
	print(f, "(Myelin is defined as overlap between calculated marker positive or negative axons and oligodendrocyte.)");
	}

	selectWindow(title1); 
	saveAs("Text");
	path = File.directory;

	//Save results
	saveR = getBoolean("Do you want to save created images?");

	if (saveR==true) {
		if (OligosD==true) {
			selectImage(CBR_OligosB); 
			save(path+CBR_OligosB+".tiff");
			SliceNumber=nSlices;
			close();
			if (SliceNumber > 1) {
				selectImage(MAXCBR_OligosB);
				save(path+"MAX-"+CBR_OligosB+".tiff");
				close();
			}
		}

		if (AxonsD==true) {
			selectImage(CBR_AxonsB); 
			save(path+CBR_AxonsB+".tiff");
			SliceNumber=nSlices;
			close();
			if (SliceNumber > 1) {
				selectImage(MAXCBR_AxonsB);
				save(path+"MAX-"+CBR_AxonsB+".tiff");
				close();
			}
		}

		if (OverlapD==true) {
			selectImage(CBR_OverlapTB); 
			save(path+CBR_OverlapTB+".tiff");
			SliceNumber=nSlices;
			close();
			if (SliceNumber > 1) {	
				selectImage(MAXCBR_OverlapTB);
				save(path+"MAX-"+CBR_OverlapTB+".tiff");
				close();		
			}
		}
	
		if (MarkerD==true) {
			selectImage(SubsetPAxonsB); 
			save(path+SubsetPAxonsB+".tiff");
			SliceNumber=nSlices;
			close();
			if (SliceNumber > 1) {
				selectImage(MAXSubsetPAxonsB);
				save(path+"MAX-"+SubsetPAxonsB+".tiff");
				close();
			}

			selectImage(SubsetNAxonsB); 
			save(path+SubsetNAxonsB+".tiff");
			SliceNumber=nSlices;
			close();
			if (SliceNumber > 1) {
				selectImage(MAXSubsetNAxonsB);
				save(path+"MAX-"+SubsetNAxonsB+".tiff");
				close();
			}

			selectImage(CBR_OverlapPB); 
			save(path+CBR_OverlapPB+".tiff");
			SliceNumber=nSlices;
			close();
			if (SliceNumber > 1) {
				selectImage(MAXCBR_OverlapPB);
				save(path+"MAX-"+CBR_OverlapTB+".tiff");
				close();
			}

			selectImage(CBR_OverlapNB); 
			save(path+CBR_OverlapNB+".tiff");;
			SliceNumber=nSlices;
			close();
			if (SliceNumber > 1) {
				selectImage(MAXCBR_OverlapNB);
				save(path+"MAX-"+CBR_OverlapNB+".tiff");
				close();
			}
		} //marker
	} //saveR

	//Close all open images
	while (nImages>0) { 
	          selectImage(nImages); 
		close(); 
      	} 

	continueF = getBoolean("Do you want to calculate myelin on another image set");
		
	}
	MainMenu();
} //CBRMyelin

function Help () {
	
	//Dialog box
	h1 = "Computer-assisted Evaluation of Myelination (CEM; pronunciation /jem/), is a set of \n";
	h2 = "tools designed for automation of myelin identification and quantification. CEM is \n";
	h3 = "developed by Bilal E. Kerman and Krishnan Padmanabhan under Fred H. Gage's\n";
	h4 = "guidance at the Salk Institute in La Jolla, CA, USA. CEM is provided as part of the\n";
	h5 = "fair use license. Please reference Kerman et al. (submitted).\n";
	h6 = "More information is available in the accompanying Users’ Guide.\n";
	h7 = "The Main Menu has five tools and the MATLAB Toolbox is part of the tool set.\n";
	h8 = " Select the tool you want more help on.\n";
	
	Dialog.create("CEM v1.0 - Help");
	Dialog.addMessage(h1+h2+h3+h4+h5+h6+h7+h8);
	Dialog.addCheckbox("Split Channels: Splits multi-channel images into single channel images.", false);
	Dialog.addCheckbox("Generate Binary Images: Converts single channel images into binary.", false);
	Dialog.addCheckbox("Identify nuclei for cell body removal: Identifies nuclei of oligodendrocytes and/or neurons.", false);
	Dialog.addCheckbox("MATLAB Toolbox 'CEM_ToolBOX_v1_1.m': Removes noise and generates cell bodies.", false);
	Dialog.addCheckbox("Calculate myelin without removing cell bodies: Identifies myelin and calculates results.", false);
	Dialog.addCheckbox("Calculate myelin after removing cell bodies: Identifies myelin and calculates results.", false);
	Dialog.addCheckbox("Exit to main menu", false);

	Dialog.show();
	SplitD = Dialog.getCheckbox();
	BinaryD = Dialog.getCheckbox();
	CBRD = Dialog.getCheckbox();
	MATLABD = Dialog.getCheckbox();
	MyelinD = Dialog.getCheckbox();
	CBRMyelinD = Dialog.getCheckbox();
	ExitD  = Dialog.getCheckbox();

	if (ExitD==true)
		MainMenu();

	if (SplitD==true) {
		h1 = "This tool is designed for splitting multi-channel images such as lsm files, composite Tiffs or jpeg\n";
		h2 = "files into single channel images. It accepts any RGB or composite file that ImageJ can open. It\n";
		h3 = "saves each channel as a new Tiff image. \n";

		HelpText = h1+h2+h3;
		waitForUser("CEM v1.0 - Help: Split Channels", HelpText);
		Help();
	}

	if (BinaryD==true) {
		h1 = "This tool converts single channel images into binary. You will be asked to adjust brightness\n";
		h2 = "by setting minimum and maximum values for your image and select a reference slice. It is\n";
		h3 = "crucial that you set brightness to maximize signal-to-noise ratio and press ‘Apply’. If you have\n";
		h4 = "image stacks, you need to bring your stack to the reference slice before pressing “OK.” The\n";
		h5 = "reference slice is used by the ImageJ binary conversion algorithm to determine values for the\n";
		h6 = "rest of the stack. Therefore, it is crucial to select a slice with a large amount of positive signal\n";
		h7 = "and low background noise. We suggest that you try a few different settings until you identify.\n";
		h8 = "the optimum ones and that you record your settings.\n";

		HelpText = h1+h2+h3+h4+h5+h6+h7+h8;
		waitForUser("CEM v1.0 - Help: Generate Binary Images", HelpText);
		Help();
	}

	if (CBRD==true) {
		h1 = "This tool removes overlap signal associated with the cell bodies. This is a two-step process.\n";
		h2 = "First, you need to find the nuclei of the cells you are interested in. Next, you will use the\n";
		h3 = "MATLAB Toolbox to grow them into cell bodies.\n";
		h4 = "The ‘Identifier’ is used for naming your images. It can be any combination of letters, numbers\n";
		h5 = "and symbols that are allowed in a file name such as ‘Exp1-Image1’. Start by opening your\n";
		h6 = "binary images of oligodendrocytes and/or neurons and nuclei (outputs of ‘Generate Binary\n";
		h7 = "Images’ tool or generated by other sources). Follow the window titles to open the correct\n";
		h8 = "image. CEM will save images of nuclei with the Identifier in the title.\n";
		h9 = "Next, open these files with the accompanying MATLAB Toolbox, CEM_ToolBOX. It removes\n";
		h10 = "particles smaller than a preferred pixel area (for example, 50 pixels square) and grows the\n";
		h11 = "remaining nuclei into cell bodies by a preferred number of pixels (for example, 5 pixels). \n";

		HelpText = h1+h2+h3+h4+h5+h6+h7+h8+h9+h10+h11;
		waitForUser("CEM v1.0 - Help: Identify nuclei for cell body removal", HelpText);
		Help();
	}

	if (MATLABD==true) {
		h1 = "The MATLAB Toolbox removes particles smaller than a preferred pixel area (for example, 50 pixels\n";
		h2 = "square) and grows the remaining nuclei into cell bodies by a preferred number of pixels (for example,\n";
		h3 = "5 pixels). Follow the instructions in the Users’ Guide for installation and setup. The toolbox is launched\n";
		h4 = " by typing CEM_ToolBOX_v1_1 in the command line of MATLAB. First, a file is loaded by clicking on\n";
		h5 = "the LOAD button. Once the file has loaded, it will appear as an image in the image window, and the VIEW\n";
		h6 = "original toggle box will be checked. If the file is a grayscale image or RGB image, it will appear as such.\n";
		h7 = "If the file is a tif stack, it will appear as a maximum intensity Z projection in the viewer. The user has the\n";
		h8 = "ability to select different combinations of operations include, exclude only, dilate one, exclude first, then\n";
		h9 = "dilate, dilate first, then exclude. This can be done so by toggling between the different conditions in the\n";
		h10 = "process toolbox on the left. Once the desired operations are selected, click PROCESS.Depending\n";
		h11 = "on the size of the image, this may take some time.The user can toggle between original and processed\n";
		h12 = "images by selecting the Original or Processed toggle box. If a change in the processing parameters is\n";
		h13 = "desired, this can be done so, and the PROCESS button should be clicked. The code will only save the\n";
		h14 = "most recent Processed Image by clicking the SAVE button. The user may select a name for the file to\n";
		h15 = "be saved as. If no file name is entered in the save text box, then a default file name will be used modifying\n";
		h16 = "the original file name with the addition of _Processed in the name. \n";
		h17 = "\n";


		HelpText = h1+h2+h3+h4+h5+h6+h7+h8+h9+h10+h11+h12+h13+h14+h15+h16+h17;
		waitForUser("CEM v1.0 - Help: MATLAB Toolbox", HelpText);
		Help();
	}

	if (MyelinD==true)  {
		h1 = "This tool identifies myelin and calculates results. Myelin is defined as the overlap between\n";
		h2 = "axon and oligodendrocyte signals. The ‘Identifier’ is used for naming your images. It can be any\n";
		h3 = "combination of letters, numbers and symbols that are allowed in a file name such as ‘Exp1-Image1’.\n";
		h4 = "’Axon subset’ option allows you to distinguish some of your axons from the others i.e. GFP+ and -.\n";
		h5 = "Start by opening your binary images of oligodendrocytes and neurons (outputs of ‘Generate Binary\n";
		h6 = "Images’ tool or generated by other sources). Follow the window titles to open the correct image.\n";
		h7 = "Once the images are opened, the calculator will start to identify myelin (and both marker-positive\n";
		h8 = "and -negative axons if ‘Axon subset’ checked). The process may take a few minutes, depending on\n";
		h9 = "the size of your images and the specifications of your computer. During this process, new images\n";
		h10 = "will be generated. When the calculations are complete, the results will be displayed in a new window,\n";
 		h11 = "and you will be asked to save the file as a text document. You will also be asked if you want to save\n";
		h12 = "the generated images of myelin and subsets of axons. The results are generated as pixel counts and\n";
		h13 = "percent values. The pixels are counted using the 'Histogram' function (on maximum intensity\n";
		h14 = "projections if images are stacks).\n";
		
		HelpText = h1+h2+h3+h4+h5+h6+h7+h8+h9+h10+h11+h12+h13+h14;
		waitForUser("CEM v1.0 - Help: Calculate myelin without removing cell bodies", HelpText);
		Help();
	}

	if (CBRMyelinD==true) {
		h1 = "This tool is practically the same as the ‘Calculate myelin without removing cell bodies’ tool but\n";
		h2 = "removes the cell bodies before identifying myelin. Myelin is defined as the overlap between axon and\n";
		h3 = "oligodendrocyte signals. Cell bodies are identified and grown using ‘Identify nuclei for cell body\n";
		h4 = "removal’ tool and MATLAB Toolbox. The ‘Identifier’ is used for naming your images. It can be any\n";
		h5 = "combination of letters, numbers and symbols that are allowed in a file name such as ‘Exp1-Image1’.\n";
		h6 = "’Axon subset’ option allows you to distinguish some of your axons from the others i.e. GFP+ and -.\n";
		h7 = "Start by opening your binary images of oligodendrocytes and neurons (outputs of ‘Generate Binary\n";
		h8 = "Images’ tool or generated by other sources) and cell body images. Follow the window titles\n";
		h9 = "to open the correct image. Once the images are opened, the calculator will start to identify myelin (and\n";
		h10 = "both marker-positive and -negative axons if ‘Axon subset’ checked). The process may take a few\n";
		h11 = "minutes, depending on the size of your images and the specifications of your computer. During\n";
		h12 = "this process, new images will be generated. When the calculations are complete, the results will be\n";
 		h13 = "displayed in a new window, and you will be asked to save the file as a text document. You will\n";
		h14 = "also be asked if you want to save the generated images of myelin and subsets of axons. The results\n";
		h15 = "are generated as pixel counts and percent values. The pixels are counted using the ‘Histogram’\n";
		h16 = "function (on maximum intensity projections if images are stacks). Note that ‘CBR’ will be added\n";
		h17 = "to the titles of any output files to distinguish them from output files of ‘Calculate myelin without’\n";
		h18 = "removing cell bodies tool.\n";

		HelpText = h1+h2+h3+h4+h5+h6+h7+h8+h9+h10+h11+h12+h13+h14+h15+h16+h17+h18;
		waitForUser("CEM v1.0 - Help: Calculate myelin after removing cell bodies", HelpText);
		Help();
	}

	MainMenu();

} //Help


function MainMenu () {

	//Close all open images
	while (nImages>0) { 
	          selectImage(nImages); 
	          close(); 
	      } 

	//Dialog box
	
	Dialog.create("CEM v1.0 - Main Menu");
	Dialog.addMessage("Please select a tool to proceed.");
	Dialog.addCheckbox("Split Channels", false);
	Dialog.addCheckbox("Generate Binary Images", false);
	Dialog.addCheckbox("Identify nuclei for cell body removal", false);
	Dialog.addCheckbox("Calculate myelin without removing cell bodies", false);
	Dialog.addCheckbox("Calculate myelin after removing cell bodies", false);
	Dialog.addCheckbox("Help", false);

	Dialog.show();
	SplitD = Dialog.getCheckbox();
	BinaryD = Dialog.getCheckbox();
	CBRD = Dialog.getCheckbox();
	MyelinD = Dialog.getCheckbox();
	CBRMyelinD = Dialog.getCheckbox();
	HelpD = Dialog.getCheckbox();

	if (SplitD==true)
		SplitChn();

	if (BinaryD==true) 
		ConvertToBinary();

	if (CBRD==true) 
		CBR();

	if (MyelinD==true) 
		Myelin();

	if (CBRMyelinD==true) 
		CBRMyelin();

	if (HelpD==true)
		Help();

} //MainMenu

while (continueG==true) {

//ID="Untitled";

d1 = "Computer-assisted Evaluation of Myelination (CEM; pronunciation /jem/), is a set of\n";
d2 = "tools developed for automation of myelin identification and quantification.\n";
d3 = "CEM is developed by Bilal E. Kerman and Krishnan Padmanabhan under Fred H. Gage's\n";
d4 = "guidance at the Salk Institute in La Jolla, CA, USA.\n";
d5 = "CEM is provided as part of the fair use license. Please reference Kerman et al. (submitted).\n";
d6 = "You can find more information on how to use CEM in the accompanying Users’ Guide.\n";
d7 = " \nPress OK to go main menu.";


info = d1+d2+d3+d4+d5+d6+d7;

waitForUser("Welcome to CEM v1.0", info);

MainMenu();

continueG = getBoolean("Do you want to process more images?");

}

//Close all open images
while (nImages>0) { 
          selectImage(nImages); 
          close(); 
} 

