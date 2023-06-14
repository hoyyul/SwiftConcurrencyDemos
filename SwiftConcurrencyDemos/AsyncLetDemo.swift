//
//  AsyncLetDemo.swift
//  SwiftConcurrencyDemos
//
//  Created by Lu Haoyu on 2023/06/13.
//

import SwiftUI

struct AsyncLetDemo: View {
    
    @State private var images: [UIImage] = []
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let url = URL(string: "https://picsum.photos/200")!
    
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self){ image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
        }
        .navigationTitle("Title")
        .onAppear{
            Task{
                do{
                    /*let image1 = try await fetchImage()
                    self.images.append(image1)
                    
                    let image2 = try await fetchImage()
                    self.images.append(image2)
                    
                    let image3 = try await fetchImage()
                    self.images.append(image3)
                    
                    let image4 = try await fetchImage()
                    self.images.append(image4)*/
                    
                    async let fetchImage1 = fetchImage()
                    async let fetchImage2 = fetchImage()
                    async let fetchImage3 = fetchImage()
                    async let fetchImage4 = fetchImage()
                    
                    let(image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)//wait all async results then return; don't have to be same type.
                    
                    self.images.append(contentsOf: [image1, image2, image3, image4])
                    
                } catch {
                    
                }
            }
        }
    }
    
    func fetchImage() async throws -> UIImage{
        do{
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data){
                return image
            } else{
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}

struct AsyncLetDemo_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLetDemo()
    }
}