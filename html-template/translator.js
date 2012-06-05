//////////////////////////////////////////////////////////
//	<JavaScript RSS Reader>				//
//      Modified to be Inserted Embedded Into a Site:	// 
//	Portability/Customization Features Added:	//
//	By Danny Garfield (13/03/04)			//
//	http://www.puuba.com				//
//	http://www.reploid9.com				//
//							//
// 	(c) 2003 Premshree Pillai			//
//	Core Code Written On: 07/06/03 (dd/mm/yy)	//
//	http://www.qiksearch.com/			//
//	http://premshree.resource-locator.com		//
//							//
//////////////////////////////////////////////////////////

/* 
Script Now Supports:
-Variable Number Of Entries Outputted
-Embedding in an HTML File
-Externally Customizable Font/Look

To Use This Script:
	Paste into the <head> section of the HTML page:
		<script src="http://www.puuba.com/team/translator.js"></script>
	
	Then, wherever you want the translated RSS feed to appear, paste:
		<script>
		try {readRSS(unescape("http://www.puuba.com/team/blog.rss"),5);}
		catch(e) {}
		</script>

	Replace the URL with that of the RSS feed you want. Replace the number with
	The max number of entries you want displayed. (posts, on a blog)
	If the number is zero, it means to display ALL available posts.
	If the number is more than the available posts, all available posts will show.

Options:
	NOHR
	NODATE
	  SHOWTIME12
	  SHOWTIME24
	NOAUTHOR
	NODOUBLESPACE
	SHOWBODY
	  TILBR
	NOTITLE
	ALTDATEAUTH
	DATEFIRST


You can customize the colors/styles of the text outputted by this using
a standard style sheet from the outside.
The classes of the words are:
	.rsslink   - the links printed (the titles)
	.rssdate   - the date/time printed
	.rssauthor - the name of the poster.
Normal style declarations (color, size, text decoration, italics, bold, etc) can be
declared in the style sheet as usual. 

*/


