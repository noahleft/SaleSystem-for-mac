//
//  dataConvert.swift
//  SaleSystem
//
//  Created by 林世豐 on 26/09/2016.
//
//

import Foundation

func companyFilter(selectedComId: Int, unitPriceList: [UNITPRICE]) -> [UNITPRICE] {
    return unitPriceList.filter{ (p) -> Bool in
        p.ComId == selectedComId
    }
}

func selectUnitPrice(selectedProId: Int, unitPriceList: [UNITPRICE]) -> Float {
    for item in unitPriceList {
        if item.ProId == selectedProId {
            return item.UnitPrice
        }
    }
    return -1
}

func dateFormatterForDisplay(date: Date) -> String {
    let dateFormatter : DateFormatter = DateFormatter()
    dateFormatter.locale = Locale.init(identifier: "zh_Hant_TW")
    dateFormatter.dateFormat = "yyy-MM-dd"
    dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.republicOfChina)
    return dateFormatter.string(from: date)
}

func validateString(strline : String) -> String {
    var retStr = strline
    retStr = retStr.replacingOccurrences(of: "１", with: "1")
    retStr = retStr.replacingOccurrences(of: "２", with: "2")
    retStr = retStr.replacingOccurrences(of: "３", with: "3")
    retStr = retStr.replacingOccurrences(of: "４", with: "4")
    retStr = retStr.replacingOccurrences(of: "５", with: "5")
    retStr = retStr.replacingOccurrences(of: "６", with: "6")
    retStr = retStr.replacingOccurrences(of: "７", with: "7")
    retStr = retStr.replacingOccurrences(of: "８", with: "8")
    retStr = retStr.replacingOccurrences(of: "９", with: "9")
    retStr = retStr.replacingOccurrences(of: "０", with: "0")
    retStr = retStr.replacingOccurrences(of: "．", with: ".")
    return retStr
}
