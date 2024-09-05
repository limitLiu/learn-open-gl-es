import GLKit

enum ShaderKind {
    case vertex
    case fragment
    
    var rawValue: GLenum {
        return switch self {
        case .vertex:
            GLenum(GL_VERTEX_SHADER)
        case .fragment:
            GLenum(GL_FRAGMENT_SHADER)
        }
    }
}


struct Shader {
    var program: GLuint
}

extension Shader {
    func compile(path: String, kind: ShaderKind) -> GLuint? {
        let content = try? String(contentsOfFile: path, encoding: .utf8).cString(using: .utf8)
        var source = UnsafePointer(content)
        let shader = glCreateShader(kind.rawValue)
        glShaderSource(shader, 1, &source, .none)
        glCompileShader(shader)
        var status = GLint()
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &status)
        if status == GL_FALSE {
            var log = [GLchar](repeating: 0, count: 512)
            glGetShaderInfoLog(shader, GLsizei(log.size), .none, &log)
            print("\(kind) Compile Error: \(String(describing: String(cString: log, encoding: .utf8)))")
            return .none
        }
        return shader
    }
    
    func make(_ vertexPath: String, _ fragmentPath: String) {
        if let vertexShader = compile(path: vertexPath, kind: .vertex),
           let fragmentShader = compile(path: fragmentPath, kind: .fragment) {
            glAttachShader(program, vertexShader)
            glAttachShader(program, fragmentShader)
            glLinkProgram(program)
            var linkStatus = GLint()
            glGetProgramiv(program, GLenum(GL_LINK_STATUS), &linkStatus)
            if linkStatus == GL_FALSE {
                var log = [GLchar](repeating: 0, count: 512)
                glGetProgramInfoLog(program, GLsizei(log.size), .none, &log)
                fatalError("Link Error: \(String(describing: String(cString: log, encoding: .utf8)))")
            }
            glDeleteShader(vertexShader)
            glDeleteShader(fragmentShader)
        }
    }
}

extension Shader {
    func getAttribLocation(name: UnsafePointer<GLchar>!) -> GLint {
        return glGetAttribLocation(program, name)
    }
    
    func use() {
        glUseProgram(program)
    }
    
    func setUniform4f(name: UnsafePointer<GLchar>!, x: GLfloat, y: GLfloat, z: GLfloat, w: GLfloat) {
        let location = glGetUniformLocation(program, name)
        glUniform4f(location, x, y, z, w)
    }
    
    func setInt(name: UnsafePointer<GLchar>!, x: GLint) {
        let location = glGetUniformLocation(program, name)
        glUniform1i(location, x)
    }
    
    func setFloat(name: UnsafePointer<GLchar>!, x: GLfloat) {
        let location = glGetUniformLocation(program, name)
        glUniform1f(location, x)
    }
    
    func setMat4(name: UnsafePointer<GLchar>!, x: Matrix4) {
        let location = glGetUniformLocation(program, name)
        x.mat4.withUnsafeBufferPointer { ptr in
            glUniformMatrix4fv(location, 1, GLboolean(GL_FALSE), ptr.baseAddress)
        }
    }
}
