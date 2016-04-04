//============================================================
//
// ImageJ Macro to create Plate montage from single IXM images
//    (c)2011-2016 Artur Yakimovich, University of Zurich 
//============================================================
//change

Dialog.create("ImageXpress Micro Plate Montage");
Dialog.addNumber("First Wavelength:", 1);
Dialog.addNumber("Last Wavelength:", 2);
Dialog.addNumber("Site Number:", 3);
Dialog.addNumber("First Plate Column:", 1);
Dialog.addNumber("Last Plate Column:", 12);
Dialog.addNumber("Num of Time Points:", 1);
Dialog.addString("Image File Extension:", ".TIF");
labels = newArray("A", "B", "C", "D", "E", "F", "G", "H");
defaults = newArray(true,true,true,true,true,true,true,true);
Dialog.addCheckboxGroup(1,8,labels,defaults);

Dialog.show();


firstWavelength=Dialog.getNumber();
lastWavelength=Dialog.getNumber();
site=Dialog.getNumber();
firstPlateColumn = Dialog.getNumber();
lastPlateColumn = Dialog.getNumber();
NumOfTimePoints = Dialog.getNumber();

extension = Dialog.getString();

//change if other letters are involved
//RowLetterArray = newArray("C", "D", "E", "F");
RowLetterArray = newArray();

  for (i=0; i<=labels.length-1; i++){
     row = Dialog.getCheckbox();
     
     if (row == 1){
     	RowLetterArray = Array.concat(RowLetterArray, labels[i]);
     }
  }
//RowLetterArray = newArray("A", "B", "C", "D", "E", "F", "G", "H");





ReadPath = getDirectory("Choose a Directory");
SavePath = ReadPath+File.separator+"Montage";
print ("start "+ReadPath);
File.makeDirectory(SavePath);

setBatchMode(true);
//Here

for(iTP=0; iTP<=NumOfTimePoints-1; iTP++){
	for(wavelength = firstWavelength; wavelength <= lastWavelength; wavelength++){
		for(i=0; i<=RowLetterArray.length-1; i++){
			for(j=0; j<=lastPlateColumn-1; j++){
				if(j<=9-firstPlateColumn){jNumber= "0"+j+firstPlateColumn;}
				else{jNumber= j+firstPlateColumn;}
				print (jNumber);
				print (RowLetterArray[i]);
				run("Image Sequence...", "open="+ReadPath+File.separator+"TimePoint_"+iTP+1+File.separator+" number=6913 starting=1 increment=1 scale=100 file=[] or=.*"+RowLetterArray[i]+jNumber+"_s"+site+"_w"+wavelength+extension+" sort");	
				}
			}


	run("Images to Stack", "name=Stack title=[] use");
	print ("montage done"+i+"and"+j);
	
	run("Make Montage...", "columns="+lastPlateColumn+" rows="+RowLetterArray.length+" scale=1 first=1 last="+lastPlateColumn*RowLetterArray.length+"  increment=1 border=0 font=12");
	selectWindow("Stack");
	close();
	
	if(NumOfTimePoints > 1){
		if(iTP<=9-1){TP= "0"+iTP+1;}
		else{TP= iTP+1;}
		saveAs("Tiff", SavePath+File.separator+TP+"_w"+wavelength+".tif");
		print ("time point"+TP+"done");
	
	}
	else{saveAs("Tiff", SavePath+File.separator+"w"+wavelength+"_s"+site+".tif");}
	close();
	print ("done");
	}
}
setBatchMode(false);