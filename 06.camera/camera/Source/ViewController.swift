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
    private lazy var texture1: Texture? = {
        if let bundle = Bundle.main.path(forResource: "textures", ofType: "bundle"),
           let container = UIImage(contentsOfFile: bundle.appending("/container.jpg"))?.cgImage {
            return Texture(image: container)
        }
        return .none
    }()
    
    private lazy var cubes: [GLKVector3] = {
        return [
            GLKVector3(v: (0.0,  0.0,  0.0)),
            GLKVector3(v: (2.0,  5.0, -15.0)),
            GLKVector3(v: (-1.5, -2.2, -2.5)),
            GLKVector3(v: (-3.8, -2.0, -12.3)),
            GLKVector3(v: (2.4, -0.4, -3.5)),
            GLKVector3(v: (-1.7,  3.0, -7.5)),
            GLKVector3(v: (1.3, -2.0, -2.5)),
            GLKVector3(v: (1.5,  2.0, -2.5)),
            GLKVector3(v: (1.5,  0.2, -1.5)),
            GLKVector3(v: (-1.3,  1.0, -1.5))
        ]
    }()
    
    private lazy var texture2: Texture? = {
        if let bundle = Bundle.main.path(forResource: "textures", ofType: "bundle"),
           let face = UIImage(contentsOfFile: bundle.appending("/awesomeface.png"))?.cgImage {
            return Texture(image: face)
        }
        return .none
    }()
    
    private var width: CGFloat {
        return view.window?.screen.bounds.width ?? 0.0
    }
    
    private var height: CGFloat {
        return view.window?.screen.bounds.height ?? 0.0
    }
    
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
        let vec: [GLfloat] = [
            //
            -0.3, -0.3, -0.3, 0.0, 0.0,
             0.3, -0.3, -0.3, 1.0, 0.0,
             0.3,  0.3, -0.3, 1.0, 1.0,
             0.3,  0.3, -0.3, 1.0, 1.0,
             -0.3,  0.3, -0.3, 0.0, 1.0,
             -0.3, -0.3, -0.3, 0.0, 0.0,
             //
             -0.3, -0.3, 0.3, 0.0, 0.0,
             0.3, -0.3, 0.3, 1.0, 0.0,
             0.3,  0.3, 0.3, 1.0, 1.0,
             0.3,  0.3, 0.3, 1.0, 1.0,
             -0.3,  0.3, 0.3, 0.0, 1.0,
             -0.3, -0.3, 0.3, 0.0, 0.0,
             //
             -0.3,  0.3,  0.3, 1.0, 0.0,
             -0.3,  0.3, -0.3, 1.0, 1.0,
             -0.3, -0.3, -0.3, 0.0, 1.0,
             -0.3, -0.3, -0.3, 0.0, 1.0,
             -0.3, -0.3,  0.3, 0.0, 0.0,
             -0.3,  0.3,  0.3, 1.0, 0.0,
             //
             0.3,  0.3,  0.3, 1.0, 0.0,
             0.3,  0.3, -0.3, 1.0, 1.0,
             0.3, -0.3, -0.3, 0.0, 1.0,
             0.3, -0.3, -0.3, 0.0, 1.0,
             0.3, -0.3,  0.3, 0.0, 0.0,
             0.3,  0.3,  0.3, 1.0, 0.0,
             //
             -0.3, -0.3, -0.3, 0.0, 1.0,
             0.3, -0.3, -0.3, 1.0, 1.0,
             0.3, -0.3,  0.3, 1.0, 0.0,
             0.3, -0.3,  0.3, 1.0, 0.0,
             -0.3, -0.3,  0.3, 0.0, 0.0,
             -0.3, -0.3, -0.3, 0.0, 1.0,
             //
             -0.3, 0.3, -0.3, 0.0, 1.0,
             0.3, 0.3, -0.3, 1.0, 1.0,
             0.3, 0.3,  0.3, 1.0, 0.0,
             0.3, 0.3,  0.3, 1.0, 0.0,
             -0.3, 0.3,  0.3, 0.0, 0.0,
             -0.3, 0.3, -0.3, 0.0, 1.0
        ]
        
        glEnable(GLenum(GL_DEPTH_TEST))
        glClearColor(0.1, 0.2, 0.2, 1.0)
        glGenVertexArrays(1, &VAO)
        glBindVertexArray(VAO)
        glGenBuffers(1, &VBO)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO)
        glBufferData(GLenum(GL_ARRAY_BUFFER), vec.size, vec, GLenum(GL_STATIC_DRAW))
        
        let aPosition = shader.getAttribLocation(name: "aPosition")
        glEnableVertexAttribArray(GLuint(aPosition))
        glVertexAttribPointer(
            GLuint(aPosition), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.stride * 5), .none)
        
        let aTexCoord = shader.getAttribLocation(name: "aTexCoord")
        glEnableVertexAttribArray(GLuint(aTexCoord))
        glVertexAttribPointer(GLuint(aTexCoord), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.stride * 5), UnsafePointer(bitPattern: MemoryLayout<GLfloat>.stride * 3))
        
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
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE)
        }
        glActiveTexture(GLenum(GL_TEXTURE1))
        if let tex2 = texture2?.tex {
            glBindTexture(GLenum(GL_TEXTURE_2D), tex2)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_REPEAT)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_REPEAT)
        }
        let view = GLKMatrix4Translate(Matrix4.identity, 0.0, 0.0, -2)
        let projection = GLKMatrix4MakePerspective(45.0, Float(width / height), 0.1, 100.0)
        shader.setMat4(name: "view", x: view)
        shader.setMat4(name: "projection", x: projection)
        
        glBindVertexArray(VAO)
        
        for i in 1..<11 {
            let cube = cubes[i - 1]
            let model = GLKMatrix4MakeTranslation(cube.v.0, cube.v.1, cube.v.2)
            let m = GLKMatrix4Rotate(model, time * Float(i), 1, 0.3, 0.3)
            shader.setMat4(name: "model", x: m)
            glDrawArrays(GLenum(GL_TRIANGLES), 0, 36)
        }
    }
}
