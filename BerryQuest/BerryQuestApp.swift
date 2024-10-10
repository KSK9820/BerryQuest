//
//  BerryQuestApp.swift
//  BerryQuest
//
//  Created by 김수경 on 10/9/24.
//

import SwiftUI
import KakaoMapsSDK

@main
struct BerryQuestApp: App {
    var body: some Scene {
        WindowGroup {
            MapView()
                .onAppear(perform: {
                    SDKInitializer.InitSDK(appKey: Bundle.main.infoDictionary?["KakaoAppKey"] as! String)
                })
        }
    }
}

