//
//  ScannerView.swift
//  QRCodeScanner
//
//  Created by Yunus Emre Taşdemir on 18.09.2023.
//

import SwiftUI

struct ScannerView: View {
    // QR Code Scanner Properties
    @State private var isScanning: Bool = false
    var body: some View {
        VStack(spacing: 8) {
            Button {
                
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Place the QR code inside the area")
                .font(.title3)
                .foregroundColor(.black.opacity (0.8))
                .padding(.top, 20)
            
            Text("Scanning will start automatically")
                .font(.callout)
                .foregroundColor(.gray)
            
            Spacer(minLength: 0)
            
            // Scanner
            GeometryReader {
                let size = $0.size
                
                ZStack {
                    ForEach(0...4, id: \.self) { index in
                        let rotation = Double (index) * 90
                        
                        RoundedRectangle(cornerRadius: 2, style: .circular)
                            // Trimming to get Scanner like Edges
                            .trim(from: 0.61, to: 0.64)
                            .stroke(.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                            .rotationEffect(.init(degrees: rotation))
                    }
                    
                }
                // Sqaure Shape
                .frame(width: size.width, height: size.width)
                // Scanner Animation
                .overlay(alignment: .top, content: {
                    Rectangle()
                        .fill(.blue)
                        .frame(height: 2.5)
                        .shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: isScanning ? 15 : -15)
                        .offset(y: isScanning ? size.width : 0)
                })
                // To Make it Center
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, 45)
            
            Spacer(minLength: 15)
            
            Button {
                
            } label: {
                Image(systemName: "qrcode.viewfinder")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
            
            Spacer (minLength: 45)

        }
        .padding(15)
        // For UI Demo
        .onAppear {
            activateScannerAnimation()
        }
    }
    
    // Activating Scanner Animation Method
    func activateScannerAnimation() {
        // Adding Delay for Each Reversal
        withAnimation(.easeInOut(duration: 0.85).delay(0.1).repeatForever(autoreverses: true)) {
            isScanning = true
        }
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
