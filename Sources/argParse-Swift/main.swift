
import Foundation

let arguments = CommandLine.arguments
print(arguments)
print(arguments.count, terminator: "\n")

typealias Map = [String: String]


func parse(args: [String]) -> (mapped: Map, tail: [String]) {
    var arr = args
    var flagsDict = Map()
    var tail = [String]()
    while arr.count > 0 {
        if let flagData = parseFlag(args: arr) {
            flagsDict = flagsDict.merging(flagData.parsed, uniquingKeysWith: { (_, new) in new })
            arr = flagData.rest
        }
        else if let nonFlagData = parseNonFlag(args: arr) {
            tail.append(nonFlagData.string)
            arr = nonFlagData.rest
        }
    }
    return (flagsDict, tail)
}

func parseFlag(args: [String]) -> (parsed: Map, rest: [String])? {
    var arr = args
    var first = arr[0]
    guard first.hasPrefix("-") else { return nil }
    first.removeFirst(first.hasPrefix("--") ? 2 : 1)
    
    if first.contains("=") {
        let eqIndex = first.index(of: "=")!
        let key = String(first[..<eqIndex])
        let value = String(first[first.index(after: eqIndex)...])
        arr.removeFirst()
        return ([key: value], arr)
    }
    if arr.count >= 2, let nonFlagData = parseNonFlag(args: Array(arr[1...])) {
        let value = nonFlagData.string
        arr = nonFlagData.rest
        return([first: value], arr)
    }
    arr.removeFirst()
    return([first: "true"], arr)
}

func notFlag(_ s: String) -> Bool {
    return (s.hasPrefix("-") || s.contains("=")) ? false : true
}

func parseNonFlag(args: [String]) -> (string: String, rest: [String])? {
    var arr = args
    let first = arr[0]
    guard !first.hasPrefix("-") else { return nil }
    arr.removeFirst()
    return (first, arr)
}

print(parse(args: Array(arguments[1...])))


