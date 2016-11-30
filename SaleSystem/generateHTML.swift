//
//  generateHTML.swift
//  SaleSystem
//
//  Created by 林世豐 on 11/10/2016.
//
//

import Foundation

func generateHTML(companyName: String,formName: String, recordList: [RECORD]) -> String {
    // record order ORDER BY DELIVER_DATE
    var HTMLstring : String = ""
    HTMLstring = ""
    //"Content-type: text/html\n\n"
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
    
    var sum : Double = 0
    for item in recordList.sorted(by: { (s1: RECORD,s2: RECORD) -> Bool in
    return s1.DeliverDate < s2.DeliverDate}) {
        var rowString: String = "<tr>\n"
        rowString.append("<td class=\"dateTime\">"+dateFormatterForDisplay(date: item.DeliverDate)+"</td>")
        rowString.append("<td class=\"productName\">"+dataManager.getProductName(id: item.ProdId)+"</td>")
        rowString.append("<td class=\"quantity\">"+"\(item.Quantity)"+"y</td>")
        rowString.append("<td class=\"price\">"+"\(item.UnitPrice)"+"</td>")
        let tmpSum : Double = Double(item.Quantity)*item.UnitPrice
        rowString.append("<td class=\"price\">"+"\(tmpSum)"+"</td>")
        sum = sum + tmpSum
        
        HTMLstring.append(rowString)
    }
    HTMLstring.append("</table>\n")
//        
    HTMLstring.append("總計:\(Int(sum))\n")
    HTMLstring.append("</div>")
//
    HTMLstring.append("</body>")
    HTMLstring.append("</html>")
    

//    print(HTMLstring)
    
    return HTMLstring
}

