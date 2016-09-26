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
