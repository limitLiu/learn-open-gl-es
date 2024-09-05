import GLKit

extension Array {
    var size: Int { MemoryLayout<Element>.stride * count }
}

typealias Matrix4 = GLKMatrix4

extension Matrix4 {
    var mat4: [GLfloat] {
        return [
            m.0, m.1, m.2, m.3,
            m.4, m.5, m.6, m.7,
            m.8, m.9, m.10, m.11,
            m.12, m.13, m.14, m.15
        ]
    }
    
    static var identity: Matrix4 { GLKMatrix4Identity }
    
    static func *(lhs: Self, rhs: Self) -> Self {
        return GLKMatrix4Multiply(lhs, rhs)
    }
}

