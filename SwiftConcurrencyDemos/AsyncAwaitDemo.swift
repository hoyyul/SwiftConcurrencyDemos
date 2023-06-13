//
//  AsyncAwaitDemo.swift
//  SwiftConcurrencyDemos
//
//  Created by Lu Haoyu on 2023/06/13.
//

import SwiftUI
 
class AsyncAwaitDemoViewModel: ObservableObject{
    
    @Published var dataArray: [String] = []
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.dataArray.append("Title1: \(Thread.current)")
        }
    }
    
    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2){
            let title = "Title1: \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title)
                
                let title3 = "Title3: \(Thread.current)"
                self.dataArray.append(title)
            }
        }
    }
    
    func addAuthor1() async{// doesn't necessarily to go to another thread, sometimes it will, sometimes not; await is a switching point!
        let author1 = "Author1: \(Thread.current)"
        self.dataArray.append(author1)
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let author2 = "Author2: \(Thread.current)"
        await MainActor.run(body:{//if not sure which thread it is, jump to main thread before update Ui
            self.dataArray.append(author2)
            
            let author3 = "Author3: \(Thread.current)"
            self.dataArray.append(author3)
        })
    }
    
    func addSomething() async{
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let something1 = "Something1: \(Thread.current)"
        await MainActor.run (body:{
            self.dataArray.append(something1)
            
            let something2 = "Something2: \(Thread.current)"
            self.dataArray.append(something2)
        })
    }
    
}

struct AsyncAwaitDemo: View {
    
    @StateObject private var viewModel = AsyncAwaitDemoViewModel()
    
    var body: some View {
        List{
            ForEach(viewModel.dataArray, id: \.self){ data in
                Text(data)
            }
        }
        .onAppear{
            Task{
                await viewModel.addAuthor1()
                await viewModel.addSomething()
            }
            //viewModel.addTitle1()
            //viewModel.addTitle2()
        }
    }
}

struct AsyncAwaitDemo_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwaitDemo()
    }
}
