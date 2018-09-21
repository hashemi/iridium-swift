//
//  assembler.swift
//  iridium-swift
//
//  Created by Ahmad Alhashemi on 2018-09-21.
//  Copyright © 2018 Ahmad Alhashemi. All rights reserved.
//

enum Token {
    case opcode(Opcode)
    case register(UInt8)
    case number(Int32)
}

struct Parser {
    let source: String.UnicodeScalarView
    var current: String.UnicodeScalarIndex
    
    init(source: String) {
        self.source = source.unicodeScalars
        self.current = source.unicodeScalars.startIndex
    }
    
    mutating func parseInstruction() -> AssemblerInstruction? {
        if isAtEnd { return nil }
        
        var tokens: [Token] = []
        while let token = lexToken() {
            tokens.append(token)
        }
        
        switch tokens.count {
        case 1:
            return .i0(tokens[0])
        case 2:
            return .i1(tokens[0], tokens[1])
        case 3:
            return .i2(tokens[0], tokens[1], tokens[2])
        case 4:
            return .i3(tokens[0], tokens[1], tokens[2], tokens[3])
        default:
            fatalError("Malformed instruction")
        }
    }
    
    mutating func lexToken() -> Token? {
        skipHorzWhitespace()
        
        guard !isAtEnd else { return nil }
        
        let start = current
        let c = advance()
        
        switch c {
        case "$" where peek.isDigit:
            let digits = lexDigits()
            return .register(UInt8(digits)!)
            
        case "#" where peek.isDigit:
            let digits = lexDigits()
            return .number(Int32(digits)!)
            
        case _ where c.isAlpha:
            while peek.isAlpha { advance() }
            let opName = String(source[start..<current])
            let opcode = Opcode(named: opName)
            return .opcode(opcode)
            
        case _ where c.isNewline:
            while peek.isNewline || peek.isHorzWhitespace { advance() }
            return nil
            
        default:
            fatalError("Unknown character: \(c)")
        }
    }
    
    @discardableResult
    mutating func advance() -> UnicodeScalar {
        let c = source[current]
        current = source.index(after: current)
        return c
    }
    
    var isAtEnd: Bool {
        return current >= source.endIndex
    }
    
    var peek: UnicodeScalar {
        guard !isAtEnd else { return "\0" }
        return source[current]
    }
    
    mutating func lexDigits() -> String {
        let numStart = current
        while peek.isDigit { advance() }
        return String(source[numStart..<current])
    }
    
    mutating func skipHorzWhitespace() {
        while peek.isHorzWhitespace { advance() }
    }
}

enum AssemblerInstruction {
    case i0(Token)
    case i1(Token, Token)
    case i2(Token, Token, Token)
    case i3(Token, Token, Token, Token)
    
    var bytes: [UInt8] {
        var results: [UInt8] = []
        
        func extractOperand(_ t: Token) {
            switch t {
            case .register(let register):
                results.append(register)
            case .number(let value):
                let converted = UInt16(value)
                let byte1 = converted
                let byte2 = converted >> 8
                results.append(UInt8(byte2))
                results.append(UInt8(byte1))
            case .opcode(_):
                fatalError("Opcode found in operand field")
            }
        }
        
        switch self {
        case let .i0(.opcode(opcode)):
            results.append(opcode.rawValue)
        
        case let .i1(.opcode(opcode), t1):
            results.append(opcode.rawValue)
            extractOperand(t1)
            
        case let .i2(.opcode(opcode), t1, t2):
            results.append(opcode.rawValue)
            extractOperand(t1)
            extractOperand(t2)

        case let .i3(.opcode(opcode), t1, t2, t3):
            results.append(opcode.rawValue)
            extractOperand(t1)
            extractOperand(t2)
            extractOperand(t3)
            
        default:
            fatalError("Non-opcode found in opcode field")
        }
        
        return results
    }
}

struct Program {
    let instructions: [AssemblerInstruction]
    
    var bytes: [UInt8] {
        var program: [UInt8] = []
        for instruction in instructions {
            program.append(contentsOf: instruction.bytes)
        }
        return program
    }
}

private extension UnicodeScalar {
    var isAlpha: Bool {
        return (self >= "a" && self <= "z") || (self >= "A" && self <= "Z")
    }
    
    var isDigit: Bool {
        return (self >= "0" && self <= "9")
    }
    
    var isHorzWhitespace: Bool {
        let options: Set<UnicodeScalar> = [" ", "\t"]
        return options.contains(self)
    }
    
    var isNewline: Bool {
        let options: Set<UnicodeScalar> = ["\n", "\r"]
        return options.contains(self)
    }
}
