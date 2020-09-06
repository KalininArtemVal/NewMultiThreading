import Foundation


public struct Bread {
    public enum BreadType: UInt32 {
        case small = 1
        case medium
        case big
    }
    
    public let breadType: BreadType
    
    public static func make() -> Bread {
        guard let breadType = Bread.BreadType(rawValue: UInt32(arc4random_uniform(3) + 1)) else {
            fatalError("Incorrect random value")
        }
        
        return Bread(breadType: breadType)
    }
    
    public func bake() {
        let bakeTime = breadType.rawValue
        sleep(UInt32(bakeTime))
    }
}

struct BreadStorage {
    var storage = [Bread]()
    var conditional = NSCondition()
    var avalible = false
    
    mutating func push() {
        conditional.lock()
        let bread = Bread.make()
        storage.append(bread)
        avalible = true
        print("Хлеб в печи")
        conditional.signal()
        conditional.unlock()
    }
    
    mutating func pop() {
        while !avalible {
            print("жду")
            conditional.wait()
        }
        storage.removeLast().bake()
        avalible = false
        print("вытащил")
    }
}

class ParentThread: Thread {
    var bread = BreadStorage()
    
    override func main() {
        let myTimer = Timer(timeInterval: 2, target: self, selector: #selector(pushInThread), userInfo: nil, repeats: true)
        RunLoop.current.add(myTimer, forMode: RunLoop.Mode.common)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 20))
        print("ХЛЕБОПЕЧКА ЗАКРЫТА!")
    }
    
    @objc func pushInThread() {
        self.bread.push()
    }
}
class WorkingThread: Thread {
    
    override func main() {
        let mySecondTimer = Timer(timeInterval: 0 , target: self, selector: #selector(popInThread), userInfo: nil, repeats: true)
        RunLoop.current.add(mySecondTimer, forMode: RunLoop.Mode.common)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 20))
        print("ЗАКОНЧИЛ")
    }
    
    @objc func popInThread() {
        parentThread.bread.pop()
    }
}



let parentThread = ParentThread()
let workingThread = WorkingThread()
parentThread.start()
workingThread.start()

