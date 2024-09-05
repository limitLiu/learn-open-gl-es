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
    private lazy var shader = Shader(program: glCreateProgram())
    
    override var prefersStatusBarHidden: Bool { true }
    
    deinit {
        glDeleteVertexArrays(1, &VAO)
        glDeleteBuffers(1, &VBO)
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
        let vec: [GLKVector3] = [
            GLKVector3(v: (-0.5, 0.0, 0.0)),
            GLKVector3(v: ( 0.5, 0.0, 0.0)),
            GLKVector3(v: ( 0.0, 0.5, 0.0)),
        ]
        
        glEnable(GLenum(GL_DEPTH_TEST))
        glClearColor(0.1, 0.2, 0.2, 1.0)
        glGenVertexArrays(1, &VAO)
        glBindVertexArray(VAO)
        glGenBuffers(1, &VBO)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO)
        glBufferData(GLenum(GL_ARRAY_BUFFER), vec.size, vec, GLenum(GL_STATIC_DRAW))
        let index = shader.glGetAttribLocation(name: "aPosition")
        glEnableVertexAttribArray(GLuint(index))
        glVertexAttribPointer(
            GLuint(index), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLKVector3>.stride), .none)
    }
    
    private var green: GLfloat { return GLfloat(CACurrentMediaTime()) }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        glBindVertexArray(VAO)
        shader.use()
        shader.setUniform4f(name: "ourColor", x: 0.1, y: sin(green), z: 0.3, w: 1.0)
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
        glBindVertexArray(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
    }
}