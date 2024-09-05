import UIKit
import GLKit
import OpenGLES.ES3.glext

class ViewController: GLKViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        compile()
        triangle()
    }
    private var VAO: GLuint = GLuint()
    private var VBO: GLuint = GLuint()
    private var EBO: GLuint = GLuint()
    private lazy var shader = Shader(program: glCreateProgram())
    private lazy var texture1: Texture? = {
        if let bundle = Bundle.main.path(forResource: "textures", ofType: "bundle"),
           let container = UIImage(contentsOfFile: bundle.appending("/container.jpg"))?.cgImage {
            return Texture(image: container)
        }
        return .none
    }()
    
    private lazy var texture2: Texture? = {
        if let bundle = Bundle.main.path(forResource: "textures", ofType: "bundle"),
           let face = UIImage(contentsOfFile: bundle.appending("/awesomeface.png"))?.cgImage {
            return Texture(image: face)
        }
        return .none
    }()
    
    override var prefersStatusBarHidden: Bool { true }
    
    deinit {
        glDeleteVertexArrays(1, &VAO)
        glDeleteBuffers(1, &VBO)
        glDeleteBuffers(1, &EBO)
    }
}

extension ViewController {
    func setup() {
        guard let context = EAGLContext(api: .openGLES3) else {
            fatalError("Failed to make eagl context")
        }
        guard let view = self.view as? GLKView else {
            fatalError("Failed to get glk view")
        }
        view.context = context
        view.drawableDepthFormat = .format24
        view.drawableColorFormat = .RGBA8888
        EAGLContext.setCurrent(context)
    }
    
    private func compile() {
        guard let vertexPath = Bundle.main.path(forResource: "shader", ofType: "vert") else {
            fatalError("Failed to get shader.vert")
        }
        guard let fragmentPath = Bundle.main.path(forResource: "shader", ofType: "frag") else {
            fatalError("Failed to get shader.frag")
        }
        shader.make(vertexPath, fragmentPath)
    }
    
    func triangle() {
        let vec: [GLfloat] = [
             // right top        color     texture
             0.5,  0.5, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0,
             // right bottom
             0.5, -0.5, 0.0, 0.0, 1.0, 0.0, 1.0, 0.0,
            // left bottom
            -0.5, -0.5, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0,
            // left top
            -0.5,  0.5, 0.0, 1.0, 1.0, 0.0, 0.0, 1.0
        ]
        
        let indices: [GLuint] = [
            0, 1, 3,
            1, 2, 3
        ]
        
        glEnable(GLenum(GL_DEPTH_TEST))
        glClearColor(0.1, 0.2, 0.2, 1.0)
        glGenVertexArrays(1, &VAO)
        glBindVertexArray(VAO)
        glGenBuffers(1, &VBO)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO)
        glBufferData(GLenum(GL_ARRAY_BUFFER), vec.size, vec, GLenum(GL_STATIC_DRAW))
        
        glGenBuffers(1, &EBO)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), EBO)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), indices.size, indices, GLenum(GL_STATIC_DRAW))
        
        let aPosition = shader.getAttribLocation(name: "aPosition")
        glEnableVertexAttribArray(GLuint(aPosition))
        glVertexAttribPointer(
            GLuint(aPosition), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.stride * 8), .none)
        
        let aColor = shader.getAttribLocation(name: "aColor")
        glEnableVertexAttribArray(GLuint(aColor))
        glVertexAttribPointer(GLuint(aColor), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.stride * 8), UnsafePointer(bitPattern: MemoryLayout<GLfloat>.stride * 3))
        
        let aTexCoord = shader.getAttribLocation(name: "aTexCoord")
        glEnableVertexAttribArray(GLuint(aTexCoord))
        /// 如何从 vec 取值，从 VBO（顶点缓冲区对象）地址开始取指针偏移 6 个 GLfloat，每次取的步长是 8 个 GLfloat
        glVertexAttribPointer(GLuint(aTexCoord), 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.stride * 8), UnsafePointer(bitPattern: MemoryLayout<GLfloat>.stride * 6))
        shader.use()
        shader.setInt(name: "texture1", x: GL_TEXTURE0 - GL_TEXTURE0)
        shader.setInt(name: "texture2", x: GL_TEXTURE1 - GL_TEXTURE0)
    }
    
    private var time: GLfloat { return GLfloat(CACurrentMediaTime()) }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        glActiveTexture(GLenum(GL_TEXTURE0))
        if let tex1 = texture1?.tex {
            glBindTexture(GLenum(GL_TEXTURE_2D), tex1)
        }
        glActiveTexture(GLenum(GL_TEXTURE1))
        if let tex2 = texture2?.tex {
            glBindTexture(GLenum(GL_TEXTURE_2D), tex2)
        }
        shader.setFloat(name: "mixVal", x: sin(time))
        let translateM = GLKMatrix4Translate(Matrix4.identity, 0.2, -0.2, 0)
        let rotateM = GLKMatrix4MakeRotation(time.truncatingRemainder(dividingBy: 360), 0, 0, 1)
        shader.setMat4(name: "transform", x: translateM * rotateM)

        glBindVertexArray(VAO)
        glDrawElements(GLenum(GL_TRIANGLES), 6, GLenum(GL_UNSIGNED_INT), .none)
    }
}
