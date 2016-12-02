//
//  VariableObjectFunctions.swift
//  SaleSystem
//
//  Created by 林世豐 on 30/11/2016.
//
//

import Foundation

func sortOrderOfProduct(_ s1: PRODUCT, _ s2: PRODUCT) -> Bool {
    return s1.Name < s2.Name
}

func sortOrderOfSQLProduct(_ s1: SQL_PRODUCT, _ s2: SQL_PRODUCT) -> Bool {
    return s1.Name < s2.Name
}
