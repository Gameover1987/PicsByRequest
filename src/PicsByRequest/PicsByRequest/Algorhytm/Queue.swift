
import Foundation

/// Очень странно как это в Swift нет очереди, пришлосьсвою написать, да здравствует велосипедный спорт!
struct Queue<T> {
    private var elements: [T] = []
    
    /// Add element to Queue
    mutating func enqueue(_ value: T) {
        elements.append(value)
    }
    
    ///  Get first element from and remove it from inner collection
    mutating func dequeue() -> T? {
        guard !elements.isEmpty else {
            return nil
        }
        return elements.removeFirst()
    }
    
    /// Head of the Queue
    var head: T? {
        return elements.first
    }
    
    /// Tail of the Queue
    var tail: T? {
        return elements.last
    }
    
    var count: Int {
        return elements.count
    }
}
