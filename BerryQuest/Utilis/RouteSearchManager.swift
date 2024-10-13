//
//  RouteSearchManager.swift
//  BerryQuest
//
//  Created by 김수경 on 10/12/24.
//

import Foundation
import Combine
import SwiftUI

typealias Edge = (d: Int, w: Double)

final class RouteSearchManager {
    
    var coordinates: [Coordinate]
    
    init(coordinates: [Coordinate]) {
        self.coordinates = coordinates
    }
    
    func getShortestPathWithTSP() -> [Int] {
        let n = coordinates.count
        let INF = Double(Int.max)
        let weight = getDistance()
        
        var dp = [[Double]](repeating: [Double](repeating: INF, count: n), count: 1 << n)
        var route = [[Int]](repeating: [Int](repeating: -1, count: n), count: 1 << n)
        
        dp[1<<0][0] = 0
        
        for mask in 0..<(1<<n) {
            for u in 0..<n {
                if (mask & (1 << u)) == 0 { continue }
                for v in 0..<n {
                    if (mask & (1 << v)) != 0 || weight[u][v] == 0 { continue }
                    
                    let newMask = mask | (1 << v)
                    let newCost = dp[mask][u] + weight[u][v]
                    
                    if dp[newMask][v] > newCost {
                        dp[newMask][v] = newCost
                        route[newMask][v] = u
                    }
                }
            }
        }
        
        // 최소 비용
        var minCost = INF
        var lastVertex = -1
        let finalMask = (1 << n) - 1
        
        for i in 1..<n {
            if dp[finalMask][i] < minCost {
                minCost = dp[finalMask][i]
                lastVertex = i
            }
        }
        
        // 경로
        var path = [lastVertex]
        var currentMask = finalMask
        var currentVertex = lastVertex
        
        while currentVertex != 0 {
            let previousVertext = route[currentMask][currentVertex]
           
            path.append(previousVertext)
            currentMask ^= (1 << currentVertex)
            currentVertex = previousVertext
        }
        
        path.reverse()
        
        return path
    }
    
    private func getDistance() -> [[Double]] {
        var distance = Array(repeating: Array(repeating: 0.0, count: coordinates.count), count: coordinates.count)
        
        for c1 in 0..<coordinates.count - 1{
            for c2 in (c1 + 1)..<coordinates.count {
                let d = calculateDistance(coordinates[c1], coordinates[c2])
                
                distance[c1][c2] = d
                distance[c2][c1] = d
            }
        }
        
        return distance
    }
     
    private func calculateDistance(_ c1: Coordinate, _ c2: Coordinate) -> Double {
        sqrt(pow(abs(c1.latitude - c2.latitude), 2) + pow(abs(c1.longitude - c2.longitude), 2))
    }
    
}


