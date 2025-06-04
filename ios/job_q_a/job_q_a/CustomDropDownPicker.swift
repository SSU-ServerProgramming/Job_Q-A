import SwiftUI

// 드롭다운 메뉴 상태를 정의하는 열거형
enum CustomDropDownPickerState {
    case top, bottom
}

struct CustomDropDownPicker: View {
    
    @Binding var selection: String
    @Binding var selectedIndex: Int
    
    // 드롭다운 메뉴가 나타날 위치를 정의
    var state: CustomDropDownPickerState = .bottom
    
    // 드롭다운에 표시할 옵션 배열
    var options: [String]
    
    // 드롭다운 메뉴를 보여줄지 여부를 상태 변수로 관리
    @State var showDropdown = false
    
    // SceneStorage를 사용하여 드롭다운 메뉴의 z-index를 관리 (드롭다운 메뉴가 항상 다른 UI 요소 위에 나타나고, 사용자가 앱을 재시작해도 z-index 상태가 유지되도록 함)
    @SceneStorage("drop_down_zindex") private var index = 1000.0
    @State var zindex = 1000.0
    
    
    var body: some View {
        // GeometryReader를 사용하여 뷰의 크기를 읽음
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 0) {
                // 드롭다운 메뉴가 상단에 위치할 때 옵션을 표시
                if state == .top && showDropdown {
                    OptionsView()
                }
                
                HStack {
                    // 선택된 항목을 텍스트로 표시
                    Text(selection)
                        .foregroundColor(selection != nil ? Color("secondary_") : Color("secondary_"))
                    
                    Spacer(minLength: 0)
                    
                    // 드롭다운 메뉴 아이콘
                    Image(systemName: state == .top ? "chevron.up" : "chevron.down")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees((showDropdown ? -180 : 0))) // 드롭다운 메뉴가 열릴 때 아이콘을 회전
                }
                .padding(.horizontal, 15)
                .frame(height: 60)
                .background(.white)
                .contentShape(.rect)
                .onTapGesture {
                    // 드롭다운 메뉴를 토글
                    index += 1
                    zindex = index
                    withAnimation(.snappy) {
                        showDropdown.toggle()
                    }
                }
                .zIndex(10)
                
                // 드롭다운 메뉴가 하단에 위치할 때 옵션을 표시
                if state == .bottom && showDropdown {
                    OptionsView()
                }
            }
            .clipped()
            .background(.white)
            .cornerRadius(10)
            .overlay {
                // 드롭다운 메뉴의 테두리
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray)
            }
            .frame(height: size.height, alignment: state == .top ? .bottom : .top)
        }
        .zIndex(zindex)
    }
    
    // 드롭다운 메뉴 옵션을 정의하는 뷰
    func OptionsView() -> some View {
        ScrollView {
            ForEach(options.indices, id: \.self) { index in
                HStack {
                    Text(options[index])
                    
                    Spacer()
                    
                    Image(systemName: "checkmark")
                        .opacity(selectedIndex == index ? 1 : 0)
                }
                .foregroundStyle(selectedIndex == index ? Color("secondary_") : Color("secondary_"))
                .animation(.none, value: selectedIndex)
                .frame(height: 30)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        selectedIndex = index
                        selection = options[index]
                        showDropdown.toggle()
                    }
                }
            }
        }
        .padding(.horizontal, 15)
        //.frame(width: 300)
        .transition(.move(edge: state == .top ? .bottom : .top))
        .zIndex(1)
    }
}

