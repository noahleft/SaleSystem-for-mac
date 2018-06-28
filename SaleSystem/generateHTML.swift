//
//  generateHTML.swift
//  SaleSystem
//
//  Created by 林世豐 on 11/10/2016.
//
//

import Foundation

func generateHTML(companyName: String,formName: String, recordList: [RECORD],taxIncluded : Bool) -> String {
    let html_title = NSLocalizedString("HTML_Title", comment: "")
    let html_subtitle = NSLocalizedString("HTML_Subtitle", comment: "")
    let html_table_dateTime = NSLocalizedString("HTML_Table_dateTime", comment: "")
    let html_table_productName = NSLocalizedString("HTML_Table_productName", comment: "")
    let html_table_quantity = NSLocalizedString("HTML_Table_quantity", comment: "")
    let html_table_price = NSLocalizedString("HTML_Table_price", comment: "")
    let html_table_sum = NSLocalizedString("HTML_Table_sum", comment: "")
    let html_total = NSLocalizedString("HTML_Total", comment: "")
    let html_note = NSLocalizedString("HTML_Note", comment: "")
    let html_tax = NSLocalizedString("HTML_Tax", comment: "")
    let html_salesamount = NSLocalizedString("HTML_SalesAmount", comment: "")
    // record order ORDER BY DELIVER_DATE
    var HTMLstring : String = ""
    HTMLstring = ""
    //"Content-type: text/html\n\n"
    HTMLstring.append("<!DOCTYPE html>\n")
    HTMLstring.append("<html>\n")
    HTMLstring.append("<head>\n")
    HTMLstring.append("<title>"+html_title+"</title>\n")
    HTMLstring.append("<meta charset=\"UTF-8\">\n")
    HTMLstring.append("<link href=\"Site.css\" rel=\"stylesheet\">\n")
    HTMLstring.append("</head>\n")
    HTMLstring.append("<body>\n")
    HTMLstring.append("<div id=\"main\">")
    HTMLstring.append("<h1>"+html_subtitle+" "+companyName+" "+formName+"</h1>\n")
    HTMLstring.append("<div>")
//
    HTMLstring.append("<table>\n")
    HTMLstring.append("<tr>\n")
    HTMLstring.append("<th class=\"dateTime\">"+html_table_dateTime+"</th><th class=\"productName\">"+html_table_productName+"</th><th class=\"quantity\">"+html_table_quantity+"</th><th class=\"price\">"+html_table_price+"</th><th class=\"price\">"+html_table_sum+"</th><th class=\"note\">"+html_note+"</th>\n")
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
        rowString.append("<td class=\"note\">"+"\(item.Note)"+"</td>")
        sum = sum + tmpSum
        
        HTMLstring.append(rowString)
    }
    HTMLstring.append("</table>\n")
//
    
    HTMLstring.append("<div id=\"foot\">")
    if taxIncluded {
        let sale: Int = Int(sum)
        let tax : Int = Int(sum*0.05)
        let total : Int = sale + tax
        HTMLstring.append(html_salesamount+":\(sale)<br>")
        HTMLstring.append(html_tax+":\(tax)<br>")
        HTMLstring.append(html_total+":\(total)\n")
    }
    else {
        HTMLstring.append(html_total+":\(Int(sum))\n")
    }
    HTMLstring.append("</div>")
    HTMLstring.append("</div>")
    HTMLstring.append("</div>")
//
    HTMLstring.append("</body>")
    HTMLstring.append("</html>")
    

//    print(HTMLstring)
    
    return HTMLstring
}

