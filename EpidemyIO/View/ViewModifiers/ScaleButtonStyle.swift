//
//  ScaleButtonStyle.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 06.05.2023.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.scaleEffect(configuration.isPressed ? 0.92 : 1)
			.animation(.linear(duration: 0.05), value: configuration.isPressed)
	}
}
