//
//  NavigationLazyView.swift
//  BerryQuest
//
//  Created by 김수경 on 10/14/24.
//

import SwiftUI

// 실제 View의 초기화를 지연시키고, 실제로 필요할 때에만 View를 생성하기 위함
struct NavigationLazyView<Content: View>: View {
    
    let closure: () -> Content
    
    var body: some View {
        closure()
    }
    
    init(_ closure: @autoclosure @escaping () -> Content) {
        self.closure = closure
    }
}

