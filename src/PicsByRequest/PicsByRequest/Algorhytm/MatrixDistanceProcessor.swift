
import Foundation

final class MatrixDistanceProcessor {
    private let sourceMatrix: [[Bool]]
    
    private var nodes = [[Int]]()
    private let rowCount: Int
    private let columnCount: Int
    
    private var distances: [Int]
    private var visited: [Bool]
    
    private var queue = Queue<Int>()
    
    init(by matrix: [[Int]]) {
        sourceMatrix = MatrixDistanceProcessor.intMatrixToBoolMatrix(matrix: matrix)
        rowCount = matrix.count
        columnCount = matrix[0].count
        
        /// Создаем массив для маркировки посещенных и не посещенных вершин
        distances = Array<Int>(repeating: 0, count: rowCount * columnCount)
        visited = Array<Bool>(repeating: false, count: rowCount * columnCount)
        
        initGraph()
        initQueue()
    }
    
    private static func intMatrixToBoolMatrix(matrix: [[Int]]) -> [[Bool]]
    {
        let rows = matrix.count
        let cols = matrix.first!.count
        
        var boolMatrix = [[Bool]]()
        for row in 0...rows - 1 {
            boolMatrix.append([Bool]())
            for col in 0...cols - 1 {
                boolMatrix[row].append(matrix[row][col] == 1)
            }
        }
        
        return boolMatrix
    }
    
    private func initGraph() {
        
        for _ in 0..<rowCount * columnCount + 1 {
            nodes.append([Int]())
        }
        
        for row in 0..<rowCount {
            for col in 0..<columnCount {
                let idx = col + row * columnCount
                let hasLeftNeighbor = col > 0
                let hasRightNeighbor = col < columnCount - 1
                let hasTopNeightbor = row > 0
                let hasBottomNeightbor = row < rowCount - 1
                
                if hasLeftNeighbor {
                    nodes[idx].append(idx - 1)
                }
                
                if hasRightNeighbor {
                    nodes[idx].append(idx + 1);
                }
                
                if hasTopNeightbor {
                    nodes[idx].append(idx - columnCount)
                }
                
                if hasBottomNeightbor {
                    nodes[idx].append(idx + columnCount)
                }
            }
        }
    }
    
    private func initQueue() {
        
        // Инициализируем массивы
        for i in 0...rowCount * columnCount - 1 {
            distances[i] = Int.max
            visited[i] = false
        }
        
        // Создаем очередь, инициализируем ее теми элементами матрицы, где лежит 1
        for row in 0...rowCount - 1 {
            for col in 0...columnCount - 1 {
                let idx = col + row * columnCount
                if sourceMatrix[row][col] {
                    distances[idx] = 0
                    visited[idx] = true
                    queue.enqueue(idx)
                }
            }
        }
    }
    
    func process() -> [Int] {
        while queue.count != 0 {
            let temp = queue.dequeue()!
            
            for i in 0..<nodes[temp].count {
                if visited[nodes[temp][i]] != true {
                    distances[nodes[temp][i]] = min(nodes[temp][i], distances[temp] + 1)
                    queue.enqueue(nodes[temp][i])
                    visited[nodes[temp][i]] = true
                }
            }
        }
        
        return distances
    }
}
