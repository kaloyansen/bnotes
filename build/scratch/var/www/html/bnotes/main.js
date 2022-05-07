
var selectedrow=0;
var lastselobj;
var selectedcolor;

//______________________________________________________________________________________________

function MM_jumpMenu(targ,selObj,restore){ //v3.0
			  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
			  if (restore) selObj.selectedIndex=0;
			}
//______________________________________________________________________________________________

function MM_openBrWindow(theURL,winName,features) { //v2.0
			  window.open(theURL,winName,features);
			}

//______________________________________________________________________________________________
function ColorSet(ID,color)
	{   
		objspam = MM_findObj(ID);
		objspam.style.backgroundColor = color;
	}

//______________________________________________________________________________________________

function GetDate(strObj)
{
var calendar = window.open('calendar.asp?Obj=' + strObj ,'Calendar','toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,copyhistory=0,width=160,height=180');
calendar.focus();
}

//______________________________________________________________________________________________
function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}
//______________________________________________________________________________________________

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//______________________________________________________________________________________________

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
//______________________________________________________________________________________________

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//Select row from table _______________________________________________________________________
function tr_select(obj,action)
{	
	if(selectedrow==0){
		if(action == 0) {
			obj.style.backgroundColor = "#FFFFFF";
		}
		else{
			obj.style.backgroundColor = "#EEEEEE";
			
		}
	}
}
//click over row and select id from selected product______________________________________________
function tr_click(obj,id){
	obj.style.backgroundColor = "#C5EBAB";
	if (lastselobj){
		lastselobj.style.backgroundColor = "#FFFFFF";
	}
	lastselobj = obj;
	selectedrow=1;
	var hiddenID =  MM_findObj("ID");
	if (hiddenID) {
	hiddenID.value = id;
	}
}
function MoveLayers(LayerName,MoveX,MoveY,imgID) { 
  var i,p,v,obj,objbg;
  
   if ((obj=MM_findObj(LayerName))!=null) {
    obj=obj.style;
	var imgalign =  MM_findObj(imgID);
	
	
	var cX , cY
	cX = moveXbySlicePos(0,imgalign);
    cY= moveYbySlicePos(0,imgalign);
	obj.left =  MoveX  + cX; 
	obj.top =  MoveY + cY;
	obj.visibility = "visible";
	}
}
//Get Y image position __________________________________________________________________________
function moveYbySlicePos (y, img) {
	if(!document.layers) {
		var onWindows = navigator.platform ? navigator.platform == "Win32" : false;
		var par = img;
		var lastOffset = 0;
		while(par){
			if( par.topMargin && !onWindows ) y += parseInt(par.topMargin);
			if( (par.offsetTop != lastOffset) && par.offsetTop ) y += parseInt(par.offsetTop);
			if( par.offsetTop != 0 ) lastOffset = par.offsetTop;
			par = par.offsetParent;
		}		
	} else if (img.y >= 0) y += img.y;
	return y;
}

//Get X image position __________________________________________________________________________
function moveXbySlicePos (x, img) { 
	if (!document.layers) {
		var onWindows = navigator.platform ? navigator.platform == "Win32" : false;
		var par = img;
		var lastOffset = 0;
		while(par){
			if( par.leftMargin && ! onWindows ) x += parseInt(par.leftMargin);
			if( (par.offsetLeft != lastOffset) && par.offsetLeft ) x += parseInt(par.offsetLeft);
			if( par.offsetLeft != 0 ) lastOffset = par.offsetLeft;
			par = par.offsetParent;
		}
	} else if (img.x) x += img.x;
	return x;
}

// **********************************************************************************************



