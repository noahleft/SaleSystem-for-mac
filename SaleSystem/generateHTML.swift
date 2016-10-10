//
//  generateHTML.swift
//  SaleSystem
//
//  Created by 林世豐 on 11/10/2016.
//
//

import Foundation

func generateHTML(companyName: String,formName: String) -> String {
    // record order ORDER BY DELIVER_DATE
    var HTMLstring : String = ""
    HTMLstring = "Content-type: text/html\n\n"
    HTMLstring.append("<!DOCTYPE html>\n")
    HTMLstring.append("<html>\n")
    HTMLstring.append("<head>\n")
    HTMLstring.append("<title>紀錄</title>\n")
    HTMLstring.append("<meta charset=\"UTF-8\">\n")
    HTMLstring.append("<link href=\"Site.css\" rel=\"stylesheet\">\n")
    HTMLstring.append("</head>\n")
    HTMLstring.append("<body>\n")
    HTMLstring.append("<div id=\"main\">")
    HTMLstring.append("<h1>應收帳款 "+companyName+" "+formName+"</h1>\n")
//
    HTMLstring.append("<table>\n")
    HTMLstring.append("<tr>\n")
    HTMLstring.append("<th class=\"dateTime\">日期</th><th class=\"productName\">品項</th><th class=\"quantity\">數量</th><th class=\"price\">單價</th><th class=\"price\">小計</th>\n")
    HTMLstring.append("</tr>\n")
//        total_price=0
//        for row in data:
//        unit_price=float(row[3])
//        quantity=float(row[4])
//        price=unit_price*quantity
//        total_price+=price
//        rowStrings=['<tr>']
//        rowStrings+=['<td class="dateTime">'+str(convertDate(row[2]))+'</td>']
//        rowStrings+=['<td class="productName">'+str(productDict[row[1]])+'</td>']
//        rowStrings+=['<td class="quantity">'+str(row[4])+'y</td>']
//        rowStrings+=['<td class="price">'+str(row[3])+'</td>']
//        rowStrings+=['<td class="price">'+str(price)+'</td>']
//        rowStrings+=['</tr>']
//        print(''.join(rowStrings))
    HTMLstring.append("</table>\n")
//        
//        print('總計:',int(total_price))
//        
//        ############################
//        
//        print("""<footer id="foot01"></footer>
    HTMLstring.append("</div>")
//
    HTMLstring.append("</body>")
    HTMLstring.append("</html>")
    

    print(HTMLstring)
    
    return HTMLstring
}

