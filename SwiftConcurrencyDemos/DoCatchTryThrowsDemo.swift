//
//  DoTryCatchThrowsDemos.swift
//  SwiftConcurrencyDemos
//
//  Created by Lu Haoyu on 2023/06/12.
//

import SwiftUI

// do-catch
// try
// throws

class DoCatchTryThrowsDemosDataManager{
    
    let isActive: Bool = false
    
    func getTitle() -> (title: String?, error: Error?){
        if isActive{
            return ("New Text!", nil)
        }
        else{
            return (nil, URLError(.badURL))
        }
    }
    
    func getTiltle2() -> Result<String, Error>{
        if isActive{
            return.success("New Text")
        } else{
            return.failure(URLError(.appTransportSecurityRequiresSecureConnection))
        }
    }
    
    func getTiltle3() throws -> String{// try to return a String if its failed throw an Error
        if isActive{
            return "New Text!"
        }
        else{
            throw URLError(.badServerResponse)
        }
    }
    
    func getTiltle4() throws -> String{
        if isActive{
            return "New Text!"
        }
        else{
            throw URLError(.badServerResponse)
        }
    }
    
}

class DoCatchTryThrowsDemosViewModel: ObservableObject{
    
    @Published var text: String = "Starting text."
    let manager = DoCatchTryThrowsDemosDataManager()
    
    func fetchTitle(){
        /*let returnedValue = manager.getTitle()
         if let newTitle = returnedValue.title{
         self.text = newTitle
         } else if let error = returnedValue.error {
         self.text = error.localizedDescription
         }*/
        /*let result = manager.getTiltle2()
        
        switch result{
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }*/
        /*do{
            let newTitle = try manager.getTiltle3()
            self.text = newTitle
        } catch let error{
            self.text = error.localizedDescription
        }*/
        
        let finalTitle = try? manager.getTiltle4()
        if let newTitle = finalTitle{
            self.text = newTitle
        }
        
    }
}


struct DoCatchTryThrowsDemos: View {
    
    @StateObject private var viewModel = DoCatchTryThrowsDemosViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

struct DoTryCatchThrowsDemos_Previews: PreviewProvider {
    static var previews: some View {
        DoCatchTryThrowsDemos()
    }
}
