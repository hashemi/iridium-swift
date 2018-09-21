//
//  vm.swift
//  iridium-swift
//
//  Created by Ahmad Alhashemi on 2018-09-20.
//  Copyright © 2018 Ahmad Alhashemi. All rights reserved.
//

struct VM {
    var registers = RegisterSet()
    var pc = 0
    var program: [UInt8] = []
    var remainder: UInt32 = 0
    var equalFlag = false
    
    mutating func decodeOpcode() -> Opcode {
        let opcode = Opcode(rawValue: program[pc]) ?? .igl
        pc += 1
        return opcode
    }
    
    mutating func next8Bits() -> UInt8 {
        let result = program[pc]
        pc += 1
        return result
    }
    
    mutating func next16Bits() -> UInt16 {
        let result = (UInt16(program[pc]) << 8) | UInt16(program[pc + 1])
        pc += 2
        return result
    }
    
    mutating func runOnce() {
        _ = executeInstruction()
    }
    
    private mutating func executeInstruction() -> Bool {
        if self.pc >= program.count {
            return false
        }
        
        func arithmetic(_ op: (Int32, Int32) -> Int32) {
            let register1 = registers[next8Bits()]
            let register2 = registers[next8Bits()]
            registers[next8Bits()] = op(register1, register2)
        }
        
        func boolean(_ op: (Int32, Int32) -> Bool) {
            let register1 = registers[next8Bits()]
            let register2 = registers[next8Bits()]
            equalFlag = op(register1, register2)
            _ = next8Bits()
        }
        
        switch self.decodeOpcode() {
        case .load:
            let register = next8Bits()
            let number = next16Bits()
            registers[register] = Int32(number)
            
        case .add: arithmetic(+)
        case .sub: arithmetic(-)
        case .mul: arithmetic(*)
            
        case .div:
            let register1 = registers[next8Bits()]
            let register2 = registers[next8Bits()]
            registers[next8Bits()] = register1 / register2
            remainder = UInt32(register1 % register2)
            
        case .eq: boolean(==)
        case .neq: boolean(!=)
        case .gte: boolean(>=)
        case .lte: boolean(<=)
        case .lt:  boolean(<)
        case .gt:  boolean(>)
            
        case .jmpe:
            if equalFlag {
                let target = registers[next8Bits()]
                pc = Int(target)
            }
            
        case .jmp:
            let target = registers[next8Bits()]
            pc = Int(target)
            
        case .jmpf:
            let value = registers[next8Bits()]
            pc += Int(value)
            
        case .hlt:
            print("HLT encountered")
            return false
            
        case .igl:
            fatalError("Unrecognized opcode found! Terminating!")
        }
        
        return true
    }
    
    mutating func run() {
        var isDone = false
        while !isDone {
            isDone = executeInstruction()
        }
    }
}

struct RegisterSet: CustomStringConvertible {
    private var data: (
        Int32, Int32, Int32, Int32, Int32, Int32, Int32, Int32,
        Int32, Int32, Int32, Int32, Int32, Int32, Int32, Int32,
        Int32, Int32, Int32, Int32, Int32, Int32, Int32, Int32,
        Int32, Int32, Int32, Int32, Int32, Int32, Int32, Int32)
        = (
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0
    )
    
    subscript(index: UInt8) -> Int32 {
        get {
            switch index {
            case 0:  return data.0
            case 1:  return data.1
            case 2:  return data.2
            case 3:  return data.3
            case 4:  return data.4
            case 5:  return data.5
            case 6:  return data.6
            case 7:  return data.7
            case 8:  return data.8
            case 9:  return data.9
            case 10: return data.10
            case 11: return data.11
            case 12: return data.12
            case 13: return data.13
            case 14: return data.14
            case 15: return data.15
            case 16: return data.16
            case 17: return data.17
            case 18: return data.18
            case 19: return data.19
            case 20: return data.20
            case 21: return data.21
            case 22: return data.22
            case 23: return data.23
            case 24: return data.24
            case 25: return data.25
            case 26: return data.26
            case 27: return data.27
            case 28: return data.28
            case 29: return data.29
            case 30: return data.30
            case 31: return data.31
            default:
                fatalError("Illegal register number \(index)")
            }
        }
        set(newValue) {
            switch index {
            case 0:  data.0  = newValue
            case 1:  data.1  = newValue
            case 2:  data.2  = newValue
            case 3:  data.3  = newValue
            case 4:  data.4  = newValue
            case 5:  data.5  = newValue
            case 6:  data.6  = newValue
            case 7:  data.7  = newValue
            case 8:  data.8  = newValue
            case 9:  data.9  = newValue
            case 10: data.10 = newValue
            case 11: data.11 = newValue
            case 12: data.12 = newValue
            case 13: data.13 = newValue
            case 14: data.14 = newValue
            case 15: data.15 = newValue
            case 16: data.16 = newValue
            case 17: data.17 = newValue
            case 18: data.18 = newValue
            case 19: data.19 = newValue
            case 20: data.20 = newValue
            case 21: data.21 = newValue
            case 22: data.22 = newValue
            case 23: data.23 = newValue
            case 24: data.24 = newValue
            case 25: data.25 = newValue
            case 26: data.26 = newValue
            case 27: data.27 = newValue
            case 28: data.28 = newValue
            case 29: data.29 = newValue
            case 30: data.30 = newValue
            case 31: data.31 = newValue
            default:
                fatalError("Illegal register number \(index)")
            }
        }
    }
    
    var description: String {
        return
        """
        $0  = \(data.0)
        $1  = \(data.1)
        $2  = \(data.2)
        $3  = \(data.3)
        $4  = \(data.4)
        $5  = \(data.5)
        $6  = \(data.6)
        $7  = \(data.7)
        $8  = \(data.8)
        $9  = \(data.9)
        $10 = \(data.10)
        $11 = \(data.11)
        $12 = \(data.12)
        $13 = \(data.13)
        $14 = \(data.14)
        $15 = \(data.15)
        $16 = \(data.16)
        $17 = \(data.17)
        $18 = \(data.18)
        $19 = \(data.19)
        $20 = \(data.20)
        $21 = \(data.21)
        $22 = \(data.22)
        $23 = \(data.23)
        $24 = \(data.24)
        $25 = \(data.25)
        $26 = \(data.26)
        $27 = \(data.27)
        $28 = \(data.28)
        $29 = \(data.29)
        $30 = \(data.30)
        $31 = \(data.31)
        """
    }
}
