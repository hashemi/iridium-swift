//
//  instruction.swift
//  iridium-swift
//
//  Created by Ahmad Alhashemi on 2018-09-20.
//  Copyright © 2018 Ahmad Alhashemi. All rights reserved.
//

enum Opcode: UInt8, Equatable {
    case load
    case add
    case sub
    case mul
    case div
    case hlt
    case jmp
    case jmpf
    //case jmpb
    case eq
    case neq
    case gte
    case lte
    case lt
    case gt
    case jmpe
    //case nop
    //case aloc
    //case inc
    //case dec
    //case djmpe
    //case prts
    case igl
}

extension Opcode {
    init(named: String) {
        switch named.lowercased() {
        case "load": self = .load
        case "add": self = .add
        case "sub": self = .sub
        case "mul": self = .mul
        case "div": self = .div
        case "hlt": self = .hlt
        case "jmp": self = .jmp
        case "jmpf": self = .jmpf
        //case "jmpb": self = .jmpb
        case "eq": self = .eq
        case "neq": self = .neq
        case "gte": self = .gte
        case "lte": self = .lte
        case "lt": self = .lt
        case "gt": self = .gt
        case "jmpe": self = .jmpe
        //case "nop": self = .nop
        //case "aloc": self = .aloc
        //case "inc": self = .inc
        //case "dec": self = .dec
        //case "djmpe": self = .djmpe
        //case "prts": self = .prts
        default: self = .igl
        }
    }
}

struct Instruction {
    let opcode: Opcode
}
