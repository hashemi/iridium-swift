//
//  repl.swift
//  iridium-swift
//
//  Created by Ahmad Alhashemi on 2018-09-21.
//  Copyright © 2018 Ahmad Alhashemi. All rights reserved.
//

import Darwin

struct REPL {
    var commandBuffer: [String] = []
    var vm = VM()
    
    mutating func run() {
        print("Welcome to Iridium! Let's be productive!")
        while true {
            print(">>> ", terminator: "")
            let line = readLine() ?? ""
            commandBuffer.append(line)
            switch line {
            case ".quit":
                print("Farewell! Have a great day!")
                exit(0)
                
            case ".history":
                for command in commandBuffer {
                    print(command)
                }
                
            case ".program":
                print("Listing instructions currently in VM's program vector:")
                for instruction in vm.program {
                    print(instruction)
                }
                print("End of Program Listing")
                
            case ".registers":
                print("Listing registers and all contents:")
                print(vm.registers)
                print("End of Register Listing")
                
            default:
                var l = Parser(source: line)
                while let inst = l.parseInstruction() {
                    vm.program.append(contentsOf: inst.bytes)
                    vm.run()
                }
            }
        }
    }
}
