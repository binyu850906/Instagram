//
//  NumberConverter.swift
//  Instagram
//
//  Created by binyu on 2021/1/10.
//

import Foundation

func NumCoverter(_ number: Int) -> String {
    if number > 10000{
        return "\(number / 10000).\(number / 1000 - ((number / 10000) * 10))萬"
    }else if number > 1000{
        return "\(number / 1000),\(number % 1000)"
    }else{
    return String(number)
    }
}
