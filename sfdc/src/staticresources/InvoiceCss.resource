@page {

 size:portrait;
    margin-left: 0px;
    margin-right: 0px;
    margin-top: 85px;
    margin-bottom: 95px;

@top-center {

content: element(header);

}

@bottom-left {

    content: element(footer);

}


}

div.header {
display: block;
padding-top:0px;
margin-top:0px;

position: running(header);

}

div.footer {

display: block;

/*padding: 5px;*/
/*margin-left:90px;*/

margin-left:50px;
margin-right:50px;

position: running(footer);

}

div.content {
display: block;
margin-left:50px;
margin-right:50px;

}

 

.pagenumber:before {

content: counter(page);

}

.pagecount:before {

content: counter(pages);

}