import Foundation

/// CustomView를 생성할 때 준수해야할 프로토콜 (사용한 함수들을 명세)
protocol UIProtocol {
    /// addSubView 관련 함수
    func setViews()
    /// 제약조건 설정 관련 함수
    func setContraints()
}
