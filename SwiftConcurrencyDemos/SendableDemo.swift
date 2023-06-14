//
//  SendableDemo.swift
//  SwiftConcurrencyDemos
//
//  Created by Lu Haoyu on 2023/06/14.
//

import SwiftUI

actor CurrentUserManager{
    
    func updateDatabase(userInfo: MyClassUserInfo){
        
    }
    
}

struct MyUserInfo: Sendable{ // sendable means safe for concurrent context
    let name: String
}

final class MyClassUserInfo: Sendable{ //only final class can conform to sendable and variables are all constant
    let name: String
    
    init(name: String) {
        self.name = name
    }
}


class SendableDemoViewModel: ObservableObject{
    
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async{
        
        //let info = "Info"
        //let info = MyUserInfo(name: "Info")
        let info = MyClassUserInfo(name: "info")
        
        await manager.updateDatabase(userInfo: info)
    }
    
    
}

struct SendableDemo: View {
    
    @StateObject private var viewModel = SendableDemoViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {
                <#code#>
            }
    }
}

struct SendableDemo_Previews: PreviewProvider {
    static var previews: some View {
        SendableDemo()
    }
}
