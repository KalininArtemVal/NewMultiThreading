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

class BreadStorage {
    private var storage = [Bread]()
    private var conditional = NSCondition()
    private var avalible = false
    var count: Int {
        return storage.count
    }
    
    func push() {
        conditional.lock()
        let bread = Bread.make()
        storage.append(bread)
        avalible = true
        print("Хлеб в печи")
        conditional.signal()
        conditional.unlock()
    }
    
    func pop() {
        
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
    
    private let storage: BreadStorage
    init(storage: BreadStorage) {
        self.storage = storage
    }
    
    override func main() {
        let myTimer = Timer(timeInterval: 2, target: self, selector: #selector(pushInThread), userInfo: nil, repeats: true)
        RunLoop.current.add(myTimer, forMode: RunLoop.Mode.common)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 20))
        print("ХЛЕБОПЕЧКА ЗАКРЫТА!")
    }
    
    @objc func pushInThread() {
        storage.push()
    }
}
class WorkingThread: Thread {
    
    private let storage: BreadStorage
    init(storage: BreadStorage) {
        self.storage = storage
    }
    
    override func main() {
        
        while parentThread.isExecuting || storage.count > 0 {
            storage.pop()
        }
        print("Мы тоже закончили")
    }
}


var storage = BreadStorage()

let parentThread = ParentThread(storage: storage)
let workingThread = WorkingThread(storage: storage)
parentThread.start()
workingThread.start()