function readRSS(URI, number) {
	var hrSwitch = true, authorSwitch = true, dateSwitch = true, doubleSpace = true, showBody = false, showTime12 = false, showTime24 = false, showTitle = true, altform = false, datefirst = false;


	if (arguments.length > 2)
		for (i=2; i<arguments.length; i++) {
			if (arguments[i] == "NOHR")
				hrSwitch = false;
			if (arguments[i] == "NOAUTHOR")
				authorSwitch = false;
			if (arguments[i] == "NODATE")
				dateSwitch = false;
			if (arguments[i] == "NODOUBLESPACE")
				doubleSpace = false;
			if (arguments[i] == "NOTITLE")
				showTitle = false;
			if (arguments[i] == "SHOWBODY")
				showBody = true;
			if (arguments[i] == "SHOWTIME12")
				showTime12 = true;
			if (arguments[i] == "SHOWTIME24")
				showTime24 = true;
			if (arguments[i] == "ALTDATEAUTH")
				altform = true;
			if (arguments[i] == "DATEFIRST")
				datefirst = true;
		}




	if(window.ActiveXObject) {
		var xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
		xmlDoc.async=false;
		while(xmlDoc.readyState!=4) document.write('Loading...');
	}
	else if(document.implementation&&document.implementation.createDocument)
		xmlDoc=document.implementation.createDocument("","doc",null);
	xmlDoc.load(arguments[0]);
	items=xmlDoc;

	function verify() {if(xmlDoc.readyState!=4) return false;}

	function formatRSS(number) {
		var items_count;
		if ((number == 0) || (number > items.getElementsByTagName('item').length))
			items_count=items.getElementsByTagName('item').length;
		else
			items_count=number;
		var date=new Array(), time=new Array(), link=new Array(), title=new Array(), description=new Array(), guid=new Array(), body=new Array(), temp, temp2;

		for(var i=0; i<items_count; i++) {
			if(items.getElementsByTagName('item')[i].getElementsByTagName('dc:date').length==1)
				date[i]=items.getElementsByTagName('item')[i].getElementsByTagName('dc:date')[0];
			if(items.getElementsByTagName('item')[i].getElementsByTagName('link').length==1)
				link[i]=items.getElementsByTagName('item')[i].getElementsByTagName('link')[0];
			if(items.getElementsByTagName('item')[i].getElementsByTagName('guid').length==1)
				guid[i]=items.getElementsByTagName('item')[i].getElementsByTagName('guid')[0];
			if(items.getElementsByTagName('item')[i].getElementsByTagName('title').length==1)
				title[i]=items.getElementsByTagName('item')[i].getElementsByTagName('title')[0];
			if(items.getElementsByTagName('item')[i].getElementsByTagName('dc:creator').length==1)
				description[i]=items.getElementsByTagName('item')[i].getElementsByTagName('dc:creator')[0];
			if(items.getElementsByTagName('item')[i].getElementsByTagName('content:encoded').length==1)
				body[i]=items.getElementsByTagName('item')[i].getElementsByTagName('content:encoded')[0];

			temp = date[i].firstChild.nodeValue;
			date[i] = temp.substring(0,temp.indexOf("T"));


			if (showTime24)
				time[i] = temp.substring(temp.indexOf("T")+1,temp.indexOf("Z"));

			else if (showTime12) {
				temp2 = temp.substring(temp.indexOf("T")+1,temp.indexOf("T")+3);
				if (temp2 > 12)
					time[i] = temp2 - 12;
				else	
					time[i] = temp2;
				time[i] = time[i] + temp.substring(temp.indexOf("T")+3,temp.indexOf("Z"));

			}

		}

		if((description.length==0)&&(title.length==0)) return false;

		var ws=/\S/;

		for(var i=0; i<items_count; i++) {
			var title_w, link_w;
			if(document.all)
				title_w=(title.length>0)?title[i].text:"<i>Untitled</i>";
			else
				title_w=(title.length>0)?title[i].firstChild.nodeValue:"<i>Untitled</i>";

			link_w=(link.length>0)?link[i].firstChild.nodeValue:"";
			if (datefirst && !altform) {
				document.write('<a class="rssdate">' + date[i]);
				if (showTime12 || showTime24) document.write(' - ' + time[i]);
				document.write(':</a><BR>');
			}
			if(link.length==0) link_w=(guid.length>0)?guid[i].firstChild.nodeValue:"";
			if(title.length>0) title_w=(!ws.test(title_w))?"<i>Untitled</i>":title_w;
			if (showTitle) document.write('<div STYLE="word-wrap: break-word"><a href="'+link_w+'" class="rsslink" target="_parent">'+title_w+'</a></div>');
			if(showBody) document.write(body[i].firstChild.nodeValue + '<BR>');
			if (dateSwitch & !altform & !datefirst) {
				document.write('<a class="rssdate">(' + date[i]);
				if (showTime12 || showTime24) document.write(' - ' + time[i]);
				document.write(')</a><BR>');
			}
			if (authorSwitch && description.length>0 &!altform)
				document.write('<a class="rssauthor"> by: '+description[i].firstChild.nodeValue+'</a><BR>');
			if (altform) {
				if (description[i].firstChild)
					document.write('- <a class="rssauthor">' +description[i].firstChild.nodeValue+ '</a> :: <a class="rssdate">(' +date[i]+ ')</a><BR>');
				else
					document.write('- <a class="rssauthor">No Name In Profile</a> :: <a class="rssdate">(' +date[i]+ ')</a><BR>');
			}
			if (hrSwitch) document.write('<HR>'); if (doubleSpace) document.write('<BR>');
		}

	}

	if(typeof(xmlDoc)!="undefined") {
		if(window.ActiveXObject) formatRSS(arguments[1]);
		else xmlDoc.onload=formatRSS;
	}
}