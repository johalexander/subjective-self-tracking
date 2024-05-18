//
//  NavigationDetails.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 18/05/2024.
//

import Foundation
import SwiftUI

struct Learn: View {
    @EnvironmentObject var manager: DataModelManager
    var item: Item
    
    var title: String {
        return (item.imageName) + " " + (item.title)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 24) {
                            CircleImage(image: Image("Prototype").resizable())
                                .frame(width: 160, height: 160)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Enhancing Self-Tracking: A Next-Generation Prototype for Subjective Phenomena Tracking through Gesture Interfaces")
                                        .font(.title)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("MSc Thesis - Alexander Nils Tommy Johansson")
                                }
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            }
                        }
                        .padding()
                        
                        Divider()
                        
                        VStack(alignment: .leading) {
                            Text("What")
                                .font(.title2)
                            Text("... is it?")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            Text("In recent years, self-tracking or self-quantification has gained popularity, from tracking routine occurrences like sneezing to complex subjective experiences such as PTSD symptoms. The One Button Tracker, a simple yet versatile device, enables users to gain deeper insights into the phenomena they track. This project aims to develop a next-generation self-tracking prototype capable of discerning hand and arm placement in real 3D space. The goal is to introduce modality through gestures when tracking subjective phenomena.")
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                        }
                        
                        VStack(alignment: .leading) {
                            Text("How")
                                .font(.title2)
                            Text("... does it work?")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        
                            Text("The prototype utilises absolute orientation to discern specific arm and wrist movements, introducing modality without the need for explicit tracking modes. For instance, a specific arm movement coupled with a click could represent a sneeze, while another movement could signify a cough. The introduction of modality aims to add the possibility to classify the tracked phenomena, without impacting device feedback.")
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                         }
                        
                        VStack(alignment: .leading) {
                            Text("Why")
                                .font(.title2)
                            Text("... is this important?")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        
                            Text("Recent studies applying self-tracking prototypes in various health-related contexts have demonstrated its potential for personal knowledge gain and therapeutic significance. Incorporating feedback and insights from previous studies to overcome current limitations and provide enhanced benefits is paramount for future work. This work intends to lay a foundation for gesture-based modality in a self-tracking context.")
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                            }
                    }
                    
                    Divider()
                    
                    DisclosureGroup("What do I need to know?") {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Understanding Euler angles")
                                .font(.title3)
                            HStack(alignment: .top, spacing: 24) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Imagine three lines running through an airplane and intersecting at right angles at the airplane's center of gravity. Rotation around the front-to-back axis is called roll. Rotation around the side-to-side axis is called pitch. Rotation around the vertical axis is called yaw.")
                                    
                                    Text("This prototype reads all rotation axes, but for the sake of the experiments you will participate in, only pitch and roll are relevant.")
                                    
                                    Text("The movement for adjusting pitch is done by rotating the arm around the elbow.")
                                    
                                    Text("The movement for adjusting roll is done by rotating the wrist/lower arm.")
                                }
                                
                                SquareImage(image: Image("EulerAngles").resizable())
                                    .frame(width: 160, height: 160)
                            }
                            
                            Text("Visual Analogue Scale - Physical Analogue Scale")
                                .font(.title3)
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                            HStack(alignment: .top, spacing: 24) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("A Visual Analogue Scale (VAS) is one of the pain rating scales used for the first time in 1921 by Hayes and Patterson. It is often used in clinical research to measure the intensity or frequency of various symptoms. Participants indicate a response by positioning a slider (most-left position = lowest scale value, most-right position = higest scale value).")
                                    
                                    Text("The VAS is applied in this context to rate the greyness of a given greyscale image and assess a number on a linear scale.")
                                }
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("A Physical Analogue Scale (PAS) uses the position of a participant's forearm as a continuous response scale. Participants indicate a response by positioning their forearm flat (0 degrees = lowest scale value), in a fully upright position or rotated position (90 degrees = highest scale value), or somewhere in-between.")
                                    
                                    Text("The PAS is applied in this context to rate the greyness of a given greyscale image and assess a number on a continous response scale.")
                                }
                            }
                            HStack(spacing: 20) {
                                Spacer()
                                SquareImage(image: Image("EulerAngles").resizable())
                                    .frame(width: 160, height: 160)
                                
                                Spacer()
                                
                                SquareImage(image: Image("EulerAngles").resizable())
                                    .frame(width: 160, height: 160)
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                        }
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    }
                    
                    Divider()
                    
                    HStack {
                        Spacer()
                        NavigationLink {
                            Practice(item: item)
                                .environmentObject(manager)
                        } label: {
                            Text("Let's try it out!")
                        }
                        .buttonStyle(.borderedProminent)
                        .navigationTitle(title)
                        Spacer()
                    }
                }
                .padding()
            }
        }
        .navigationTitle(title)
    }
}

#Preview {
    Learn(item: Item(title: "Learn", imageName: "💪🏻"))
        .environmentObject(DataModelManager())
}
