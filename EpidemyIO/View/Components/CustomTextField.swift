//
//  CustomTextField.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 06.05.2023.
//

import SwiftUI

struct CustomNumberTextField: View {
	
	var placeholder: String
	@Binding var value: Int?
	
	var body: some View {
		TextField(placeholder, value: $value, format: .number)
			.padding(10)
			.background(Color.init(.systemGray6))
			.clipShape(Capsule())
	}
}
