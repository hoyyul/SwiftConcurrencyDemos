//
//  TaskDemo.swift
//  SwiftConcurrencyDemos
//
//  Created by Lu Haoyu on 2023/06/13.
//

import SwiftUI

class TaskDemoViewModel: ObservableObject{
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        do{
            guard let url = URL(string: "https://picsum.photos/200")  else{ return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run(body: {
                self.image = UIImage(data: data)
                print("Get image successfullt")
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do{
            guard let url = URL(string: "https://picsum.photos/200")  else{ return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run(body: {
                self.image = UIImage(data: data)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

struct TaskDemoHomeView: View{
    
    var body: some View {
        NavigationView {
            ZStack{
                NavigationLink("Click!"){
                    TaskDemo()
                }
            }
        }
    }
    
}

struct TaskDemo: View {
    
    @StateObject private var viewModel = TaskDemoViewModel()
    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack(spacing: 40){
            if let image = viewModel.image{
                Image(uiImage:  image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            if let image = viewModel.image2{
                Image(uiImage:  image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .onDisappear{//cancel image when view gone
            fetchImageTask?.cancel()
        }
        .onAppear{//Task is block for writing concurrency code.
            fetchImageTask = Task{
                await viewModel.fetchImage()
            }

            
            /*Task(priority: .high) {
                await Task.yield()// can change priority, yield, sleep to change the order
                print(Thread.current)
                print(Task.currentPriority)
            }
            Task(priority: .low) {
                print(Thread.current)
                print(Task.currentPriority)
            }
            Task(priority: .medium) {
                print(Thread.current)
                print(Task.currentPriority)
            }
            Task(priority: .background){//background is always the last
                print(Thread.current)
                print(Task.currentPriority)
            }*/
            
            /*Task(priority: .userInitiated) {
                print(Thread.current)
                print(Task.currentPriority)
                
                Task{
                    print(Thread.current)
                    print(Task.currentPriority)//child task has same priority
                }
            }*/
            
            
            
        }
        
    }
}

struct TaskDemo_Previews: PreviewProvider {
    static var previews: some View {
        TaskDemo()
    }
}
