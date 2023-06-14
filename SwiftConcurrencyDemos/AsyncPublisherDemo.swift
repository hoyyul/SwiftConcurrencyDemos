//
//  AsyncPublisherDemo.swift
//  SwiftConcurrencyDemos
//
//  Created by Lu Haoyu on 2023/06/15.
//

import SwiftUI
import Combine

class AsyncPublisherDataManager{
    
    @Published var myData: [String] = []
    
    func addData() async{
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Banana")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Orange")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Watermelon")
    }
    
}

class AsyncPublisherDemoViewModel: ObservableObject{
    
    @MainActor @Published var dataArray: [String] = []
    let manager = AsyncPublisherDataManager()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscriber()
    }
    
    private func addSubscriber(){
        // async way to do this
        
        Task{
            for await value in manager.$myData.values{
                await MainActor.run(body: {
                    self.dataArray = value
                })
            }
            
            //code here never execute
        }
        
//        //a combine way to do this
//        manager.$myData //This publisher will emit every time the myData property mutates
//            .receive(on: DispatchQueue.main)
//            .sink { dataArray in
//                self.dataArray = dataArray
//            }
//            .store(in: &cancellables)
        
            
    }
    
    
    func start() async{
        await manager.addData()
    }
    
}


struct AsyncPublisherDemo: View {
    
    @StateObject private var viewModel = AsyncPublisherDemoViewModel()
    
    var body: some View {
        ScrollView {
            VStack{
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.start()
        }
    }
}

struct AsyncPublisherDemo_Previews: PreviewProvider {
    static var previews: some View {
        AsyncPublisherDemo()
    }
}
