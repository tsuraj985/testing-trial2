                body,td,th, h1 {
                font-family:Verdana, Arial, Helvetica, sans-serif;
                font-size:7.5pt;
                color:#000000;
                }
            
                div.content table{
                width:100%;
                border-collapse:collapse;
                margin-bottom:10px;
                }
            
               div.content  table.tableSummary{
                width:250px;
                }
            
                div.content  table.tableDescription{
                width:68%;
                margin-top:10px;
                margin-bottom:5px;
                }
                
                div.content  table.noBottomMargin{
                margin-bottom:0px;
                }
                
               div.content  table.tableTaxSummary, table.tableAdditional {
                margin-top:10px;
                margin-bottom:0px;
                }
            
               div.content  table h1{
                font-size:20px;
                font-weight:700;
                text-transform:uppercase;
                text-align:right;
                margin:0;
                }
            
                div.content  table td,
                table th{
                padding:5px;
                }
                div.content  table th{
                background-color:#E4EAF4;
                color:#000000;
                }
            
                div.content  table th.nobg{
                background-color:transparent;
                color:#000000;
                }
            
                div.content  table td.noPadding{
                padding:0px;
                }
               div.content  table td.noPaddingLeft{
                padding-left:0px;
                }
            
               div.content  table td.alignTop{
                vertical-align:top;
                }
            
               div.content  table .textAlignLeft{
                text-align:left;
                }
               div.content  table .textAlignCenter{
                text-align:center;
                }
               div.content  table .textAlignRight{
                text-align:right;
                }
            
               div.content  table.boxed{
                border-left:1px solid #3B5E91;
                border-top:1px solid #3B5E91;
                }
            
               div.content  table.boxed th, table.boxed td{
                border-left:1px solid #3B5E91;
                border-top:1px solid #3B5E91;
                }
            
               div.content  table.boxedNoTop{
                border-top:none;
                border-left:none;
                }
                
               div.content  table.boxedNoBottom{
                border-bottom:none;
                }
                
                table.boxedNoTop td.boxedNoTop{
                border-top:none ;
                }
            
               div.content  table.boxed th{
                border-right:1px solid #3B5E91;
                border-bottom:1px solid #3B5E91;
                }
            
               div.content  table.boxed th.noLines{
                border-right:1px solid #3B5E91;
                border-left:none;
                border-top:none;
                border-bottom:none;
                }
            
               div.content  table.boxed td{
                border-right:1px solid #3B5E91;
                border-bottom:1px solid #3B5E91;
                }
            
               div.content  table.boxed td.widthLineNumbers{width:15pt;}
               div.content  table.boxed td.widthSmall{width:45pt;}
               div.content  table.boxed td.widthMedium{width:75pt;}
                
               div.content  .widthMedium{width:75pt;}
            
               div.content  table.boxed td span.description{
                font-size:85%;
                font-style:italic;
                display:block;
                }
                
               div.content  .boxedtop {
                border-top:1px solid #3B5E91;
                }
                    
               div.content  .boxed {
                border-left:1px solid #3B5E91;
                border-right:1px solid #3B5E91;
                border-bottom:1px solid #3B5E91;
                }
                
               div.content  table { page-break-inside:auto }
                tr    { page-break-inside:avoid; page-break-after:auto }
                
               
		`	  /* div.footer {
				padding: 5px;
				position: running(footer);
			}

	 @page {

 	size:portrait;
    margin-left: 0px;
    margin-right: 0px;
    margin-top: 15px;
    margin-bottom: 15px;

                }
                
	
.pagenumber:before {
    content: counter(page);
}
 
.pagecount:after {
    content: counter(pages);
} */



@page {

@bottom-right {
 content: element(footer);
}
}
 

div.footer {
display: block;
padding: 5px;
position: running(footer);
}
 
.pagenumber:before {
content: counter(page);
}
.pagecount:before {
content: counter(pages);
}