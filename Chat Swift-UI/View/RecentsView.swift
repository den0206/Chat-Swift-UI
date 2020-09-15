//
//  RecentsView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/16.
//

import SwiftUI

struct RecentsView: View {
    var body: some View {
        
        VStack(spacing : 0){
            RecentsHeaderView()
            
            RecentsCenterView()
        }
    }
}

struct RecentsHeaderView : View {
    
    @State private var search = ""
    
    var body: some View {
        
        VStack(spacing : 18) {
            
            HStack() {
                Text("Message")
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(Color.black.opacity(0.7))
                
                Spacer(minLength: 0)
                
                Button(action: {print("List")}) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                }
                
               
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing : 18) {
                    
                    /// plus Button
                    Button(action: {}) {
                        
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color.gray)
                            .padding(18)
                    }.background(Color.gray.opacity(0.5))
                    .clipShape(Circle())
                    
                    ForEach(1...7 , id : \.self) { i in
                        
                        Button(action: {}) {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 60, height: 60)
                        }
                        
                    }
                    
                    
                }
            }
            
            /// serach
            HStack(spacing : 15) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(Color.black.opacity(0.3))
                
                TextField("Search", text: $search)
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .padding(.bottom,10)
        }
        .padding()
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .background(Color(.systemGroupedBackground))
        .clipShape(RecentShape())
        .animation(.default)
    }
}

struct RecentsCenterView : View {
    
    var body: some View {
        
        
        
        List(data) { i in
            
            RecentCellView(msg: i)
        }
        .padding(.top, 20)
        .background(Color.white)
        .clipShape(RecentShape())
        
    }
}

struct RecentCellView : View {
    
    var msg : exampleMsg
    
    
    var body: some View {
        
        HStack(spacing : 12) {
            
            Circle()
                .fill(Color.gray)
                .frame(width: 60, height: 60)
            
//            Image(msg.img)
//                .resizable()
//                .frame(width: 25, height: 25)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(msg.name)
                Text(msg.msg)
                    .font(.caption)
            }
            
            Spacer(minLength: 0)
            
            VStack {
                Text(msg.date)
                Spacer()
            }
        }
        .padding(.vertical)
    }
}

struct  RecentShape : Shape {
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 30, height: 30))
        
        return Path(path.cgPath)
    }
}

struct RecentsView_Previews: PreviewProvider {
    static var previews: some View {
        RecentsView()
    }
}

/// Example Data


struct exampleMsg : Identifiable {
    
    var id : Int
    var name : String
    var msg : String
    var date : String
    var img : String
}

var data = [
    
    exampleMsg(id: 0, name: "Emily", msg: "Hello!!!", date: "25/03/20",img: "p1"),
    exampleMsg(id: 1, name: "Jonh", msg: "How Are You ???", date: "22/03/20",img: "p2"),
    exampleMsg(id: 2, name: "Catherine", msg: "New Tutorial From Kavsoft", date: "20/03/20",img: "p3"),
    exampleMsg(id: 3, name: "Emma", msg: "Hey Everyone", date: "25/03/20",img: "p4"),
    exampleMsg(id: 4, name: "Lina", msg: "SwiftUI Tutorials", date: "25/03/20",img: "p5"),
    exampleMsg(id: 5, name: "Steve Jobs", msg: "New Apple iPhone", date: "15/03/20",img: "p6"),
    exampleMsg(id: 6, name: "Roy", msg: "Hey Guys!!!", date: "25/03/20",img: "p7"),
    exampleMsg(id: 7, name: "Julia", msg: "Hello!!!", date: "25/03/20",img: "p1"),
    exampleMsg(id: 8, name: "Watson", msg: "How Are You ???", date: "22/03/20",img: "p2"),
    exampleMsg(id: 9, name: "Kavuya", msg: "New Tutorial From Kavsoft", date: "20/03/20",img: "p3"),
    exampleMsg(id: 10, name: "Julie", msg: "Hey Everyone", date: "25/03/20",img: "p4"),
    exampleMsg(id: 11, name: "Lisa", msg: "SwiftUI Tutorials", date: "25/03/20",img: "p5"),
    
]

